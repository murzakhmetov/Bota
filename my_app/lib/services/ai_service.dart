import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiService {
  static String get _apiKey => dotenv.env['GROQ_API_KEY'] ?? '';
  static const String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const String _model = 'llama-3.1-8b-instant';

  static const String _systemPrompt = '''
Ты - Бота, добрый и умный верблюжонок-помощник для детей 6-10 лет.
Ты помогаешь детям узнавать интересные факты о Казахстане, его культуре, природе и истории.
Отвечай коротко, понятно и дружелюбно. Используй простые слова.
Если ребенок спрашивает про викторину - помоги разобраться в теме, но не давай прямые ответы на вопросы викторины.
Можешь отвечать на казахском или русском языке, в зависимости от языка вопроса.
Не используй эмодзи в ответах. Будь позитивным и поддерживающим.
''';

  static Future<String> sendMessage(
      String userMessage, List<Map<String, String>> history) async {
    final messages = <Map<String, String>>[
      {'role': 'system', 'content': _systemPrompt},
      ...history,
      {'role': 'user', 'content': userMessage},
    ];

    try {
      final client = http.Client();
      final request = http.Request('POST', Uri.parse(_baseUrl));
      request.headers['Authorization'] = 'Bearer $_apiKey';
      request.headers['Content-Type'] = 'application/json';
      request.body = json.encode({
        'model': _model,
        'messages': messages,
        'max_tokens': 300,
        'temperature': 0.7,
      });

      final streamedResponse = await client.send(request)
          .timeout(const Duration(seconds: 20));
      final response = await http.Response.fromStream(streamedResponse);
      client.close();

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final content =
            data['choices']?[0]?['message']?['content'] as String?;
        return content ?? 'Извини, я не смог ответить. Попробуй ещё раз!';
      } else if (response.statusCode == 401) {
        return 'Ошибка авторизации. Проверь API ключ.';
      } else if (response.statusCode == 429) {
        return 'Слишком много запросов. Попробуй через несколько секунд!';
      } else {
        return 'Сервер ответил с ошибкой ${response.statusCode}. Попробуй позже!';
      }
    } on TimeoutException {
      return 'Запрос занял слишком много времени. Проверь интернет и попробуй снова!';
    } on SocketException catch (e) {
      return 'Нет подключения к серверу (${e.message}). Проверь интернет!';
    } on HandshakeException {
      return 'Ошибка безопасного соединения. Попробуй снова!';
    } catch (e) {
      return 'Ошибка: ${e.runtimeType}. Попробуй снова!';
    }
  }
}
