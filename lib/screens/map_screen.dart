import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_colors.dart';
import '../models/map_location.dart';
import '../widgets/game_widgets.dart';
import 'game_memory_screen.dart';
import 'game_words_screen.dart';
import 'game_math_screen.dart';
import 'game_puzzle_screen.dart';
import 'game_quiz_screen.dart';
import 'game_quest_screen.dart';
import 'game_catch_screen.dart';
import 'shop_screen.dart';
import 'parent_screen.dart';
import 'daily_reward_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      duration: const Duration(seconds: 2), vsync: this,
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _openGame(String gameId, String locationName) {
    Widget screen;
    switch (gameId) {
      case 'memory':
        screen = GameMemoryScreen(locationName: locationName);
        break;
      case 'words':
        screen = GameWordsScreen(locationName: locationName);
        break;
      case 'math':
        screen = GameMathScreen(locationName: locationName);
        break;
      case 'puzzle':
        screen = GamePuzzleScreen(locationName: locationName);
        break;
      case 'quiz':
        screen = GameQuizScreen(locationName: locationName);
        break;
      case 'quest':
        screen = GameQuestScreen(locationName: locationName);
        break;
      case 'catch':
        screen = GameCatchScreen(locationName: locationName);
        break;
      default:
        screen = GameMemoryScreen(locationName: locationName);
    }
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, anim, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  static const _gameNames = {
    'memory': {'icon': '🃏', 'nameKz': 'Жадты жаттықтыр', 'nameRu': 'Тренируй память'},
    'words': {'icon': '📝', 'nameKz': 'Қазақ сөздері', 'nameRu': 'Казахские слова'},
    'math': {'icon': '🔢', 'nameKz': 'Бота санайды', 'nameRu': 'Считай с Ботой'},
    'puzzle': {'icon': '🧩', 'nameKz': 'Баян Сулу Пазл', 'nameRu': 'Пазл Баян Сулу'},
    'quiz': {'icon': '❓', 'nameKz': 'Викторина', 'nameRu': 'Викторина'},
    'quest': {'icon': '📖', 'nameKz': 'Мини-квест', 'nameRu': 'Мини-квест'},
    'catch': {'icon': '🍬', 'nameKz': 'Кәмпитті ұста', 'nameRu': 'Поймай конфету'},
  };

  static const _locGradients = {
    'almaty': [Color(0xFF1a7a2e), Color(0xFF4CAF50), Color(0xFF81C784)],
    'astana': [Color(0xFF1565C0), Color(0xFF42A5F5), Color(0xFF90CAF9)],
    'turkestan': [Color(0xFFBF360C), Color(0xFFE65100), Color(0xFFFF8F00)],
    'charyn': [Color(0xFFC62828), Color(0xFFEF5350), Color(0xFFFF8A80)],
    'steppe': [Color(0xFFE65100), Color(0xFFF9A825), Color(0xFFFFF176)],
  };

  @override
  Widget build(BuildContext context) {
    final p = context.watch<GameProvider>();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF8F0), Color(0xFFFFE4B5), Color(0xFFFFDAB9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(children: [
            _topBar(p),
            Expanded(child: _body(p)),
            _bottomNav(p),
          ]),
        ),
      ),
    );
  }

  Widget _body(GameProvider p) {
    switch (_navIndex) {
      case 0:
        return _mapView(p);
      default:
        return _mapView(p);
    }
  }


  Widget _topBar(GameProvider p) => Container(
    margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(children: [
      Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.primaryGradient,
          boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 8)],
        ),
        child: ClipOval(child: Image.asset('assets/cumbot/glad.png', width: 32, height: 32, fit: BoxFit.cover)),
      ),
      const SizedBox(width: 10),
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(p.profile.name,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary)),
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text('Lv.${p.profile.level}',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primary)),
            ),
            const SizedBox(width: 6),
            Expanded(child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: p.profile.progressToNextLevel,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                minHeight: 4,
              ),
            )),
          ]),
        ],
      )),
      const SizedBox(width: 8),
      GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DailyRewardScreen())),
        child: AnimatedBuilder(
          animation: _pulseAnim,
          builder: (_, child) => Transform.scale(scale: _pulseAnim.value, child: child),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.botakoin.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.botakoin.withValues(alpha: 0.3)),
            ),
            child: Image.asset('assets/cumbot/withcoins.png', width: 24, height: 24),
          ),
        ),
      ),
      const SizedBox(width: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFFA500)]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.botakoin.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset('assets/coin/coin.jpeg', width: 16, height: 16, fit: BoxFit.cover),
          ),
          const SizedBox(width: 4),
          Text('${p.profile.botakoins}',
            style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 14)),
        ]),
      ),
    ]),
  );


  Widget _mapView(GameProvider p) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Text(
              p.t('Саяхат картасы 🗺️', 'Карта путешествий 🗺️'),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              p.t('Локацияны таңда және ойын бастай!', 'Выбери локацию и начни играть!'),
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 20),
          ...MapLocation.allLocations.map((loc) {
            final isUnlocked = p.profile.unlockedLocations.contains(loc.id);
            return _locationCard(loc, isUnlocked, p);
          }),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _locationCard(MapLocation loc, bool isUnlocked, GameProvider p) {
    final gradColors = _locGradients[loc.id] ?? [Colors.grey, Colors.grey.shade600, Colors.grey.shade400];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (isUnlocked ? loc.color : Colors.black).withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(
              gradient: isUnlocked
                  ? LinearGradient(colors: gradColors, begin: Alignment.topLeft, end: Alignment.bottomRight)
                  : LinearGradient(colors: [Colors.white, Colors.grey.shade100]),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      width: 56, height: 56,
                      decoration: BoxDecoration(
                        color: isUnlocked ? Colors.white.withValues(alpha: 0.25) : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(child: Text(
                        isUnlocked ? loc.icon : '🔒',
                        style: const TextStyle(fontSize: 30),
                      )),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.isRussian ? loc.nameRu : loc.nameKz,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: isUnlocked ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          p.isRussian ? loc.descriptionRu : loc.descriptionKz,
                          style: TextStyle(
                            fontSize: 13,
                            color: isUnlocked ? Colors.white.withValues(alpha: 0.9) : AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )),
                    if (!isUnlocked)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          p.t('Lv.${loc.requiredLevel}', 'Ур.${loc.requiredLevel}'),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                  ]),
                  if (isUnlocked) ...[
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: loc.gameIds.map((gid) {
                          final gn = _gameNames[gid]!;
                          return GestureDetector(
                            onTap: () => _openGame(gid, p.isRussian ? loc.nameRu : loc.nameKz),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                              ),
                              child: Row(mainAxisSize: MainAxisSize.min, children: [
                                Text(gn['icon']!, style: const TextStyle(fontSize: 18)),
                                const SizedBox(width: 8),
                                Text(
                                  p.isRussian ? gn['nameRu']! : gn['nameKz']!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ]),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isUnlocked) Positioned(
            right: -10,
            top: -10,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.15,
                child: Text(loc.icon, style: const TextStyle(fontSize: 120)),
              ),
            ),
          ),
        ]),
      ),
    );
  }


  Widget _bottomNav(GameProvider p) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _navItem(Icons.map_rounded, p.t('Карта', 'Карта'), 0,
          () => setState(() => _navIndex = 0)),
        _navItem(Icons.store_rounded, p.t('Дүкен', 'Магазин'), 1,
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopScreen()))),
        _navItem(Icons.emoji_events_rounded, p.t('Жетістік', 'Награды'), 2,
          () => _showAchievements(p)),
        _navItem(Icons.person_rounded, p.t('Ата-ана', 'Родитель'), 3,
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ParentScreen()))),
        _navItem(Icons.language_rounded, p.isRussian ? 'ҚАЗ' : 'РУС', 4,
          () => p.toggleLanguage()),
      ],
    ),
  );

  Widget _navItem(IconData icon, String label, int idx, VoidCallback onTap) {
    final active = idx == _navIndex && idx == 0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: active ? AppColors.primary : AppColors.textSecondary, size: 24),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(
            fontSize: 10,
            fontWeight: active ? FontWeight.w800 : FontWeight.w600,
            color: active ? AppColors.primary : AppColors.textSecondary,
          )),
        ]),
      ),
    );
  }


  void _showAchievements(GameProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(children: [
          const SizedBox(height: 12),
          Container(width: 48, height: 5,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(3))),
          const SizedBox(height: 20),
          Text(provider.t('Жетістіктер 🏆', 'Достижения 🏆'),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ProgressIndicatorBar(
              progress: provider.profile.progressToNextLevel,
              color: AppColors.primary, height: 12,
              label: provider.t(
                'Деңгей ${provider.profile.level}: ${provider.profile.levelTitle}',
                'Уровень ${provider.profile.level}: ${provider.profile.levelTitle}',
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: GameProvider.achievementDefs.entries.map((entry) {
              final isUnlocked = provider.profile.achievements.contains(entry.key);
              final ach = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? AppColors.botakoin.withValues(alpha: 0.1)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isUnlocked
                        ? AppColors.botakoin.withValues(alpha: 0.4)
                        : Colors.transparent,
                  ),
                ),
                child: Row(children: [
                  Text(isUnlocked ? ach['icon']! : '🔒', style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 16),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(provider.isRussian ? ach['nameRu']! : ach['nameKz']!,
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15,
                          color: isUnlocked ? AppColors.textPrimary : Colors.grey.shade600)),
                      const SizedBox(height: 4),
                      Text(provider.isRussian ? ach['descRu']! : ach['descKz']!,
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                          color: isUnlocked ? AppColors.textSecondary : Colors.grey.shade500)),
                    ],
                  )),
                  if (isUnlocked) const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 28),
                ]),
              );
            }).toList(),
          )),
        ]),
      ),
    );
  }
}
