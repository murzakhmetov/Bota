import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiService {
  static String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  static const String _model = 'gemini-2.0-flash-lite';
  static String get _baseUrl =>
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent?key=$_apiKey';

  static const String _systemPrompt =
      'Ты - Бота, добрый и умный верблюжонок-помощник для детей 6-10 лет. '
      'Ты помогаешь детям узнавать интересные факты о Казахстане, его культуре, природе и истории. '
      'Отвечай коротко, понятно и дружелюбно. Используй простые слова. '
      'Если ребенок спрашивает про викторину - помоги разобраться в теме, но не давай прямые ответы на вопросы викторины. '
      'Можешь отвечать на казахском или русском языке, в зависимости от языка вопроса. '
      'Не используй эмодзи в ответах. Будь позитивным и поддерживающим.';

  static Future<String> sendMessage(
      String userMessage, List<Map<String, String>> history) async {
    // Convert history to Gemini format (role: user/model)
    final contents = <Map<String, dynamic>>[];
    for (final msg in history) {
      final role = msg['role'] == 'assistant' ? 'model' : 'user';
      contents.add({
        'role': role,
        'parts': [
          {'text': msg['content'] ?? ''}
        ]
      });
    }
    contents.add({
      'role': 'user',
      'parts': [
        {'text': userMessage}
      ]
    });

    final body = json.encode({
      'system_instruction': {
        'parts': [
          {'text': _systemPrompt}
        ]
      },
      'contents': contents,
      'generationConfig': {
        'maxOutputTokens': 300,
        'temperature': 0.7,
      },
    });

    try {
      final response = await http
          .post(
            Uri.parse(_baseUrl),
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text']
            as String?;
        return text ?? 'Извини, я не смог ответить. Попробуй ещё раз!';
      } else if (response.statusCode == 401 || response.statusCode == 403) {
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
