import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_colors.dart';
import '../services/supabase_service.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});
  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final data = await SupabaseService.getShopItems();
    if (!mounted) return;
    setState(() {
      _items = data.map((s) => <String, dynamic>{
        'nameKz': s['name_kz'],
        'nameRu': s['name_ru'],
        'image': 'assets/${s['image_path']}',
        'price': s['price'],
        'desc': s['description'] ?? '',
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<GameProvider>();
    if (_items.isEmpty) {
      return Scaffold(body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFFF8F0), Color(0xFFFFE4B5)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: const Center(child: CircularProgressIndicator(color: Color(0xFFFF8C00))),
      ));
    }
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(
          colors: [Color(0xFFFFF8F0), Color(0xFFFFE4B5)],
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
        )),
        child: SafeArea(child: Column(children: [
          _header(p, context),
          _balance(p),
          _conversionInfo(p),
          Expanded(child: _grid(p, context)),
        ])),
      ),
    );
  }

  Widget _header(GameProvider p, BuildContext context) => Padding(
    padding: const EdgeInsets.all(12),
    child: Row(children: [
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)]),
          child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary)),
      ),
      const SizedBox(width: 12),
      Expanded(child: Text(p.t('🏪 Бота Дүкені', '🏪 Магазин Боты'),
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary))),
    ]),
  );

  Widget _balance(GameProvider p) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFFA500)]),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [BoxShadow(color: AppColors.botakoin.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 4))],
    ),
    child: Row(children: [
      const Text('🪙', style: TextStyle(fontSize: 40)),
      const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(p.t('Сенің ботакоиндерің', 'Твои ботакоины'),
          style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13, fontWeight: FontWeight.w500)),
        Text('${p.profile.botakoins}',
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white)),
      ]),
      const Spacer(),
      Image.asset('assets/cumbot/glad.png', width: 48, height: 48),
    ]),
  );

  Widget _conversionInfo(GameProvider p) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
    ),
    child: Row(children: [
      const Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 20),
      const SizedBox(width: 8),
      Expanded(child: Text(
        p.t('100 ботакоин = 500₸ жеңілдік', '100 ботакоинов = 500₸ скидка'),
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      )),
    ]),
  );

  Widget _grid(GameProvider p, BuildContext context) => GridView.builder(
    padding: const EdgeInsets.all(16),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.75,
    ),
    itemCount: _items.length,
    itemBuilder: (_, i) => _shopCard(_items[i], p, context),
  );

  Widget _shopCard(Map<String, dynamic> item, GameProvider p, BuildContext context) {
    final canBuy = p.profile.botakoins >= (item['price'] as int);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(item['image'] as String, width: 56, height: 56, fit: BoxFit.cover),
        ),
        const SizedBox(height: 8),
        Text(p.isRussian ? item['nameRu'] as String : item['nameKz'] as String,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          textAlign: TextAlign.center),
        Text(item['desc'] as String,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: canBuy ? () => _buy(item, p, context) : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: canBuy ? AppColors.primaryGradient : null,
              color: canBuy ? null : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Text('🪙', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
              Text('${item['price']}',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800,
                  color: canBuy ? Colors.white : Colors.grey)),
            ]),
          ),
        ),
      ]),
    );
  }

  void _buy(Map<String, dynamic> item, GameProvider p, BuildContext context) {
    showDialog(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(p.isRussian ? item['nameRu'] as String : item['nameKz'] as String),
      content: Text(p.t(
        '${item['price']} ботакоин жұмсағыңыз келе ме?',
        'Потратить ${item['price']} ботакоинов?')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context),
          child: Text(p.t('Жоқ', 'Нет'))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          onPressed: () {
            p.spendBotakoins(item['price'] as int);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(p.t('Сатып алынды! 🎉', 'Куплено! 🎉')),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ));
          },
          child: Text(p.t('Иә!', 'Да!'), style: const TextStyle(color: Colors.white)),
        ),
      ],
    ));
  }
}
