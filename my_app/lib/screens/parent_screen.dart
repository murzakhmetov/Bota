import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/game_widgets.dart';

class ParentScreen extends StatefulWidget {
  const ParentScreen({super.key});
  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  bool _authenticated = false;
  final _pinController = TextEditingController();
  String _pinError = '';

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _checkPin(GameProvider p) {
    if (p.verifyParentPin(_pinController.text)) {
      setState(() { _authenticated = true; _pinError = ''; });
      p.enterParentMode();
    } else {
      setState(() => _pinError = p.t('Қате PIN', 'Неверный PIN'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<GameProvider>();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(
          colors: [Color(0xFFF5F7FA), Color(0xFFC3CFE2)],
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
        )),
        child: SafeArea(child: _authenticated ? _dashboard(p) : _pinScreen(p)),
      ),
    );
  }

  Widget _pinScreen(GameProvider p) => SingleChildScrollView(child: Column(children: [
    _header(p),
    const SizedBox(height: 40),
    const Icon(Icons.lock_rounded, size: 64, color: AppColors.textSecondary),
    const SizedBox(height: 16),
    Text(p.t('Ата-ана бөлімі', 'Раздел для родителей'),
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
    const SizedBox(height: 8),
    Text(p.t('PIN-кодты енгізіңіз', 'Введите PIN-код'),
      style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
    const SizedBox(height: 4),
    Text(p.t('(Әдепкі: 1234)', '(По умолчанию: 1234)'),
      style: TextStyle(fontSize: 12, color: AppColors.textSecondary.withValues(alpha: 0.6))),
    const SizedBox(height: 24),
    Container(
      width: 200,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12)]),
      child: TextField(
        controller: _pinController,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        obscureText: true,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: 12),
        decoration: InputDecoration(
          hintText: '••••',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.all(16),
        ),
        maxLength: 4,
        onSubmitted: (_) => _checkPin(p),
      ),
    ),
    if (_pinError.isNotEmpty) Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(_pinError, style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
    ),
    const SizedBox(height: 24),
    GameButton(text: p.t('Кіру', 'Войти'), onPressed: () => _checkPin(p),
      color: AppColors.accentBlue, width: 200, height: 48),
    const SizedBox(height: 40),
  ]));

  Widget _dashboard(GameProvider p) => Column(children: [
    _header(p),
    Expanded(child: ListView(padding: const EdgeInsets.all(16), children: [
      _profileCard(p),
      const SizedBox(height: 12),
      _statsCard(p),
      const SizedBox(height: 12),
      _screenTimeCard(p),
      const SizedBox(height: 12),
      _achievementsCard(p),
      const SizedBox(height: 20),
      Center(child: GameButton(
        text: p.t('Прогрессті тазалау', 'Сбросить прогресс'),
        onPressed: () => _confirmReset(p),
        color: AppColors.error, width: 220, height: 44, fontSize: 14)),
    ])),
  ]);

  Widget _header(GameProvider p) => Padding(
    padding: const EdgeInsets.all(12),
    child: Row(children: [
      GestureDetector(
        onTap: () { p.exitParentMode(); Navigator.pop(context); },
        child: Container(padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)]),
          child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary)),
      ),
      const SizedBox(width: 12),
      Expanded(child: Text(p.t('👨‍👩‍👧 Ата-ана', '👨‍👩‍👧 Родитель'),
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary))),
      GestureDetector(
        onTap: () => p.toggleLanguage(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)]),
          child: Text(p.isRussian ? 'Қаз' : 'Рус', style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
        ),
      ),
    ]),
  );

  Widget _profileCard(GameProvider p) => _card(
    child: Row(children: [
      Container(width: 56, height: 56,
        decoration: BoxDecoration(shape: BoxShape.circle,
          gradient: AppColors.primaryGradient),
        child: ClipOval(child: Image.asset('assets/cumbot/glad.png', width: 28, height: 28, fit: BoxFit.cover))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(p.profile.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        Text('${p.t("Жас", "Возраст")}: ${p.profile.age}',
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        Text('${p.t("Деңгей", "Уровень")}: ${p.profile.level} - ${p.profile.levelTitle}',
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
      ])),
      BotakoinCounter(count: p.profile.botakoins, fontSize: 14),
    ]),
  );

  Widget _statsCard(GameProvider p) => _card(child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(p.t('📊 Статистика', '📊 Статистика'),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
      const SizedBox(height: 12),
      _statRow(p.t('Ойындар ойналды', 'Игр сыграно'), '${p.profile.totalGamesPlayed}', '🎮'),
      _statRow(p.t('Дұрыс жауаптар', 'Правильных ответов'), '${p.profile.totalCorrectAnswers}', '✅'),
      _statRow(p.t('Жетістіктер', 'Достижений'), '${p.profile.achievements.length}/${GameProvider.achievementDefs.length}', '🏆'),
      _statRow(p.t('Ашылған локациялар', 'Открыто локаций'), '${p.profile.unlockedLocations.length}/5', '📍'),
      const SizedBox(height: 8),
      ProgressIndicatorBar(
        progress: p.profile.progressToNextLevel,
        label: p.t('Келесі деңгейге дейін', 'До следующего уровня'),
        color: AppColors.primary),
    ],
  ));

  Widget _screenTimeCard(GameProvider p) => _card(child: Column(
    crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(p.t('⏱️ Экран уақыты', '⏱️ Экранное время'),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
      const SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(p.t('Бүгін қолданылды', 'Использовано сегодня'),
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        Text('${p.sessionMinutes} ${p.t("мин", "мин")}',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      ]),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(p.t('Күндік лимит', 'Дневной лимит'),
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        Text('${p.profile.screenTimeLimit} ${p.t("мин", "мин")}',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      ]),
      const SizedBox(height: 12),
      Text(p.t('Лимитті өзгерту:', 'Изменить лимит:'),
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      const SizedBox(height: 8),
      Wrap(spacing: 8, children: [15, 30, 45, 60].map((m) => GestureDetector(
        onTap: () => p.setScreenTimeLimit(m),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: p.profile.screenTimeLimit == m ? AppColors.primary : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12)),
          child: Text('$m ${p.t("мин", "мин")}',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13,
              color: p.profile.screenTimeLimit == m ? Colors.white : AppColors.textPrimary)),
        ),
      )).toList()),
    ],
  ));

  Widget _achievementsCard(GameProvider p) => _card(child: Column(
    crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(p.t('🏆 Жетістіктер', '🏆 Достижения'),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8, children: GameProvider.achievementDefs.entries.map((e) {
        final unlocked = p.profile.achievements.contains(e.key);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: unlocked ? AppColors.accentYellow.withValues(alpha: 0.2) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(unlocked ? e.value['icon']! : '🔒', style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 4),
            Text(p.isRussian ? e.value['nameRu']! : e.value['nameKz']!,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                color: unlocked ? AppColors.textPrimary : Colors.grey)),
          ]),
        );
      }).toList()),
    ],
  ));

  Widget _statRow(String label, String value, String emoji) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 18)),
      const SizedBox(width: 8),
      Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
      Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
    ]),
  );

  Widget _card({required Widget child}) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4))]),
    child: child,
  );

  void _confirmReset(GameProvider p) {
    showDialog(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(p.t('⚠️ Прогрессті тазалау', '⚠️ Сбросить прогресс')),
      content: Text(p.t(
        'Барлық деректер жойылады. Сенімдісіз бе?',
        'Все данные будут удалены. Вы уверены?')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context),
          child: Text(p.t('Жоқ', 'Нет'))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          onPressed: () {
            p.resetProgress();
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: Text(p.t('Иә', 'Да'), style: const TextStyle(color: Colors.white))),
      ],
    ));
  }
}
