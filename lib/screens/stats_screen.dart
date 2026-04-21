import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/fade_in_slide.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  String _statsType = 'weekly';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            // Header
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
                      amount: _statsType == 'weekly' ? 'RM 2,340' : 'RM 8,920',
                      change: _statsType == 'weekly' ? '+12%' : '+8%',
                      isPositive: false,
                      icon: Icons.trending_down,
                      color: const Color(0xFFEF4444),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Avg Daily',
                      amount: _statsType == 'weekly' ? 'RM 334' : 'RM 298',
                      change: _statsType == 'weekly' ? '-5%' : '+15%',
                      isPositive: _statsType == 'weekly' ? false : true,
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
                      amount: 'Food',
                      change: '35%',
                      isPositive: false,
                      icon: Icons.restaurant,
                      color: const Color(0xFFF59E0B),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Savings',
                      amount: _statsType == 'weekly' ? 'RM 1,200' : 'RM 4,800',
                      change: _statsType == 'weekly' ? '+18%' : '+22%',
                      isPositive: true,
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
                          _statsType == 'weekly'
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
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 50,
                            getDrawingHorizontalLine: (value) {
                              return const FlLine(
                                color: Color(0xFFF1F5F9),
                                strokeWidth: 1,
                                dashArray: [5, 5],
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const style = TextStyle(
                                    color: Color(0xFF94A3B8),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  );
                                  String text;
                                  if (_statsType == 'weekly') {
                                    switch (value.toInt()) {
                                      case 0:
                                        text = 'Mon';
                                        break;
                                      case 1:
                                        text = 'Tue';
                                        break;
                                      case 2:
                                        text = 'Wed';
                                        break;
                                      case 3:
                                        text = 'Thu';
                                        break;
                                      case 4:
                                        text = 'Fri';
                                        break;
                                      case 5:
                                        text = 'Sat';
                                        break;
                                      case 6:
                                        text = 'Sun';
                                        break;
                                      default:
                                        text = '';
                                        break;
                                    }
                                  } else {
                                    switch (value.toInt()) {
                                      case 0:
                                        text = 'Jan';
                                        break;
                                      case 1:
                                        text = 'Feb';
                                        break;
                                      case 2:
                                        text = 'Mar';
                                        break;
                                      case 3:
                                        text = 'Apr';
                                        break;
                                      case 4:
                                        text = 'May';
                                        break;
                                      case 5:
                                        text = 'Jun';
                                        break;
                                      default:
                                        text = '';
                                        break;
                                    }
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(text, style: style),
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
                              spots:
                                  _statsType == 'weekly'
                                      ? [
                                        const FlSpot(0, 320),
                                        const FlSpot(1, 280),
                                        const FlSpot(2, 450),
                                        const FlSpot(3, 380),
                                        const FlSpot(4, 520),
                                        const FlSpot(5, 480),
                                        const FlSpot(6, 350),
                                      ]
                                      : [
                                        const FlSpot(0, 2850),
                                        const FlSpot(1, 3200),
                                        const FlSpot(2, 2900),
                                        const FlSpot(3, 3400),
                                        const FlSpot(4, 3100),
                                        const FlSpot(5, 3600),
                                      ],
                              isCurved: true,
                              color: const Color(0xFF6366F1),
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 4,
                                    color: Colors.white,
                                    strokeWidth: 2,
                                    strokeColor: const Color(0xFF6366F1),
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                color: const Color(0xFF6366F1).withOpacity(0.1),
                              ),
                            ),
                          ],
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipItems: (
                                List<LineBarSpot> touchedBarSpots,
                              ) {
                                return touchedBarSpots.map((barSpot) {
                                  final flSpot = barSpot;
                                  return LineTooltipItem(
                                    'RM ${flSpot.y.toInt()}',
                                    const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }).toList();
                              },
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
                    Row(
                      children: [
                        SizedBox(
                          width: 140,
                          height: 140,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                              sections: [
                                PieChartSectionData(
                                  color: const Color(0xFF6366F1), // Food
                                  value: 35,
                                  title: '',
                                  radius: 22,
                                  badgeWidget: _buildCategoryBadge('🍕'),
                                ),
                                PieChartSectionData(
                                  color: const Color(0xFF06B6D4), // Transport
                                  value: 22,
                                  title: '',
                                  radius: 22,
                                  badgeWidget: _buildCategoryBadge('🚗'),
                                ),
                                PieChartSectionData(
                                  color: const Color(0xFF10B981), // Shopping
                                  value: 18,
                                  title: '',
                                  radius: 22,
                                  badgeWidget: _buildCategoryBadge('🛍️'),
                                ),
                                PieChartSectionData(
                                  color: const Color(0xFFF43F5E), // Rent
                                  value: 15,
                                  title: '',
                                  radius: 22,
                                  badgeWidget: _buildCategoryBadge('🏠'),
                                ),
                                PieChartSectionData(
                                  color: const Color(
                                    0xFFF59E0B,
                                  ), // Entertainment
                                  value: 10,
                                  title: '',
                                  radius: 22,
                                  badgeWidget: _buildCategoryBadge('🎬'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            children: [
                              _buildDetailedLegendItem(
                                const Color(0xFF6366F1),
                                '🍕 Food',
                                'RM 1,240',
                                '35%',
                              ),
                              const SizedBox(height: 12),
                              _buildDetailedLegendItem(
                                const Color(0xFF06B6D4),
                                '🚗 Transport',
                                'RM 780',
                                '22%',
                              ),
                              const SizedBox(height: 12),
                              _buildDetailedLegendItem(
                                const Color(0xFF10B981),
                                '🛍️ Shopping',
                                'RM 640',
                                '18%',
                              ),
                              const SizedBox(height: 12),
                              _buildDetailedLegendItem(
                                const Color(0xFFF43F5E),
                                '🏠 Rent',
                                'RM 530',
                                '15%',
                              ),
                              const SizedBox(height: 12),
                              _buildDetailedLegendItem(
                                const Color(0xFFF59E0B),
                                '🎬 Entertainment',
                                'RM 350',
                                '10%',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Budget Progress
            FadeInSlide(
              duration: const Duration(milliseconds: 900),
              slideOffset: 70,
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
                        const Text(
                          'Budget Progress',
                          style: TextStyle(
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
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'On Track',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF166534),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildBudgetProgress(
                      'Food',
                      1240,
                      1500,
                      const Color(0xFF6366F1),
                    ),
                    const SizedBox(height: 16),
                    _buildBudgetProgress(
                      'Transport',
                      780,
                      1000,
                      const Color(0xFF06B6D4),
                    ),
                    const SizedBox(height: 16),
                    _buildBudgetProgress(
                      'Entertainment',
                      350,
                      500,
                      const Color(0xFFF59E0B),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 100), // Bottom padding for nav bar
          ],
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      isPositive
                          ? const Color(0xFFDCFCE7)
                          : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color:
                        isPositive
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String type) {
    bool isSelected = _statsType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _statsType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow:
              isSelected
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
            color:
                isSelected ? const Color(0xFF4F46E5) : const Color(0xFF9CA3AF),
          ),
        ),
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

  Widget _buildDetailedLegendItem(
    Color color,
    String name,
    String amount,
    String percentage,
  ) {
    return Row(
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
        Expanded(
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF374151),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amount,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            Text(
              percentage,
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBudgetProgress(
    String category,
    double spent,
    double budget,
    Color color,
  ) {
    double progress = spent / budget;
    bool isOverBudget = progress > 1.0;

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
              'RM ${spent.toInt()} / RM ${budget.toInt()}',
              style: TextStyle(
                fontSize: 12,
                color:
                    isOverBudget
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
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOverBudget ? const Color(0xFFDC2626) : color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
