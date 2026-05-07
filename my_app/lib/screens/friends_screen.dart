import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/avatar_widget.dart';

class _LeaderboardEntry {
  final String name;
  final int avatarIndex;
  final int botakoins;
  final bool isUser;

  const _LeaderboardEntry({
    required this.name,
    required this.avatarIndex,
    required this.botakoins,
    this.isUser = false,
  });
}

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});
  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> with TickerProviderStateMixin {
  late TabController _tabCtrl;
  bool _linkCopied = false;

  static const _fakeProfiles = <_LeaderboardEntry>[
    _LeaderboardEntry(name: 'Арман', avatarIndex: 0, botakoins: 1850),
    _LeaderboardEntry(name: 'Айсулу', avatarIndex: 6, botakoins: 1620),
    _LeaderboardEntry(name: 'Данияр', avatarIndex: 3, botakoins: 1480),
    _LeaderboardEntry(name: 'Мадина', avatarIndex: 1, botakoins: 1350),
    _LeaderboardEntry(name: 'Ернар', avatarIndex: 7, botakoins: 1200),
    _LeaderboardEntry(name: 'Аяулым', avatarIndex: 5, botakoins: 1050),
    _LeaderboardEntry(name: 'Тимур', avatarIndex: 10, botakoins: 920),
    _LeaderboardEntry(name: 'Дана', avatarIndex: 2, botakoins: 850),
    _LeaderboardEntry(name: 'Алихан', avatarIndex: 8, botakoins: 780),
    _LeaderboardEntry(name: 'Камила', avatarIndex: 4, botakoins: 650),
    _LeaderboardEntry(name: 'Бекзат', avatarIndex: 9, botakoins: 520),
    _LeaderboardEntry(name: 'Жанна', avatarIndex: 11, botakoins: 430),
    _LeaderboardEntry(name: 'Нұрсұлтан', avatarIndex: 0, botakoins: 350),
    _LeaderboardEntry(name: 'Ақбота', avatarIndex: 6, botakoins: 280),
    _LeaderboardEntry(name: 'Санжар', avatarIndex: 3, botakoins: 180),
    _LeaderboardEntry(name: 'Меруерт', avatarIndex: 1, botakoins: 120),
    _LeaderboardEntry(name: 'Қайрат', avatarIndex: 7, botakoins: 80),
    _LeaderboardEntry(name: 'Гүлім', avatarIndex: 5, botakoins: 50),
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  List<_LeaderboardEntry> _buildLeaderboard(GameProvider p) {
    final userEntry = _LeaderboardEntry(
      name: p.profile.name.isNotEmpty ? p.profile.name : 'Сен',
      avatarIndex: p.profile.avatarIndex,
      botakoins: p.profile.botakoins,
      isUser: true,
    );

    final allEntries = [..._fakeProfiles, userEntry];
    allEntries.sort((a, b) => b.botakoins.compareTo(a.botakoins));
    return allEntries;
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<GameProvider>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F7FA), Color(0xFFEDF0F7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(p),
              const SizedBox(height: 8),
              _buildTabBar(p),
              Expanded(
                child: TabBarView(
                  controller: _tabCtrl,
                  children: [
                    _buildReferralTab(p),
                    _buildLeaderboardTab(p),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(GameProvider p) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
    child: Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8)],
            ),
            child: const Icon(Icons.arrow_back_rounded, size: 22, color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(width: 14),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.people_rounded, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            p.t('Достар', 'Друзья'),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
          ),
        ),
      ],
    ),
  );

  Widget _buildTabBar(GameProvider p) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
    ),
    child: TabBar(
      controller: _tabCtrl,
      indicator: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
        borderRadius: BorderRadius.circular(14),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: Colors.white,
      unselectedLabelColor: AppColors.textSecondary,
      labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      dividerColor: Colors.transparent,
      padding: const EdgeInsets.all(4),
      tabs: [
        Tab(text: p.t('Шақыру', 'Пригласить')),
        Tab(text: p.t('Лидерборд', 'Лидерборд')),
      ],
    ),
  );

  Widget _buildReferralTab(GameProvider p) {
    final referralLink = 'https://mybota.vercel.app?ref=${p.profile.referralCode}';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Referral banner
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: const Color(0xFF667EEA).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 16),
                Text(
                  p.t('Досыңды шақыр!', 'Пригласи друга!'),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      p.t('Әр дос үшін', 'За каждого друга'),
                      style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.9), fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.asset('assets/coin/coin.jpeg', width: 16, height: 16, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 4),
                          const Text('+15', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Referral link card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.link_rounded, color: Color(0xFF667EEA), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      p.t('Сілтеме', 'Ссылка'),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF667EEA).withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          referralLink,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF667EEA), fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: referralLink));
                          setState(() => _linkCopied = true);
                          Future.delayed(const Duration(seconds: 2), () {
                            if (mounted) setState(() => _linkCopied = false);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_linkCopied ? Icons.check_rounded : Icons.copy_rounded, color: Colors.white, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                _linkCopied ? p.t('Көшірілді', 'Скопировано') : p.t('Көшіру', 'Копировать'),
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Stats cards
          Row(
            children: [
              Expanded(
                child: _statCard(
                  icon: Icons.people_alt_rounded,
                  color: const Color(0xFF667EEA),
                  value: '${p.profile.friendsInvited}',
                  label: p.t('Шақырылған достар', 'Приглашено друзей'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _statCard(
                  icon: Icons.monetization_on_rounded,
                  color: AppColors.botakoin,
                  value: '${p.profile.friendsInvited * 15}',
                  label: p.t('Жиналған', 'Заработано'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Simulate invite button (for demo)
          GestureDetector(
            onTap: () {
              p.inviteFriend();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.asset('assets/coin/coin.jpeg', width: 20, height: 20, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 8),
                    Text(p.t('+15 ботакоин алдың!', '+15 ботакоинов получено!')),
                  ],
                ),
                backgroundColor: const Color(0xFF58CC02),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ));
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF58CC02), Color(0xFF4CAF50)]),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [BoxShadow(color: const Color(0xFF58CC02).withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.share_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    p.t('Досты шақыру', 'Пригласить друга'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required Color color,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTab(GameProvider p) {
    final leaderboard = _buildLeaderboard(p);

    return Column(
      children: [
        const SizedBox(height: 16),
        // Top 3 podium
        if (leaderboard.length >= 3) _buildPodium(leaderboard, p),
        const SizedBox(height: 8),
        // Rest of list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            itemCount: leaderboard.length - 3,
            itemBuilder: (_, i) => _buildLeaderboardTile(leaderboard[i + 3], i + 4, p),
          ),
        ),
      ],
    );
  }

  Widget _buildPodium(List<_LeaderboardEntry> entries, GameProvider p) {
    final second = entries[1];
    final first = entries[0];
    final third = entries[2];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd place
          Expanded(child: _podiumItem(second, 2, 90, const Color(0xFFAEB6BF), p)),
          const SizedBox(width: 8),
          // 1st place
          Expanded(child: _podiumItem(first, 1, 110, const Color(0xFFFFD700), p)),
          const SizedBox(width: 8),
          // 3rd place
          Expanded(child: _podiumItem(third, 3, 75, const Color(0xFFCD7F32), p)),
        ],
      ),
    );
  }

  Widget _podiumItem(_LeaderboardEntry entry, int rank, double height, Color medalColor, GameProvider p) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar
        Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            CartoonAvatar(
              avatarIndex: entry.avatarIndex,
              size: rank == 1 ? 64 : 52,
              showBorder: true,
              borderColor: medalColor,
            ),
            Positioned(
              bottom: -8,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: medalColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [BoxShadow(color: medalColor.withValues(alpha: 0.4), blurRadius: 6)],
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          entry.name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: entry.isUser ? FontWeight.w900 : FontWeight.w700,
            color: entry.isUser ? AppColors.primary : AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Image.asset('assets/coin/coin.jpeg', width: 12, height: 12, fit: BoxFit.cover),
            ),
            const SizedBox(width: 3),
            Text(
              '${entry.botakoins}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Podium base
        Container(
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                medalColor.withValues(alpha: 0.2),
                medalColor.withValues(alpha: 0.08),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            border: Border.all(color: medalColor.withValues(alpha: 0.3)),
          ),
          child: Center(
            child: Icon(
              rank == 1 ? Icons.emoji_events_rounded : Icons.star_rounded,
              color: medalColor.withValues(alpha: 0.5),
              size: 28,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardTile(_LeaderboardEntry entry, int rank, GameProvider p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: entry.isUser ? AppColors.primary.withValues(alpha: 0.08) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: entry.isUser ? Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5) : null,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 30,
            child: Text(
              '#$rank',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: entry.isUser ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          CartoonAvatar(avatarIndex: entry.avatarIndex, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      entry.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: entry.isUser ? FontWeight.w900 : FontWeight.w700,
                        color: entry.isUser ? AppColors.primary : AppColors.textPrimary,
                      ),
                    ),
                    if (entry.isUser) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          p.t('Сен', 'Ты'),
                          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.primary),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset('assets/coin/coin.jpeg', width: 16, height: 16, fit: BoxFit.cover),
              ),
              const SizedBox(width: 4),
              Text(
                '${entry.botakoins}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
