import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupabaseService {
  static const String _supabaseUrl = 'https://nuacawcczjetqwgazemt.supabase.co';
  static const String _supabaseAnonKey = 'sb_publishable_Qt38_gqGZbnn30GdgpJKBQ_sei5OD9B';
  static const String _bucket = 'MyBucket';

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
    );
  }

  static String getImageUrl(String path) {
    return client.storage.from(_bucket).getPublicUrl(path);
  }

  static Future<List<Map<String, dynamic>>> getWords() async {
    try {
      final data = await client.from('words').select().order('id');
      final list = List<Map<String, dynamic>>.from(data);
      if (list.isNotEmpty) {
        await _setCache('words', list);
        return list;
      }
    } catch (_) {}
    final cached = await _getCache('words');
    if (cached != null && cached.isNotEmpty) return cached;
    return _defaultWords();
  }

  static Future<List<Map<String, dynamic>>> getQuizQuestions() async {
    try {
      final data = await client.from('quiz_questions').select().order('id');
      final list = List<Map<String, dynamic>>.from(data);
      if (list.isNotEmpty) {
        await _setCache('quiz_questions', list);
        return list;
      }
    } catch (_) {}
    final cached = await _getCache('quiz_questions');
    if (cached != null && cached.isNotEmpty) return cached;
    return _defaultQuiz();
  }

  static Future<List<Map<String, dynamic>>> getShopItems() async {
    try {
      final data = await client.from('shop_items').select().order('price');
      final list = List<Map<String, dynamic>>.from(data);
      if (list.isNotEmpty) {
        await _setCache('shop_items', list);
        return list;
      }
    } catch (_) {}
    final cached = await _getCache('shop_items');
    if (cached != null && cached.isNotEmpty) return cached;
    return _defaultShop();
  }

  static Future<List<String>> getCandyImages() async {
    try {
      final data = await client.from('candy_images').select().eq('category', 'candy').order('id');
      final list = List<Map<String, dynamic>>.from(data);
      if (list.isNotEmpty) {
        await _setCache('candy_images', list);
        return list.map<String>((c) => c['image_path'] as String).toList();
      }
    } catch (_) {}
    final cached = await _getCache('candy_images');
    if (cached != null && cached.isNotEmpty) {
      return cached.map<String>((c) => c['image_path'] as String).toList();
    }
    return _defaultCandyPaths();
  }

  static Future<List<String>> getObstacleImages() async {
    try {
      final data = await client.from('candy_images').select().eq('category', 'obstacle').order('id');
      return List<Map<String, dynamic>>.from(data).map<String>((c) => c['image_path'] as String).toList();
    } catch (_) {
      return ['catchgame/pepper.png', 'catchgame/stone.png', 'catchgame/bomb.png'];
    }
  }

  static Future<List<Map<String, dynamic>>> getQuestScenes() async {
    final cached = await _getCache('quest_scenes');
    if (cached != null) return cached;

    try {
      final data = await client.from('quest_scenes').select().order('scene_order');
      final list = List<Map<String, dynamic>>.from(data);
      if (list.isNotEmpty) {
        await _setCache('quest_scenes', list);
        return list;
      }
    } catch (_) {}
    return _defaultQuestScenes();
  }

  static Future<void> syncProfile({
    required String deviceId,
    required Map<String, dynamic> profileData,
  }) async {
    try {
      await client.from('user_profiles').upsert({
        'device_id': deviceId,
        ...profileData,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'device_id');
    } catch (_) {}
  }

  static Future<Map<String, dynamic>?> loadProfile(String deviceId) async {
    try {
      final data = await client
          .from('user_profiles')
          .select()
          .eq('device_id', deviceId)
          .maybeSingle();
      return data;
    } catch (_) {
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> _getCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('sb_cache_$key');
    if (cached == null) return null;
    try {
      final decoded = json.decode(cached);
      return List<Map<String, dynamic>>.from(
        (decoded as List).map((e) => Map<String, dynamic>.from(e as Map)),
      );
    } catch (_) {
      return null;
    }
  }

  static Future<void> _setCache(String key, List<Map<String, dynamic>> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sb_cache_$key', json.encode(data));
  }

  static Future<void> refreshCache() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in ['words', 'quiz_questions', 'shop_items', 'candy_images', 'quest_scenes']) {
      await prefs.remove('sb_cache_$key');
    }
  }

  static List<Map<String, dynamic>> _defaultWords() => [
    {'kz': 'Алма', 'ru': 'Яблоко', 'image_path': 'words/apple.jpeg'},
    {'kz': 'Жылқы', 'ru': 'Лошадь', 'image_path': 'words/horse.jpeg'},
    {'kz': 'Күн', 'ru': 'Солнце', 'image_path': 'words/sun.jpeg'},
    {'kz': 'Тау', 'ru': 'Гора', 'image_path': 'words/mountains.jpeg'},
    {'kz': 'Су', 'ru': 'Вода', 'image_path': 'words/water.jpeg'},
    {'kz': 'Ай', 'ru': 'Луна', 'image_path': 'words/moon.jpeg'},
    {'kz': 'Бүркіт', 'ru': 'Орёл', 'image_path': 'words/eagle.jpeg'},
    {'kz': 'Түйе', 'ru': 'Верблюд', 'image_path': 'words/camel.jpeg'},
    {'kz': 'Қой', 'ru': 'Овца', 'image_path': 'words/sheep.jpeg'},
    {'kz': 'Гүл', 'ru': 'Цветок', 'image_path': 'words/flower.jpeg'},
    {'kz': 'Аю', 'ru': 'Медведь', 'image_path': 'words/bear.jpeg'},
    {'kz': 'Жұлдыз', 'ru': 'Звезда', 'image_path': 'words/star.jpeg'},
  ];

  static List<Map<String, dynamic>> _defaultQuiz() => [
    {'question_kz': 'Қазақстанның астанасы қай қала?', 'question_ru': 'Какой город является столицей Казахстана?', 'answers': ['Астана','Алматы','Шымкент','Караганда'], 'correct_index': 0, 'fact': 'Астана стала столицей в 1997 году!'},
    {'question_kz': 'Қазақстандағы ең биік тау?', 'question_ru': 'Самая высокая гора Казахстана?', 'answers': ['Хан-Тенгри','Белуха','Эльбрус','Монблан'], 'correct_index': 0, 'fact': 'Хан-Тенгри - 6995 метров!'},
    {'question_kz': 'Қазақстан жалауының түсі?', 'question_ru': 'Какого цвета флаг Казахстана?', 'answers': ['Голубой','Зелёный','Красный','Белый'], 'correct_index': 0, 'fact': 'Голубой символизирует мир!'},
    {'question_kz': 'Байтерек қай қалада?', 'question_ru': 'В каком городе Байтерек?', 'answers': ['Астана','Алматы','Атырау','Актау'], 'correct_index': 0, 'fact': 'Высота 97 метров!'},
    {'question_kz': 'Қазақстандағы ең үлкен көл?', 'question_ru': 'Самое большое озеро?', 'answers': ['Балхаш','Алаколь','Боровое','Иссык'], 'correct_index': 0, 'fact': 'Балхаш уникален!'},
    {'question_kz': 'Ұлттық спорт ойыны?', 'question_ru': 'Национальный спорт?', 'answers': ['Кокпар','Футбол','Хоккей','Теннис'], 'correct_index': 0, 'fact': 'Кокпару более 1000 лет!'},
    {'question_kz': 'Баян Сулу қай қалада?', 'question_ru': 'Где фабрика Баян Сулу?', 'answers': ['Костанай','Алматы','Астана','Караганда'], 'correct_index': 0, 'fact': 'Крупнейший производитель!'},
    {'question_kz': 'Ұлттық ішімдік?', 'question_ru': 'Национальный напиток?', 'answers': ['Кумыс','Чай','Кофе','Айран'], 'correct_index': 0, 'fact': 'Из кобыльего молока!'},
    {'question_kz': 'Ұлттық символ жануар?', 'question_ru': 'Символ Казахстана?', 'answers': ['Барс','Тигр','Медведь','Волк'], 'correct_index': 0, 'fact': 'Снежный барс!'},
    {'question_kz': 'Шарын шатқалы?', 'question_ru': 'Чарынский каньон?', 'answers': ['Младший брат Гранд-Каньона','Золотой','Великий','Красный'], 'correct_index': 0, 'fact': '12 миллионов лет!'},
  ];

  static List<Map<String, dynamic>> _defaultShop() => [
    {'name_kz': 'Стикер-пак Бота', 'name_ru': 'Стикер-пак Бота', 'image_path': 'store/stickers.png', 'price': 30, 'description': '5 стикеров'},
    {'name_kz': 'Түсті жақтау', 'name_ru': 'Цветная рамка', 'image_path': 'store/frame.png', 'price': 50, 'description': 'Для фото с Ботой'},
    {'name_kz': '10% жеңілдік', 'name_ru': '10% скидка', 'image_path': 'store/discount.png', 'price': 100, 'description': 'На продукцию Бота'},
    {'name_kz': 'Бота ойыншық', 'name_ru': 'Игрушка Бота', 'image_path': 'store/camel.png', 'price': 200, 'description': 'Мягкая игрушка'},
    {'name_kz': 'Сыйлық жинағы', 'name_ru': 'Подарочный набор', 'image_path': 'store/sweets.png', 'price': 500, 'description': 'Набор сладостей'},
    {'name_kz': 'VIP Саяхатшы', 'name_ru': 'VIP Путешественник', 'image_path': 'store/crown.png', 'price': 1000, 'description': 'Эксклюзивный статус'},
  ];

  static List<String> _defaultCandyPaths() => [
    'candies/candy0.jpeg', 'candies/candy1.jpeg', 'candies/candy2.jpeg',
    'candies/candy3.jpeg', 'candies/candy4.jpeg', 'candies/candy5.jpeg',
    'candies/candy6.jpeg', 'candies/candy7.jpeg', 'candies/candy8.jpeg',
    'candies/candy10.jpeg', 'candies/candy20.jpeg', 'candies/candy21.jpeg',
  ];

  static List<Map<String, dynamic>> _defaultQuestScenes() => [
    {'bg_colors': ['#1a1a2e','#16213e'], 'title_kz': 'Шарын шатқалы', 'title_ru': 'Чарынский каньон', 'text_kz': 'КамБот Шарын шатқалына келді.', 'text_ru': 'КамБот пришёл к каньону.', 'choices': [{'textKz': 'Орман жолы', 'textRu': 'Через лес', 'correct': true, 'replyKz': 'Жарайсың!', 'replyRu': 'Молодец!'}, {'textKz': 'Құм жолы', 'textRu': 'Через пустыню', 'correct': false, 'replyKz': 'Ыстық!', 'replyRu': 'Жарко!'}]},
    {'bg_colors': ['#0f3460','#533483'], 'title_kz': 'Бүркіт', 'title_ru': 'Орёл', 'text_kz': 'Ұлттық құс кім?', 'text_ru': 'Национальная птица?', 'choices': [{'textKz': 'Бүркіт', 'textRu': 'Беркут', 'correct': true, 'replyKz': 'Дұрыс!', 'replyRu': 'Верно!'}, {'textKz': 'Тоты құс', 'textRu': 'Попугай', 'correct': false, 'replyKz': 'Жоқ!', 'replyRu': 'Нет!'}]},
    {'bg_colors': ['#533483','#e94560'], 'title_kz': 'Тау шыңы', 'title_ru': 'Вершина', 'text_kz': 'Не істейсің?', 'text_ru': 'Что делаешь?', 'choices': [{'textKz': 'Фото', 'textRu': 'Фото', 'correct': true, 'replyKz': 'Тамаша!', 'replyRu': 'Отлично!'}, {'textKz': 'Тынығу', 'textRu': 'Отдохнуть', 'correct': false, 'replyKz': 'Демалу маңызды!', 'replyRu': 'Отдых важен!'}]},
    {'bg_colors': ['#e94560','#FF8C00'], 'title_kz': 'Қазына!', 'title_ru': 'Сокровище!', 'text_kz': 'Қазына таптың!', 'text_ru': 'Нашёл сокровище!', 'choices': [{'textKz': 'Ботакоиндер!', 'textRu': 'Ботакоины!', 'correct': true, 'replyKz': 'Батыл!', 'replyRu': 'Смелый!'}, {'textKz': 'Шоколад!', 'textRu': 'Шоколад!', 'correct': true, 'replyKz': 'Дәмді!', 'replyRu': 'Вкусно!'}]},
  ];
}
