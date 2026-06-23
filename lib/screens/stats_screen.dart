import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../models/transaction_model.dart';
import '../providers/budget_provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/fade_in_slide.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  String _statsType = 'weekly';

  static const _categoryColors = <String, Color>{
    'Food': Color(0xFF6366F1),
    'Shop': Color(0xFF06B6D4),
    'Travel': Color(0xFF10B981),
    'Health': Color(0xFFF43F5E),
    'Play': Color(0xFFF59E0B),
    'Gifts': Color(0xFFEC4899),
    'Gift': Color(0xFFEC4899),
    'Other': Color(0xFF8B5CF6),
    'Salary': Color(0xFF10B981),
    'Freelance': Color(0xFF06B6D4),
    'Business': Color(0xFF6366F1),
    'Investment': Color(0xFF059669),
  };

  static const _categoryEmojis = <String, String>{
    'Food': '🍕',
    'Shop': '🛍️',
    'Travel': '🚗',
    'Health': '❤️',
    'Play': '🎬',
    'Gifts': '🎁',
    'Gift': '🎁',
    'Other': '💰',
    'Salary': '💼',
    'Freelance': '💻',
    'Business': '🏪',
    'Investment': '📈',
  };

  // ── Data helpers ──────────────────────────────────────────────────────────

  List<FlSpot> _weeklySpots(List<TransactionModel> txs) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final daily = List<double>.filled(7, 0);
    for (final t in txs) {
      if (t.isIncome) continue;
      final diff = DateTime(t.createdAt.year, t.createdAt.month, t.createdAt.day)
          .difference(DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day))
          .inDays;
      if (diff >= 0 && diff < 7) daily[diff] += t.amount;
    }
    return List.generate(7, (i) => FlSpot(i.toDouble(), daily[i]));
  }

  List<FlSpot> _monthlySpots(List<TransactionModel> txs) {
    final now = DateTime.now();
    final monthly = List<double>.filled(6, 0);
    for (final t in txs) {
      if (t.isIncome) continue;
      final monthsAgo = (now.year - t.createdAt.year) * 12 +
          (now.month - t.createdAt.month);
      if (monthsAgo >= 0 && monthsAgo < 6) monthly[5 - monthsAgo] += t.amount;
    }
    return List.generate(6, (i) => FlSpot(i.toDouble(), monthly[i]));
  }

  Map<String, double> _categoryTotals(List<TransactionModel> txs, bool weekly) {
    final now = DateTime.now();
    final map = <String, double>{};
    for (final t in txs) {
      if (t.isIncome) continue;
      if (weekly) {
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final diff = DateTime(t.createdAt.year, t.createdAt.month, t.createdAt.day)
            .difference(DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day))
            .inDays;
        if (diff < 0 || diff >= 7) continue;
      } else {
        if (t.createdAt.year != now.year || t.createdAt.month != now.month) continue;
      }
      map[t.category] = (map[t.category] ?? 0) + t.amount;
    }
    return map;
  }

  double _totalExpense(List<TransactionModel> txs, bool weekly) {
    final now = DateTime.now();
    double total = 0;
    for (final t in txs) {
      if (t.isIncome) continue;
      if (weekly) {
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final diff = DateTime(t.createdAt.year, t.createdAt.month, t.createdAt.day)
            .difference(DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day))
            .inDays;
        if (diff < 0 || diff >= 7) continue;
      } else {
        if (t.createdAt.year != now.year || t.createdAt.month != now.month) continue;
      }
      total += t.amount;
    }
    return total;
  }

  double _totalIncome(List<TransactionModel> txs) {
    final now = DateTime.now();
    return txs
        .where((t) =>
            t.isIncome &&
            t.createdAt.year == now.year &&
            t.createdAt.month == now.month)
        .fold(0.0, (s, t) => s + t.amount);
  }

  int _activeDays(List<TransactionModel> txs, bool weekly) {
    final now = DateTime.now();
    final days = <String>{};
    for (final t in txs) {
      if (t.isIncome) continue;
      if (weekly) {
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final diff = DateTime(t.createdAt.year, t.createdAt.month, t.createdAt.day)
            .difference(DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day))
            .inDays;
        if (diff < 0 || diff >= 7) continue;
      } else {
        if (t.createdAt.year != now.year || t.createdAt.month != now.month) continue;
      }
      days.add('${t.createdAt.year}-${t.createdAt.month}-${t.createdAt.day}');
    }
    return days.isEmpty ? 1 : days.length;
  }

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider>();
    final budgetProvider = context.watch<BudgetProvider>();
    final txs = txProvider.transactions;
    final isWeekly = _statsType == 'weekly';

    final totalExpense = _totalExpense(txs, isWeekly);
    final totalIncome = _totalIncome(txs);
    final savings = totalIncome - _totalExpense(txs, false);
    final avgDaily = totalExpense / _activeDays(txs, isWeekly);
    final cats = _categoryTotals(txs, isWeekly);
    final topCat = cats.isEmpty
        ? null
        : cats.entries.reduce((a, b) => a.value > b.value ? a : b);

    final monthlyLimit = budgetProvider.monthlyLimit;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            FadeInSlide(
              duration: const Duration(milliseconds: 400),
              slideOffset: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Analytics',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        _buildToggleButton('weekly'),
                        _buildToggleButton('monthly'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Summary Cards
            FadeInSlide(
              duration: const Duration(milliseconds: 500),
              slideOffset: 30,
              child: Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Total Spent',
                      amount: 'RM ${totalExpense.toStringAsFixed(0)}',
                      change: isWeekly ? 'This week' : 'This month',
                      isPositive: false,
                      icon: Icons.trending_down,
                      color: const Color(0xFFEF4444),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Avg Daily',
                      amount: 'RM ${avgDaily.toStringAsFixed(0)}',
                      change: isWeekly ? 'Per day' : 'Per day',
                      isPositive: true,
                      icon: Icons.calendar_today,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FadeInSlide(
              duration: const Duration(milliseconds: 600),
              slideOffset: 40,
              child: Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Top Category',
                      amount: topCat?.key ?? '—',
                      change: topCat != null
                          ? 'RM ${topCat.value.toStringAsFixed(0)}'
                          : 'No data',
                      isPositive: false,
                      icon: Icons.restaurant,
                      color: const Color(0xFFF59E0B),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Savings',
                      amount: 'RM ${savings.clamp(0, double.infinity).toStringAsFixed(0)}',
                      change: 'This month',
                      isPositive: savings >= 0,
                      icon: Icons.savings,
                      color: const Color(0xFF6366F1),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Spending Trend Chart
            FadeInSlide(
              duration: const Duration(milliseconds: 700),
              slideOffset: 50,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isWeekly
                              ? 'Weekly Spending Trend'
                              : 'Monthly Spending Trend',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'RM / Day',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6366F1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 220,
                      child: txs.isEmpty
                          ? const Center(
                              child: Text(
                                'No transactions yet',
                                style: TextStyle(color: Color(0xFF94A3B8)),
                              ),
                            )
                          : LineChart(
                              LineChartData(
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  horizontalInterval: 50,
                                  getDrawingHorizontalLine: (_) => const FlLine(
                                    color: Color(0xFFF1F5F9),
                                    strokeWidth: 1,
                                    dashArray: [5, 5],
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 1,
                                      getTitlesWidget: (value, meta) {
                                        const style = TextStyle(
                                          color: Color(0xFF94A3B8),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        );
                                        final labels = isWeekly
                                            ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                                            : _last6MonthLabels();
                                        final idx = value.toInt();
                                        if (idx < 0 || idx >= labels.length) {
                                          return const SizedBox.shrink();
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(labels[idx], style: style),
                                        );
                                      },
                                    ),
                                  ),
                                  leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                borderData: FlBorderData(show: false),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: isWeekly
                                        ? _weeklySpots(txs)
                                        : _monthlySpots(txs),
                                    isCurved: true,
                                    color: const Color(0xFF6366F1),
                                    barWidth: 3,
                                    isStrokeCapRound: true,
                                    dotData: FlDotData(
                                      show: true,
                                      getDotPainter: (spot, percent, barData, index) =>
                                          FlDotCirclePainter(
                                        radius: 4,
                                        color: Colors.white,
                                        strokeWidth: 2,
                                        strokeColor: const Color(0xFF6366F1),
                                      ),
                                    ),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: const Color(0xFF6366F1).withOpacity(0.1),
                                    ),
                                  ),
                                ],
                                lineTouchData: LineTouchData(
                                  touchTooltipData: LineTouchTooltipData(
                                    getTooltipItems: (spots) => spots
                                        .map((s) => LineTooltipItem(
                                              'RM ${s.y.toStringAsFixed(0)}',
                                              const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Category Breakdown
            if (cats.isNotEmpty) ...[
              FadeInSlide(
                duration: const Duration(milliseconds: 800),
                slideOffset: 60,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Spending by Category',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          Center(
                            child: SizedBox(
                              width: 160,
                              height: 160,
                              child: PieChart(
                                PieChartData(
                                  sectionsSpace: 2,
                                  centerSpaceRadius: 46,
                                  sections: _buildPieSections(cats, totalExpense),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Column(
                            children: cats.entries
                                .toList()
                                .sorted()
                                .map((e) {
                              final pct = totalExpense > 0
                                  ? (e.value / totalExpense * 100).toStringAsFixed(0)
                                  : '0';
                              final catTxs = txs
                                  .where((t) => !t.isIncome && t.category == e.key)
                                  .toList();
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: _buildDetailedLegendItem(
                                  color: _categoryColors[e.key] ?? const Color(0xFF8B5CF6),
                                  emoji: _categoryEmojis[e.key] ?? '💰',
                                  name: e.key,
                                  amount: 'RM ${e.value.toStringAsFixed(0)}',
                                  percentage: '$pct%',
                                  onTap: () => _showCategoryDetail(
                                    context,
                                    category: e.key,
                                    total: e.value,
                                    color: _categoryColors[e.key] ?? const Color(0xFF8B5CF6),
                                    emoji: _categoryEmojis[e.key] ?? '💰',
                                    transactions: catTxs,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Budget Progress
            if (monthlyLimit > 0) ...[
              FadeInSlide(
                duration: const Duration(milliseconds: 900),
                slideOffset: 70,
                child: _buildBudgetCard(
                  cats: _categoryTotals(txs, false),
                  monthlyLimit: monthlyLimit,
                  totalExpense: _totalExpense(txs, false),
                ),
              ),
            ],

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieSections(
      Map<String, double> cats, double total) {
    return cats.entries.map((e) {
      final color = _categoryColors[e.key] ?? const Color(0xFF8B5CF6);
      final emoji = _categoryEmojis[e.key] ?? '💰';
      return PieChartSectionData(
        color: color,
        value: e.value,
        title: '',
        radius: 22,
        badgeWidget: _buildCategoryBadge(emoji),
        badgePositionPercentageOffset: 1.3,
      );
    }).toList();
  }

  Widget _buildBudgetCard({
    required Map<String, double> cats,
    required double monthlyLimit,
    required double totalExpense,
  }) {
    final isOnTrack = totalExpense <= monthlyLimit;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Budget Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isOnTrack
                      ? const Color(0xFFDCFCE7)
                      : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isOnTrack ? 'On Track' : 'Over Budget',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isOnTrack
                        ? const Color(0xFF166534)
                        : const Color(0xFFDC2626),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'RM ${totalExpense.toStringAsFixed(0)} of RM ${monthlyLimit.toStringAsFixed(0)} used',
            style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 16),
          _buildBudgetProgressBar(
            'Total',
            totalExpense,
            monthlyLimit,
            const Color(0xFF6366F1),
          ),
          if (cats.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...cats.entries.toList().sorted().map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildBudgetProgressBar(
                    e.key,
                    e.value,
                    monthlyLimit,
                    _categoryColors[e.key] ?? const Color(0xFF8B5CF6),
                  ),
                )),
          ],
        ],
      ),
    );
  }

  List<String> _last6MonthLabels() {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final now = DateTime.now();
    return List.generate(6, (i) {
      final m = DateTime(now.year, now.month - 5 + i);
      return months[m.month - 1];
    });
  }

  Widget _buildToggleButton(String type) {
    final isSelected = _statsType == type;
    return GestureDetector(
      onTap: () => setState(() => _statsType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Text(
          type[0].toUpperCase() + type.substring(1),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected
                ? const Color(0xFF4F46E5)
                : const Color(0xFF9CA3AF),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String amount,
    required String change,
    required bool isPositive,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive
                      ? const Color(0xFFDCFCE7)
                      : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isPositive
                        ? const Color(0xFF166534)
                        : const Color(0xFFDC2626),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBadge(String emoji) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 12))),
    );
  }

  Widget _buildDetailedLegendItem({
    required Color color,
    required String emoji,
    required String name,
    required String amount,
    required String percentage,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          color: onTap != null ? color.withOpacity(0.04) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 24,
              child: Text(emoji, style: const TextStyle(fontSize: 14)),
            ),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF374151),
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              percentage,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 75,
              child: Text(
                amount,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded,
                size: 18, color: Color(0xFFCBD5E1)),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetProgressBar(
    String category,
    double spent,
    double budget,
    Color color,
  ) {
    final progress = budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0.0;
    final isOver = spent > budget;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            Text(
              'RM ${spent.toStringAsFixed(0)} / RM ${budget.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 12,
                color: isOver
                    ? const Color(0xFFDC2626)
                    : const Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(4),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOver ? const Color(0xFFDC2626) : color,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showCategoryDetail(
    BuildContext context, {
    required String category,
    required double total,
    required Color color,
    required String emoji,
    required List<TransactionModel> transactions,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CategoryDetailSheet(
        category: category,
        total: total,
        color: color,
        emoji: emoji,
        transactions: transactions,
      ),
    );
  }
}

// ── Category detail bottom sheet ─────────────────────────────────────────────

class _CategoryDetailSheet extends StatelessWidget {
  const _CategoryDetailSheet({
    required this.category,
    required this.total,
    required this.color,
    required this.emoji,
    required this.transactions,
  });

  final String category;
  final double total;
  final Color color;
  final String emoji;
  final List<TransactionModel> transactions;

  static const _categoryIcons = <String, IconData>{
    'Food': Icons.local_cafe,
    'Shop': Icons.shopping_bag,
    'Travel': Icons.directions_car,
    'Health': Icons.favorite,
    'Play': Icons.sports_esports,
    'Gifts': Icons.card_giftcard,
    'Gift': Icons.card_giftcard,
    'Other': Icons.attach_money,
    'Salary': Icons.work,
    'Freelance': Icons.laptop_mac,
    'Business': Icons.store,
    'Investment': Icons.trending_up,
  };

  @override
  Widget build(BuildContext context) {
    final sorted = [...transactions]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final avgAmount = transactions.isEmpty
        ? 0.0
        : total / transactions.length;

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF8FAFF),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            // Handle bar
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Text(emoji,
                          style: const TextStyle(fontSize: 26)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF111827),
                          ),
                        ),
                        Text(
                          '${transactions.length} transaction${transactions.length == 1 ? '' : 's'}',
                          style: const TextStyle(
                              fontSize: 13, color: Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Stats row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _StatChip(
                    label: 'Total',
                    value: 'RM ${total.toStringAsFixed(2)}',
                    color: color,
                  ),
                  const SizedBox(width: 12),
                  _StatChip(
                    label: 'Avg per tx',
                    value: 'RM ${avgAmount.toStringAsFixed(2)}',
                    color: color,
                  ),
                  const SizedBox(width: 12),
                  _StatChip(
                    label: 'Count',
                    value: '${transactions.length}',
                    color: color,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  const Text(
                    'TRANSACTIONS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF94A3B8),
                      letterSpacing: 1.4,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'newest first',
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFFCBD5E1)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Transaction list
            Expanded(
              child: transactions.isEmpty
                  ? const Center(
                      child: Text('No transactions',
                          style: TextStyle(color: Color(0xFF94A3B8))),
                    )
                  : ListView.separated(
                      controller: controller,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: sorted.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final tx = sorted[i];
                        final icon = _categoryIcons[tx.category] ??
                            Icons.attach_money;
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: const Color(0xFFF1F5F9)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(icon,
                                    color: color, size: 22),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tx.title,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF111827),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      _formatDate(tx.createdAt),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF94A3B8)),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '-RM ${tx.amount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF111827),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = DateTime(now.year, now.month, now.day)
        .difference(DateTime(dt.year, dt.month, dt.day))
        .inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month]} · '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

extension _SortedEntries on List<MapEntry<String, double>> {
  List<MapEntry<String, double>> sorted() {
    return this..sort((a, b) => b.value.compareTo(a.value));
  }
}
