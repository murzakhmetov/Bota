/// Offline hardcoded version — no internet required.
class SupabaseService {
  static Future<void> initialize() async {}

  static String getImageUrl(String path) => '';

  static Future<List<Map<String, dynamic>>> getWords() async => [
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

  static Future<List<Map<String, dynamic>>> getQuizQuestions() async => [
    {'question_kz': 'Қазақстанның астанасы қай қала?', 'question_ru': 'Какой город является столицей Казахстана?', 'answers': ['Астана','Алматы','Шымкент','Караганда'], 'correct_index': 0, 'fact': 'Астана стала столицей в 1997 году!'},
    {'question_kz': 'Қазақстандағы ең биік тау?', 'question_ru': 'Самая высокая гора Казахстана?', 'answers': ['Хан-Тенгри','Белуха','Эльбрус','Монблан'], 'correct_index': 0, 'fact': 'Хан-Тенгри — 6995 метров!'},
    {'question_kz': 'Қазақстан жалауының түсі?', 'question_ru': 'Какого цвета флаг Казахстана?', 'answers': ['Голубой','Зелёный','Красный','Белый'], 'correct_index': 0, 'fact': 'Голубой символизирует мир и единство!'},
    {'question_kz': 'Қазақстанда қандай жануар ұлттық символ?', 'question_ru': 'Какое животное — национальный символ Казахстана?', 'answers': ['Барс','Тигр','Медведь','Волк'], 'correct_index': 0, 'fact': 'Снежный барс — ирбис — символ силы!'},
    {'question_kz': 'Байтерек ескерткіші қай қалада?', 'question_ru': 'В каком городе монумент Байтерек?', 'answers': ['Астана','Алматы','Атырау','Актау'], 'correct_index': 0, 'fact': 'Высота Байтерека — 97 метров!'},
    {'question_kz': 'Қазақстандағы ең үлкен көл?', 'question_ru': 'Самое большое озеро Казахстана?', 'answers': ['Балхаш','Алаколь','Боровое','Иссык'], 'correct_index': 0, 'fact': 'Балхаш уникален: одна половина пресная, другая солёная!'},
    {'question_kz': 'Қазақтың ұлттық спорт ойыны?', 'question_ru': 'Национальный вид спорта казахов?', 'answers': ['Кокпар','Футбол','Хоккей','Теннис'], 'correct_index': 0, 'fact': 'Кокпар — конная игра, которой более 1000 лет!'},
    {'question_kz': 'Қожа Ахмет Яссауи кесенесі қай қалада?', 'question_ru': 'Где находится мавзолей Ходжи Ахмеда Яссауи?', 'answers': ['Туркестан','Шымкент','Тараз','Кызылорда'], 'correct_index': 0, 'fact': 'Мавзолей построен по приказу Тамерлана в XIV веке!'},
    {'question_kz': 'Баян Сулу фабрикасы қай қалада?', 'question_ru': 'В каком городе фабрика Баян Сулу?', 'answers': ['Костанай','Алматы','Астана','Караганда'], 'correct_index': 0, 'fact': 'Баян Сулу — крупнейший производитель сладостей!'},
    {'question_kz': 'Қазақтың ұлттық ішімдігі?', 'question_ru': 'Национальный напиток казахов?', 'answers': ['Кумыс','Чай','Кофе','Айран'], 'correct_index': 0, 'fact': 'Кумыс делают из кобыльего молока!'},
    {'question_kz': 'Шарын шатқалын қалай атайды?', 'question_ru': 'Как ещё называют Чарынский каньон?', 'answers': ['Младший брат Гранд-Каньона','Золотой каньон','Великий каньон','Красный каньон'], 'correct_index': 0, 'fact': 'Ему 12 миллионов лет!'},
    {'question_kz': 'Қазақстан қай құрлықта орналасқан?', 'question_ru': 'На каком континенте расположен Казахстан?', 'answers': ['Евразия','Европа','Азия','Африка'], 'correct_index': 0, 'fact': 'Казахстан расположен и в Европе, и в Азии!'},
  ];

  static Future<List<Map<String, dynamic>>> getShopItems() async => [
    {'name_kz': 'Стикер-пак Бота', 'name_ru': 'Стикер-пак Бота', 'image_path': 'store/stickers.png', 'price': 30, 'description': '5 стикеров'},
    {'name_kz': 'Түсті жақтау', 'name_ru': 'Цветная рамка', 'image_path': 'store/frame.png', 'price': 50, 'description': 'Для фото с Ботой'},
    {'name_kz': '10% жеңілдік', 'name_ru': '10% скидка', 'image_path': 'store/discount.png', 'price': 100, 'description': 'На продукцию Бота'},
    {'name_kz': 'Бота ойыншық', 'name_ru': 'Игрушка Бота', 'image_path': 'store/camel.png', 'price': 200, 'description': 'Мягкая игрушка'},
    {'name_kz': 'Сыйлық жинағы', 'name_ru': 'Подарочный набор', 'image_path': 'store/sweets.png', 'price': 500, 'description': 'Набор сладостей'},
    {'name_kz': 'VIP Саяхатшы', 'name_ru': 'VIP Путешественник', 'image_path': 'store/crown.png', 'price': 1000, 'description': 'Эксклюзивный статус'},
  ];

  static Future<List<String>> getCandyImages() async => [
    'candies/candy0.jpeg', 'candies/candy1.jpeg', 'candies/candy2.jpeg',
    'candies/candy3.jpeg', 'candies/candy4.jpeg', 'candies/candy5.jpeg',
    'candies/candy6.jpeg', 'candies/candy7.jpeg', 'candies/candy8.jpeg',
    'candies/candy10.jpeg', 'candies/candy20.jpeg', 'candies/candy21.jpeg',
  ];

  static Future<List<String>> getObstacleImages() async => [
    'catchgame/pepper.png', 'catchgame/stone.png', 'catchgame/bomb.png',
  ];

  static Future<List<Map<String, dynamic>>> getQuestScenes() async => [
    {'bg_colors': ['#1a1a2e','#16213e'], 'title_kz': 'Шарын шатқалы', 'title_ru': 'Чарынский каньон', 'text_kz': 'КамБот Шарын шатқалына келді. Алдында екі жол бар. Қайсысын таңдайсың?', 'text_ru': 'КамБот пришёл к Чарынскому каньону. Впереди две дороги. Какую выберешь?', 'choices': [{'textKz': 'Жасыл орман жолы', 'textRu': 'Через зелёный лес', 'correct': true, 'replyKz': 'Жарайсың! Орманда сирек кездесетін ағаштар бар!', 'replyRu': 'Молодец! В лесу растут редкие деревья!'}, {'textKz': 'Құм жолы', 'textRu': 'Через пустыню', 'correct': false, 'replyKz': 'Құмда ыстық! Бірақ КамБот шыдамды', 'replyRu': 'В пустыне жарко! Но КамБот выносливый'}]},
    {'bg_colors': ['#0f3460','#533483'], 'title_kz': 'Бүркіт кездесті!', 'title_ru': 'Встреча с орлом!', 'text_kz': 'Жолда КамБот бүркіт кездестірді. Қазақтардың ұлттық құсы кім?', 'text_ru': 'КамБот встретил орла-беркута. Какая птица — символ казахов?', 'choices': [{'textKz': 'Бүркіт (Беркут)', 'textRu': 'Беркут', 'correct': true, 'replyKz': 'Дұрыс! Бүркіт — қазақтардың құрметті құсы!', 'replyRu': 'Верно! Беркут — символ свободы!'}, {'textKz': 'Тоты құс', 'textRu': 'Попугай', 'correct': false, 'replyKz': 'Жоқ, бірақ тоты құс та керемет!', 'replyRu': 'Нет, но попугаи тоже классные!'}]},
    {'bg_colors': ['#533483','#e94560'], 'title_kz': 'Тау шыңы', 'title_ru': 'Горная вершина', 'text_kz': 'КамБот тау шыңына жетті! Не істейсің?', 'text_ru': 'КамБот добрался до вершины! Что делаешь?', 'choices': [{'textKz': 'Фото түсіру', 'textRu': 'Сделать фото', 'correct': true, 'replyKz': 'Тамаша! Шарын 12 миллион жыл бұрын пайда болған!', 'replyRu': 'Отлично! Каньону 12 миллионов лет!'}, {'textKz': 'Тынығу', 'textRu': 'Отдохнуть', 'correct': false, 'replyKz': 'Дұрыс, демалу да маңызды!', 'replyRu': 'Правильно, отдых тоже важен!'}]},
    {'bg_colors': ['#e94560','#FF8C00'], 'title_kz': 'Қазына!', 'title_ru': 'Сокровище!', 'text_kz': 'КамБот үңгірде жасырылған қазына тапты! Саяхат аяқталды!', 'text_ru': 'КамБот нашёл спрятанное сокровище! Путешествие завершено!', 'choices': [{'textKz': 'Ботакоиндерді жинау!', 'textRu': 'Собрать ботакоины!', 'correct': true, 'replyKz': 'Сен батыл саяхатшысың!', 'replyRu': 'Ты настоящий путешественник!'}, {'textKz': 'Шоколадты алу!', 'textRu': 'Взять шоколад!', 'correct': true, 'replyKz': 'Баян Сулу шоколады — ең дәмді!', 'replyRu': 'Шоколад Баян Сулу — самый вкусный!'}]},
  ];

  static Future<void> syncProfile({required String deviceId, required Map<String, dynamic> profileData}) async {}
  static Future<Map<String, dynamic>?> loadProfile(String deviceId) async => null;
  static Future<void> refreshCache() async {}
}
