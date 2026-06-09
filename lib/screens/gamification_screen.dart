import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/gamification_model.dart';
import '../providers/gamification_provider.dart';

class GamificationScreen extends StatelessWidget {
  const GamificationScreen({Key? key}) : super(key: key);

  static const _accent = Color(0xFF4F46E5);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GamificationProvider>();
    final data = provider.data;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Rewards & progress',
          style: TextStyle(
              color: Color(0xFF111827),
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF111827)),
        centerTitle: true,
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildRankCard(context, data),
                  const SizedBox(height: 28),
                  _buildSectionTitle('Achievements',
                      'Earn badges by hitting goals and building habits.'),
                  const SizedBox(height: 14),
                  _buildAchievementGrid(context, data),
                  const SizedBox(height: 28),
                  _buildSectionTitle('Coupons & vouchers',
                      'Rewards for streaks, milestones, and tasks.'),
                  const SizedBox(height: 14),
                  ..._buildVouchers(context, data),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
                letterSpacing: -0.3)),
        const SizedBox(height: 6),
        Text(subtitle,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
                height: 1.35)),
      ],
    );
  }

  Widget _buildRankCard(BuildContext context, GamificationModel? data) {
    final rankName = data?.rankName ?? 'Bronze Beginner';
    final nextRank = data?.nextRankName ?? 'Silver Saver';
    final progress = data?.rankProgress ?? 0.0;
    final xp = data?.xp ?? 0;
    final streak = data?.streakDays ?? 0;

    return GestureDetector(
      onTap: () => _showRanksBottomSheet(context, rankName),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4F46E5).withOpacity(0.35),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.military_tech_rounded,
                      color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Your rank',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(rankName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('$xp XP',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16)),
                    Text('$streak day streak',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Progress to $nextRank',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.white.withOpacity(0.25),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Higher ranks reflect consistent usage, participation, and hitting your targets.',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1.4),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Tap to view all ranks',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.white.withOpacity(0.9), size: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showRanksBottomSheet(BuildContext context, String currentRank) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.sizeOf(ctx).height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 20),
              const Text('Rank Journey',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                      letterSpacing: -0.5)),
              const SizedBox(height: 8),
              Text('Unlock perks and rewards as you climb!',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600)),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  children: [
                    _buildRankListItem(
                      title: 'Bronze Beginner',
                      subtitle: 'Start your savings journey.',
                      icon: Icons.star_border_rounded,
                      color: const Color(0xFFCD7F32),
                      isCurrent: currentRank == 'Bronze Beginner',
                      isLocked: false,
                    ),
                    const SizedBox(height: 16),
                    _buildRankListItem(
                      title: 'Silver Saver',
                      subtitle: 'Consistent saver. Access basic vouchers.',
                      icon: Icons.star_half_rounded,
                      color: const Color(0xFF94A3B8),
                      isCurrent: currentRank == 'Silver Saver',
                      isLocked: false,
                    ),
                    const SizedBox(height: 16),
                    _buildRankListItem(
                      title: 'Gold Guardian',
                      subtitle: 'Hit 3 monthly goals. Unlock premium trials.',
                      icon: Icons.star_rounded,
                      color: const Color(0xFFF59E0B),
                      isCurrent: currentRank == 'Gold Guardian',
                      isLocked: currentRank == 'Bronze Beginner' ||
                          currentRank == 'Silver Saver',
                    ),
                    const SizedBox(height: 16),
                    _buildRankListItem(
                      title: 'Platinum Protector',
                      subtitle: '6-month streak. Higher cashback tiers.',
                      icon: Icons.diamond_outlined,
                      color: const Color(0xFF0EA5E9),
                      isCurrent: currentRank == 'Platinum Protector',
                      isLocked: currentRank != 'Platinum Protector' &&
                          currentRank != 'Diamond Master' &&
                          currentRank != 'Pocket Hero',
                    ),
                    const SizedBox(height: 16),
                    _buildRankListItem(
                      title: 'Diamond Master',
                      subtitle: '1-year streak. Exclusive partner discounts.',
                      icon: Icons.diamond_rounded,
                      color: const Color(0xFF8B5CF6),
                      isCurrent: currentRank == 'Diamond Master',
                      isLocked: currentRank != 'Diamond Master' &&
                          currentRank != 'Pocket Hero',
                    ),
                    const SizedBox(height: 16),
                    _buildRankListItem(
                      title: 'Pocket Hero',
                      subtitle: 'Financial guru. Supreme rewards!',
                      icon: Icons.military_tech_rounded,
                      color: const Color(0xFFEF4444),
                      isCurrent: currentRank == 'Pocket Hero',
                      isLocked: currentRank != 'Pocket Hero',
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRankListItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isCurrent,
    required bool isLocked,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrent ? color.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCurrent
              ? color.withOpacity(0.3)
              : const Color(0xFFF1F5F9),
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isLocked
                  ? const Color(0xFFF1F5F9)
                  : color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              isLocked ? Icons.lock_outline_rounded : icon,
              color: isLocked ? const Color(0xFF94A3B8) : color,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isLocked
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF111827))),
                    if (isCurrent) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8)),
                        child: const Text('Current',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isLocked
                            ? const Color(0xFFCBD5E1)
                            : const Color(0xFF6B7280))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementGrid(
      BuildContext context, GamificationModel? data) {
    final unlocked = data?.unlockedAchievementIds ?? [];

    final items = [
      _Achievement(id: 'first_budget', title: 'First budget',
          subtitle: 'Set a monthly limit', icon: Icons.flag_rounded),
      _Achievement(id: 'streak_3', title: 'Streak starter',
          subtitle: 'Log 3 days in a row', icon: Icons.local_fire_department_rounded),
      _Achievement(id: 'goal_done', title: 'Goal crusher',
          subtitle: 'Complete a savings goal', icon: Icons.emoji_events_rounded),
      _Achievement(id: 'balanced_month', title: 'Balanced month',
          subtitle: 'Stay under budget 4 weeks', icon: Icons.balance_rounded),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final a in items)
          _buildAchievementTile(context, a, unlocked.contains(a.id)),
      ],
    );
  }

  Widget _buildAchievementTile(
      BuildContext context, _Achievement a, bool isUnlocked) {
    final Color fg =
        isUnlocked ? _accent : const Color(0xFF94A3B8);
    final Color bg =
        isUnlocked ? const Color(0xFFEEF2FF) : const Color(0xFFF1F5F9);

    return Container(
      width: (MediaQuery.sizeOf(context).width - 24 * 2 - 12) / 2,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration:
                BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
            child: Icon(a.icon, color: fg, size: 24),
          ),
          const SizedBox(height: 12),
          Text(a.title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isUnlocked
                      ? const Color(0xFF111827)
                      : const Color(0xFF94A3B8))),
          const SizedBox(height: 4),
          Text(a.subtitle,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isUnlocked
                      ? const Color(0xFF6B7280)
                      : const Color(0xFFCBD5E1))),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                isUnlocked
                    ? Icons.check_circle_rounded
                    : Icons.lock_outline_rounded,
                size: 16,
                color: isUnlocked
                    ? const Color(0xFF10B981)
                    : const Color(0xFFCBD5E1),
              ),
              const SizedBox(width: 4),
              Text(
                isUnlocked ? 'Unlocked' : 'Locked',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isUnlocked
                        ? const Color(0xFF10B981)
                        : const Color(0xFF94A3B8)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildVouchers(
      BuildContext context, GamificationModel? data) {
    final xp = data?.xp ?? 0;

    return [
      _buildVoucherCard(context,
          title: 'RM10 grocery voucher',
          subtitle: '7-day logging streak',
          code: 'PH-STREAK-7',
          expires: 'Expires in 14 days',
          icon: Icons.local_offer_rounded,
          iconColor: const Color(0xFF10B981),
          iconBg: const Color(0xFFECFDF5),
          locked: false),
      const SizedBox(height: 12),
      _buildVoucherCard(context,
          title: '5% cashback boost',
          subtitle: 'Reached monthly savings goal',
          code: 'PH-GOAL-MAY',
          expires: 'Redeem by 31 May',
          icon: Icons.percent_rounded,
          iconColor: const Color(0xFF7C3AED),
          iconBg: const Color(0xFFF5F3FF),
          locked: false),
      const SizedBox(height: 12),
      _buildVoucherCard(context,
          title: 'Buy 1 Free 1 ZUS Coffee',
          subtitle: 'Weekend Special',
          code: 'PH-ZUS-B1F1',
          expires: 'Valid this weekend',
          icon: Icons.coffee_rounded,
          iconColor: const Color(0xFF024C8C),
          iconBg: const Color(0xFFE0F0FF),
          locked: false),
      const SizedBox(height: 12),
      _buildVoucherCard(context,
          title: '20% Off McD Delivery',
          subtitle: 'Min. spend RM30',
          code: 'PH-MCD-20',
          expires: 'Expires in 7 days',
          icon: Icons.fastfood_rounded,
          iconColor: const Color(0xFFDA291C),
          iconBg: const Color(0xFFFFEBEB),
          locked: false),
      const SizedBox(height: 12),
      _buildVoucherCard(context,
          title: 'RM5 GrabRide Voucher',
          subtitle: 'Redeemed with 500 points',
          code: 'PH-GRAB-RM5',
          expires: 'Expires in 30 days',
          icon: Icons.local_taxi_rounded,
          iconColor: const Color(0xFF00B14F),
          iconBg: const Color(0xFFE5F8ED),
          locked: false),
      const SizedBox(height: 12),
      _buildVoucherCard(context,
          title: 'Free premium trial',
          subtitle: 'Unlocked Gold rank (1,500 XP)',
          code: 'PH-RANK-GOLD',
          expires: 'One-time use',
          icon: Icons.star_rounded,
          iconColor: const Color(0xFFF59E0B),
          iconBg: const Color(0xFFFFFBEB),
          locked: xp < 1500),
    ];
  }

  Widget _buildVoucherCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String code,
    required String expires,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    bool locked = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: locked
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF111827))),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280))),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          locked ? '••••••••••' : code,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: locked
                                ? const Color(0xFFCBD5E1)
                                : const Color(0xFF0F172A),
                            fontFeatures: const [
                              FontFeature.tabularFigures()
                            ],
                          ),
                        ),
                      ),
                      if (!locked)
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: code));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Code copied to clipboard'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: const Text('Copy',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _accent)),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(expires,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Achievement {
  const _Achievement({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
}
