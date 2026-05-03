import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/game_widgets.dart';
import '../services/supabase_service.dart';

class GameQuizScreen extends StatefulWidget {
  final String locationName;
  const GameQuizScreen({super.key, required this.locationName});
  @override
  State<GameQuizScreen> createState() => _GameQuizScreenState();
}

class _GameQuizScreenState extends State<GameQuizScreen> {
  List<Map<String, dynamic>> _allQuestions = [];
  List<Map<String, dynamic>> _questions = [];
  int _current = 0, _correct = 0;
  final int _total = 8;
  int? _selectedAnswer;
  bool _answered = false;
  bool _done = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAndInit();
  }

  Future<void> _loadAndInit() async {
    final data = await SupabaseService.getQuizQuestions();
    if (!mounted) return;
    setState(() {
      _allQuestions = data.map((q) {
        final answers = q['answers'];
        return <String, dynamic>{
          'qKz': q['question_kz'],
          'qRu': q['question_ru'],
          'answers': answers is List ? List<String>.from(answers) : <String>[],
          'correct': q['correct_index'] ?? 0,
          'fact': q['fact'] ?? '',
        };
      }).toList();
      _loading = false;
    });
    _initGame();
  }

  void _initGame() {
    if (_allQuestions.isEmpty) return;
    final rng = Random();
    _questions = List.from(_allQuestions)..shuffle(rng);
    _questions = _questions.take(_total).toList();
    for (final q in _questions) {
      final answers = q['answers'];
      if (answers == null || answers is! List || answers.isEmpty) continue;
      final answersList = List<String>.from(answers);
      final correctIdx = q['correct'] as int;
      if (correctIdx < 0 || correctIdx >= answersList.length) continue;
      final correctAnswer = answersList[correctIdx];
      answersList.shuffle(rng);
      q['answers'] = answersList;
      q['correct'] = answersList.indexOf(correctAnswer);
    }
    _current = _correct = 0;
    _selectedAnswer = null;
    _answered = _done = false;
    setState(() {});
  }

  void _answer(int idx) {
    if (_answered || _questions.isEmpty || _current >= _questions.length) return;
    final q = _questions[_current];
    final correctIdx = q['correct'] as int? ?? -1;
    final isCorrect = idx == correctIdx;
    setState(() {
      _selectedAnswer = idx;
      _answered = true;
      if (isCorrect) _correct++;
    });
    final maxQ = _questions.length;
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      setState(() {
        _selectedAnswer = null;
        _answered = false;
        if (_current < maxQ - 1) {
          _current++;
        } else {
          _done = true;
          _onComplete();
        }
      });
    });
  }

  void _onComplete() {
    final p = context.read<GameProvider>();
    int stars = _correct >= 7 ? 3 : _correct >= 5 ? 2 : 1;
    p.completeGame('quiz', stars * 10, _correct);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<GameProvider>();
    if (_loading || _questions.isEmpty) {
      return Scaffold(body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: const Center(child: CircularProgressIndicator(color: Colors.white)),
      ));
    }
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(child: _done ? _complete(p) : Column(children: [
          _header(p), _progress(),
          Expanded(child: SingleChildScrollView(child: Column(children: [
            const SizedBox(height: 8),
            _questionCard(p),
            const SizedBox(height: 16),
            _options(p),
            if (_answered) _factCard(p),
            const SizedBox(height: 20),
          ]))),
        ])),
      ),
    );
  }

  Widget _header(GameProvider p) => Padding(
    padding: const EdgeInsets.all(12),
    child: Row(children: [
      GestureDetector(onTap: () => Navigator.pop(context),
        child: Container(padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.arrow_back_rounded, color: Colors.white))),
      const SizedBox(width: 12),
      Expanded(child: Text(p.t('❓ Қазақстан туралы', '❓ Викторина о Казахстане'),
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white))),
      BotakoinCounter(count: p.profile.botakoins, fontSize: 14),
    ]),
  );

  Widget _progress() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('${_current + 1}/$_total', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontWeight: FontWeight.w600)),
        Text('✅ $_correct', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ]),
      const SizedBox(height: 6),
      ClipRRect(borderRadius: BorderRadius.circular(6),
        child: LinearProgressIndicator(value: (_current + 1) / _total,
          backgroundColor: Colors.white.withValues(alpha: 0.2),
          valueColor: const AlwaysStoppedAnimation(Colors.white), minHeight: 8)),
    ]),
  );

  Widget _questionCard(GameProvider p) {
    if (_current >= _questions.length) return const SizedBox.shrink();
    final q = _questions[_current];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 8))]),
      child: Column(children: [
        const Text('🤔', style: TextStyle(fontSize: 40)),
        const SizedBox(height: 12),
        Text(p.isRussian ? q['qRu'] as String : q['qKz'] as String,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.3)),
      ]),
    );
  }

  Widget _options(GameProvider p) {
    if (_current >= _questions.length) return const SizedBox.shrink();
    final q = _questions[_current];
    final answers = q['answers'] is List ? List<String>.from(q['answers'] as List) : <String>[];
    final correctIdx = q['correct'] as int? ?? -1;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(children: List.generate(answers.length, (i) {
        Color bg = Colors.white;
        Color textColor = AppColors.textPrimary;
        if (_answered) {
          if (i == correctIdx) {
            bg = AppColors.success;
            textColor = Colors.white;
          } else if (i == _selectedAnswer) {
            bg = AppColors.error;
            textColor = Colors.white;
          }
        }
        return GestureDetector(
          onTap: () => _answer(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))]),
            child: Row(children: [
              Container(width: 32, height: 32,
                decoration: BoxDecoration(shape: BoxShape.circle,
                  color: _answered && i == correctIdx ? Colors.white.withValues(alpha: 0.3) : AppColors.accentBlue.withValues(alpha: 0.1)),
                child: Center(child: Text(String.fromCharCode(65 + i),
                  style: TextStyle(fontWeight: FontWeight.w800, color: textColor)))),
              const SizedBox(width: 12),
              Expanded(child: Text(answers[i],
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textColor))),
              if (_answered && i == correctIdx) const Icon(Icons.check_circle, color: Colors.white, size: 22),
              if (_answered && i == _selectedAnswer && i != correctIdx) const Icon(Icons.cancel, color: Colors.white, size: 22),
            ]),
          ),
        );
      })),
    );
  }

  Widget _factCard(GameProvider p) {
    final fact = _questions[_current]['fact'] as String;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.accentYellow.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        const Text('💡', style: TextStyle(fontSize: 22)),
        const SizedBox(width: 8),
        Expanded(child: Text(fact,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
      ]),
    );
  }

  Widget _complete(GameProvider p) {
    int stars = _correct >= 7 ? 3 : _correct >= 5 ? 2 : 1;
    int earned = 5 + (_correct * 3) + (stars == 3 ? 10 : 0);
    return Center(child: Container(
      margin: const EdgeInsets.all(24), padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20)]),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(p.t('Білгір! 🧠', 'Умница! 🧠'), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (j) =>
          Icon(j < stars ? Icons.star_rounded : Icons.star_border_rounded,
            color: j < stars ? AppColors.botakoin : Colors.grey.shade300, size: 36))),
        const SizedBox(height: 8),
        Text('$_correct/$_total ${p.t("дұрыс", "правильно")}',
          style: const TextStyle(fontSize: 16, color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        Text('+$earned 🪙', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.primary)),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: GameButton(text: p.t('Қайта', 'Снова'), onPressed: () => setState(() => _initGame()),
            color: AppColors.secondary, height: 44, fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(child: GameButton(text: p.t('Картаға', 'На карту'), onPressed: () => Navigator.pop(context),
            color: AppColors.primary, height: 44, fontSize: 14)),
        ]),
      ]),
    ));
  }
}
