import 'package:flutter/material.dart';
import '../models/child_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import '../services/supabase_service.dart';

class GameProvider extends ChangeNotifier {
  ChildProfile _profile = ChildProfile();
  bool _isRussian = true;
  bool _onboardingComplete = false;
  bool _parentModeActive = false;
  bool _isLoaded = false;
  final String _parentPin = '1234';
  DateTime? _sessionStart;
  bool _screenTimeLimitReached = false;

  ChildProfile get profile => _profile;
  bool get isRussian => _isRussian;
  bool get onboardingComplete => _onboardingComplete;
  bool get parentModeActive => _parentModeActive;
  bool get screenTimeLimitReached => _screenTimeLimitReached;
  bool get isLoaded => _isLoaded;

  String t(String kz, String ru) => _isRussian ? ru : kz;

  GameProvider() {
    _loadProfile();
    _sessionStart = DateTime.now();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString('child_profile');
    if (profileJson != null) {
      final data = json.decode(profileJson) as Map<String, dynamic>;
      _profile = ChildProfile(
        name: data['name'] ?? '',
        age: data['age'] ?? 7,
        botakoins: data['botakoins'] ?? 0,
        totalGamesPlayed: data['totalGamesPlayed'] ?? 0,
        totalCorrectAnswers: data['totalCorrectAnswers'] ?? 0,
        achievements: List<String>.from(data['achievements'] ?? []),
        unlockedLocations: List<String>.from(data['unlockedLocations'] ?? ['almaty']),
        dailyMinutesUsed: data['dailyMinutesUsed'] ?? 0,
        screenTimeLimit: data['screenTimeLimit'] ?? 30,
        avatarIndex: data['avatarIndex'] ?? 0,
        referralCode: data['referralCode'] ?? '',
        friendsInvited: data['friendsInvited'] ?? 0,
        dailyQuestCompleted: data['dailyQuestCompleted'] ?? false,
        lastDailyQuestDate: data['lastDailyQuestDate'],
      );
      _onboardingComplete = data['onboardingComplete'] ?? false;
      _isRussian = data['isRussian'] ?? true;
    }
    _checkDailyQuestReset();
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'name': _profile.name,
      'age': _profile.age,
      'botakoins': _profile.botakoins,
      'totalGamesPlayed': _profile.totalGamesPlayed,
      'totalCorrectAnswers': _profile.totalCorrectAnswers,
      'achievements': _profile.achievements,
      'unlockedLocations': _profile.unlockedLocations,
      'dailyMinutesUsed': _profile.dailyMinutesUsed,
      'screenTimeLimit': _profile.screenTimeLimit,
      'onboardingComplete': _onboardingComplete,
      'isRussian': _isRussian,
      'avatarIndex': _profile.avatarIndex,
      'referralCode': _profile.referralCode,
      'friendsInvited': _profile.friendsInvited,
      'dailyQuestCompleted': _profile.dailyQuestCompleted,
      'lastDailyQuestDate': _profile.lastDailyQuestDate,
    };
    await prefs.setString('child_profile', json.encode(data));
    _syncToCloud();
  }

  Future<void> _syncToCloud() async {
    final prefs = await SharedPreferences.getInstance();
    var deviceId = prefs.getString('device_id');
    if (deviceId == null) {
      deviceId = DateTime.now().microsecondsSinceEpoch.toString();
      await prefs.setString('device_id', deviceId);
    }
    await SupabaseService.syncProfile(
      deviceId: deviceId,
      profileData: {
        'name': _profile.name,
        'age': _profile.age,
        'botakoins': _profile.botakoins,
        'total_games_played': _profile.totalGamesPlayed,
        'total_correct_answers': _profile.totalCorrectAnswers,
        'achievements': _profile.achievements,
        'unlocked_locations': _profile.unlockedLocations,
        'screen_time_limit': _profile.screenTimeLimit,
        'daily_minutes_used': _profile.dailyMinutesUsed,
      },
    );
  }

  void toggleLanguage() {
    _isRussian = !_isRussian;
    _saveProfile();
    notifyListeners();
  }

  String _generateReferralCode(String name) {
    final rng = Random();
    final code = '${name.toUpperCase().replaceAll(' ', '').substring(0, name.length.clamp(0, 4))}${rng.nextInt(9000) + 1000}';
    return code;
  }

  void completeOnboarding(String name, int age, int avatarIndex) {
    _profile.name = name;
    _profile.age = age;
    _profile.avatarIndex = avatarIndex;
    _profile.referralCode = _generateReferralCode(name);
    _onboardingComplete = true;
    _profile.unlockedLocations = ['almaty', 'astana'];
    _addAchievement('first_step');
    _saveProfile();
    notifyListeners();
  }

  void setAvatar(int index) {
    _profile.avatarIndex = index;
    _saveProfile();
    notifyListeners();
  }

  void inviteFriend() {
    _profile.friendsInvited++;
    addBotakoins(15);
  }

  void redeemReferralCode(String code) {
    if (code.isNotEmpty) {

      addBotakoins(15);
    }
  }

  void completeDailyQuest() {
    if (!_profile.dailyQuestCompleted) {
      _profile.dailyQuestCompleted = true;
      final now = DateTime.now();
      _profile.lastDailyQuestDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      addBotakoins(30);
      _saveProfile();
      notifyListeners();
    }
  }

  void _checkDailyQuestReset() {
    final now = DateTime.now();
    final today = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    if (_profile.lastDailyQuestDate != today) {
      _profile.dailyQuestCompleted = false;
    }
  }

  void addBotakoins(int amount) {
    _profile.botakoins += amount;
    _checkBotakoinAchievements();
    _saveProfile();
    notifyListeners();
  }

  bool spendBotakoins(int amount) {
    if (_profile.botakoins >= amount) {
      _profile.botakoins -= amount;
      _saveProfile();
      notifyListeners();
      return true;
    }
    return false;
  }

  void completeGame(String gameId, int score, int correctAnswers) {
    _profile.totalGamesPlayed++;
    _profile.totalCorrectAnswers += correctAnswers;

    final best = _profile.gameBestScores[gameId] ?? 0;
    if (score > best) {
      _profile.gameBestScores[gameId] = score;
    }

    int earned = 2 + (correctAnswers.clamp(0, 8));
    if (score > best && best > 0) {
      earned += 2;
    }
    addBotakoins(earned);

    _checkGameAchievements(gameId);
    _checkLevelUnlocks();
    _saveProfile();
    notifyListeners();
  }

  void _checkBotakoinAchievements() {
    if (_profile.botakoins >= 50) _addAchievement('collector_50');
    if (_profile.botakoins >= 100) _addAchievement('collector_100');
    if (_profile.botakoins >= 500) _addAchievement('collector_500');
  }

  void _checkGameAchievements(String gameId) {
    if (_profile.totalGamesPlayed >= 1) _addAchievement('first_game');
    if (_profile.totalGamesPlayed >= 5) _addAchievement('games_5');
    if (_profile.totalGamesPlayed >= 10) _addAchievement('games_10');
    if (_profile.totalGamesPlayed >= 25) _addAchievement('games_25');
  }

  void _checkLevelUnlocks() {
    if (_profile.level >= 2) {
      if (!_profile.unlockedLocations.contains('turkestan')) {
        _profile.unlockedLocations.add('turkestan');
        _profile.unlockedLocations.add('steppe');
      }
    }
    if (_profile.level >= 3) {
      if (!_profile.unlockedLocations.contains('charyn')) {
        _profile.unlockedLocations.add('charyn');
      }
    }
  }

  void _addAchievement(String id) {
    if (!_profile.achievements.contains(id)) {
      _profile.achievements.add(id);
    }
  }

  bool verifyParentPin(String pin) {
    return pin == _parentPin;
  }

  void enterParentMode() {
    _parentModeActive = true;
    notifyListeners();
  }

  void exitParentMode() {
    _parentModeActive = false;
    notifyListeners();
  }

  void setScreenTimeLimit(int minutes) {
    _profile.screenTimeLimit = minutes;
    _saveProfile();
    notifyListeners();
  }

  int get sessionMinutes {
    if (_sessionStart == null) return 0;
    return DateTime.now().difference(_sessionStart!).inMinutes;
  }

  void checkScreenTime() {
    if (sessionMinutes >= _profile.screenTimeLimit) {
      _screenTimeLimitReached = true;
      notifyListeners();
    }
  }

  void resetScreenTime() {
    _sessionStart = DateTime.now();
    _screenTimeLimitReached = false;
    _profile.dailyMinutesUsed = 0;
    _saveProfile();
    notifyListeners();
  }

  void resetProgress() {
    _profile = ChildProfile();
    _onboardingComplete = false;
    _saveProfile();
    notifyListeners();
  }

  static const Map<String, Map<String, String>> achievementDefs = {
    'first_step': {
      'nameKz': 'Бірінші қадам',
      'nameRu': 'Первый шаг',
      'icon': '👣',
      'descKz': 'Саяхатты бастадың!',
      'descRu': 'Начал путешествие!',
    },
    'first_game': {
      'nameKz': 'Бірінші ойын',
      'nameRu': 'Первая игра',
      'icon': '🎮',
      'descKz': 'Бірінші ойынды өттің!',
      'descRu': 'Прошёл первую игру!',
    },
    'games_5': {
      'nameKz': '5 ойын',
      'nameRu': '5 игр',
      'icon': '⭐',
      'descKz': '5 ойын ойнадың!',
      'descRu': 'Сыграл 5 игр!',
    },
    'games_10': {
      'nameKz': '10 ойын',
      'nameRu': '10 игр',
      'icon': '🌟',
      'descKz': '10 ойын ойнадың!',
      'descRu': 'Сыграл 10 игр!',
    },
    'games_25': {
      'nameKz': '25 ойын',
      'nameRu': '25 игр',
      'icon': '🏆',
      'descKz': '25 ойын ойнадың!',
      'descRu': 'Сыграл 25 игр!',
    },
    'collector_50': {
      'nameKz': '50 ботакоин',
      'nameRu': '50 ботакоинов',
      'icon': '🪙',
      'descKz': '50 ботакоин жинадың!',
      'descRu': 'Собрал 50 ботакоинов!',
    },
    'collector_100': {
      'nameKz': '100 ботакоин',
      'nameRu': '100 ботакоинов',
      'icon': '💰',
      'descKz': '100 ботакоин жинадың!',
      'descRu': 'Собрал 100 ботакоинов!',
    },
    'collector_500': {
      'nameKz': '500 ботакоин',
      'nameRu': '500 ботакоинов',
      'icon': '👑',
      'descKz': '500 ботакоин жинадың!',
      'descRu': 'Собрал 500 ботакоинов!',
    },
  };
}
