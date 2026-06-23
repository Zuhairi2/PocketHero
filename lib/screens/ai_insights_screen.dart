import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transaction_model.dart';
import '../providers/budget_provider.dart';
import '../providers/transaction_provider.dart';

class AIInsightsScreen extends StatelessWidget {
  const AIInsightsScreen({Key? key}) : super(key: key);

  // ── Insight derivation from real data ──────────────────────────────────────

  static Map<String, double> _categoryTotals(List<TransactionModel> txs) {
    final map = <String, double>{};
    for (final t in txs.where((t) => !t.isIncome)) {
      map[t.category] = (map[t.category] ?? 0) + t.amount;
    }
    return map;
  }

  static List<_Insight> _derive(
    List<TransactionModel> txs,
    double monthlyLimit,
    double balance,
  ) {
    final insights = <_Insight>[];
    final expenses = txs.where((t) => !t.isIncome).toList();
    final incomes = txs.where((t) => t.isIncome).toList();

    if (txs.isEmpty) return insights;

    final totalExpense = expenses.fold(0.0, (s, t) => s + t.amount);
    final totalIncome = incomes.fold(0.0, (s, t) => s + t.amount);

    // 1. Top spending category
    final cats = _categoryTotals(txs);
    if (cats.isNotEmpty) {
      final top = cats.entries.reduce((a, b) => a.value > b.value ? a : b);
      final pct = totalExpense > 0
          ? ((top.value / totalExpense) * 100).toStringAsFixed(0)
          : '0';
      insights.add(_Insight(
        type: _InsightType.warning,
        title: 'Top Spending: ${top.key}',
        body:
            'You\'ve spent RM ${top.value.toStringAsFixed(2)} on ${top.key} this period — $pct% of all your expenses.',
        tip: pct != '0' && int.parse(pct) > 40
            ? 'Consider setting a category limit for ${top.key}.'
            : 'This looks balanced. Keep it up!',
      ));
    }

    // 2. Savings rate
    if (totalIncome > 0) {
      final savingsRate = ((totalIncome - totalExpense) / totalIncome * 100);
      final rateStr = savingsRate.toStringAsFixed(1);
      final isGood = savingsRate >= 20;
      insights.add(_Insight(
        type: isGood ? _InsightType.positive : _InsightType.warning,
        title: isGood ? 'Healthy Savings Rate' : 'Low Savings Rate',
        body:
            'You\'re saving ${savingsRate < 0 ? '0.0' : rateStr}% of your income. ${isGood ? 'Great job!' : 'Financial experts recommend saving at least 20%.'}',
        tip: isGood
            ? 'You could explore investing your surplus.'
            : 'Try the 50/30/20 rule: 50% needs, 30% wants, 20% savings.',
      ));
    }

    // 3. Budget usage
    if (monthlyLimit > 0 && totalExpense > 0) {
      final usage = (totalExpense / monthlyLimit * 100).toStringAsFixed(1);
      final isOver = totalExpense > monthlyLimit;
      insights.add(_Insight(
        type: isOver ? _InsightType.alert : _InsightType.info,
        title: isOver ? 'Budget Exceeded' : 'Budget Usage: $usage%',
        body: isOver
            ? 'You\'ve exceeded your RM ${monthlyLimit.toStringAsFixed(2)} monthly budget by RM ${(totalExpense - monthlyLimit).toStringAsFixed(2)}.'
            : 'You\'ve used $usage% of your RM ${monthlyLimit.toStringAsFixed(2)} monthly budget.',
        tip: isOver
            ? 'Review your recent expenses and cut discretionary spending.'
            : totalExpense / monthlyLimit > 0.8
                ? 'You\'re close to your limit — slow down spending this month.'
                : 'You\'re on track. RM ${(monthlyLimit - totalExpense).toStringAsFixed(2)} remaining.',
      ));
    }

    // 4. Transaction frequency
    if (expenses.length >= 5) {
      final avgPerTx = totalExpense / expenses.length;
      insights.add(_Insight(
        type: _InsightType.info,
        title: 'Spending Frequency',
        body:
            'You made ${expenses.length} expense transactions with an average of RM ${avgPerTx.toStringAsFixed(2)} each.',
        tip: expenses.length > 15
            ? 'High transaction count — small purchases can add up fast.'
            : 'Your spending frequency looks manageable.',
      ));
    }

    // 5. Balance health
    if (balance < 0) {
      insights.add(_Insight(
        type: _InsightType.alert,
        title: 'Negative Balance Warning',
        body:
            'Your balance is RM ${balance.toStringAsFixed(2)}. You\'re spending more than you earn.',
        tip: 'Prioritise essential expenses only until your balance recovers.',
      ));
    } else if (balance > 0 && totalIncome > 0 && balance > totalIncome * 0.5) {
      insights.add(_Insight(
        type: _InsightType.positive,
        title: 'Strong Cash Position',
        body:
            'You have RM ${balance.toStringAsFixed(2)} available — over 50% of your income retained.',
        tip: 'Consider putting the surplus into a savings goal or investment.',
      ));
    }

    return insights;
  }

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider>();
    final budgetProvider = context.watch<BudgetProvider>();
    final txs = txProvider.transactions;
    final balance = txProvider.summary['balance'] ?? 0.0;
    final monthlyLimit = budgetProvider.monthlyLimit;
    final insights = _derive(txs, monthlyLimit, balance);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF0F172A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Smart Tips',
          style: TextStyle(
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w800,
              fontSize: 20),
        ),
        centerTitle: false,
      ),
      body: txs.length < 3 ? _buildNoData() : _buildInsights(insights),
    );
  }

  Widget _buildNoData() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.bar_chart_outlined,
                  size: 48, color: Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 20),
            const Text(
              'Not Enough Data',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 10),
            const Text(
              'Add at least 3 transactions to unlock smart tips about your spending behaviour.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF64748B), fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsights(List<_Insight> insights) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: Colors.white, size: 28),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Financial Smart Tips',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${insights.length} tip${insights.length == 1 ? '' : 's'} based on your data',
                        style: const TextStyle(
                            color: Color(0xFFE0E7FF), fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'YOUR TIPS',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF94A3B8),
                letterSpacing: 1.4),
          ),
          const SizedBox(height: 14),
          ...insights.map((i) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _InsightCard(insight: i),
              )),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Color(0xFF94A3B8)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tips are based on your recorded transactions and refresh automatically when new data is added.',
                    style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Data model ────────────────────────────────────────────────────────────────

enum _InsightType { positive, warning, alert, info }

class _Insight {
  const _Insight({
    required this.type,
    required this.title,
    required this.body,
    required this.tip,
  });
  final _InsightType type;
  final String title;
  final String body;
  final String tip;
}

// ── Insight card widget ───────────────────────────────────────────────────────

class _InsightCard extends StatefulWidget {
  const _InsightCard({required this.insight});
  final _Insight insight;

  @override
  State<_InsightCard> createState() => _InsightCardState();
}

class _InsightCardState extends State<_InsightCard> {
  bool _expanded = false;

  static const _colors = {
    _InsightType.positive: (
      bg: Color(0xFFDCFCE7),
      border: Color(0xFF86EFAC),
      icon: Color(0xFF16A34A),
      iconBg: Color(0xFFBBF7D0),
    ),
    _InsightType.warning: (
      bg: Color(0xFFFFF7ED),
      border: Color(0xFFFDBA74),
      icon: Color(0xFFEA580C),
      iconBg: Color(0xFFFED7AA),
    ),
    _InsightType.alert: (
      bg: Color(0xFFFEE2E2),
      border: Color(0xFFFCA5A5),
      icon: Color(0xFFDC2626),
      iconBg: Color(0xFFFECACA),
    ),
    _InsightType.info: (
      bg: Color(0xFFEEF2FF),
      border: Color(0xFFA5B4FC),
      icon: Color(0xFF4F46E5),
      iconBg: Color(0xFFC7D2FE),
    ),
  };

  static const _icons = {
    _InsightType.positive: Icons.trending_up_rounded,
    _InsightType.warning: Icons.warning_amber_rounded,
    _InsightType.alert: Icons.error_outline_rounded,
    _InsightType.info: Icons.lightbulb_outline_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final c = _colors[widget.insight.type]!;
    final icon = _icons[widget.insight.type]!;

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: c.bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: c.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: c.iconBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: c.icon, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.insight.title,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: c.icon),
                  ),
                ),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: c.icon,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.insight.body,
              style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF374151),
                  height: 1.5),
            ),
            if (_expanded) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.auto_awesome, size: 14, color: c.icon),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.insight.tip,
                        style: TextStyle(
                            fontSize: 12,
                            color: c.icon,
                            fontWeight: FontWeight.w600,
                            height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
