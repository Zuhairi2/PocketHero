import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/savings_goal_model.dart';
import '../models/transaction_model.dart';
import '../providers/auth_provider.dart';
import '../providers/budget_provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/fade_in_slide.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const _ranges = ['Week', 'Month', 'Year'];

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider>();
    final budgetProvider = context.watch<BudgetProvider>();
    final authProvider = context.watch<AuthProvider>();

    final summary = txProvider.summary;
    final income = summary['income'] ?? 0;
    final expense = summary['expense'] ?? 0;
    final balance = summary['balance'] ?? 0;
    final recent = txProvider.transactions.take(3).toList();

    final monthlyLimit = budgetProvider.monthlyLimit;
    final monthlyExpense = expense;
    final budgetProgress =
        monthlyLimit > 0 ? (monthlyExpense / monthlyLimit).clamp(0.0, 1.0) : 0.0;

    final firstGoal =
        budgetProvider.goals.isNotEmpty ? budgetProvider.goals.first : null;
    final firstName = authProvider.displayName.isNotEmpty
        ? authProvider.displayName
        : 'Hero';

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF8FAFF), Color(0xFFF5F3FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(firstName),
              const SizedBox(height: 20),
              FadeInSlide(
                duration: const Duration(milliseconds: 350),
                slideOffset: 16,
                child: _buildBalanceCard(balance, income, expense, txProvider),
              ),
              const SizedBox(height: 18),
              FadeInSlide(
                duration: const Duration(milliseconds: 450),
                slideOffset: 20,
                child: _buildActionRow(),
              ),
              const SizedBox(height: 18),
              FadeInSlide(
                duration: const Duration(milliseconds: 550),
                slideOffset: 20,
                child: _buildBudgetCard(monthlyExpense, monthlyLimit,
                    budgetProgress.toDouble()),
              ),
              const SizedBox(height: 18),
              FadeInSlide(
                duration: const Duration(milliseconds: 650),
                slideOffset: 20,
                child: _buildTransactionsCard(recent, txProvider.loading),
              ),
              if (firstGoal != null) ...[
                const SizedBox(height: 18),
                FadeInSlide(
                  duration: const Duration(milliseconds: 750),
                  slideOffset: 20,
                  child: _buildGoalCard(firstGoal, budgetProvider),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String firstName) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PocketHero',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$greeting, $firstName',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          height: 54,
          width: 54,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x334F46E5),
                blurRadius: 14,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.person_rounded, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(double balance, double income, double expense,
      TransactionProvider txProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF6D28D9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x404F46E5),
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'TOTAL BALANCE',
                style: TextStyle(
                  color: Color(0xFFE2E8F0),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              _buildRangeSelector(txProvider),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'RM ${balance.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  label: 'Income',
                  value: '+RM ${income.toStringAsFixed(2)}',
                  icon: Icons.south_west_rounded,
                  iconBg: const Color(0x3322C55E),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatTile(
                  label: 'Expense',
                  value: '-RM ${expense.toStringAsFixed(2)}',
                  icon: Icons.north_east_rounded,
                  iconBg: const Color(0x33FB7185),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRangeSelector(TransactionProvider txProvider) {
    return Wrap(
      spacing: 6,
      children: _ranges.map((range) {
        final selected = txProvider.range == range;
        return GestureDetector(
          onTap: () => txProvider.setRange(range),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: selected
                  ? Colors.white
                  : Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              range,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color:
                    selected ? const Color(0xFF4F46E5) : Colors.white,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionRow() {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            title: 'Add Income',
            icon: Icons.add_circle_rounded,
            color: const Color(0xFF10B981),
            onTap: () {},
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionButton(
            title: 'Add Expense',
            icon: Icons.remove_circle_rounded,
            color: const Color(0xFFF43F5E),
            onTap: () {},
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionButton(
            title: 'Set Goal',
            icon: Icons.track_changes_rounded,
            color: const Color(0xFF6366F1),
            onTap: () => _showSetGoalDialog(),
          ),
        ),
      ],
    );
  }

  void _showSetGoalDialog() {
    final nameCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Savings Goal',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration:
                  const InputDecoration(labelText: 'Goal name'),
            ),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Target amount (RM)'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5)),
            onPressed: () async {
              final name = nameCtrl.text.trim();
              final amount = double.tryParse(amountCtrl.text);
              if (name.isEmpty || amount == null || amount <= 0) return;
              await context
                  .read<BudgetProvider>()
                  .createGoal(name: name, targetAmount: amount);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Create',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetCard(
      double spent, double limit, double progress) {
    final remaining = limit - spent;
    final pct = (progress * 100).toStringAsFixed(1);
    final onTrack = progress < 0.8;

    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Budget Insight',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A)),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: onTrack
                      ? const Color(0xFFDCFCE7)
                      : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  onTrack ? 'On Track' : 'Over Budget',
                  style: TextStyle(
                    color: onTrack
                        ? const Color(0xFF166534)
                        : const Color(0xFFDC2626),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Spent RM ${spent.toStringAsFixed(2)} of RM ${limit.toStringAsFixed(2)} this month',
            style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(
                onTrack
                    ? const Color(0xFF4F46E5)
                    : const Color(0xFFDC2626),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'RM ${remaining.toStringAsFixed(2)} left',
                style: const TextStyle(
                    color: Color(0xFF334155),
                    fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text(
                '$pct% used',
                style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsCard(
      List<TransactionModel> transactions, bool loading) {
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Recent Transactions',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A)),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (loading)
            const Center(
                child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator()))
          else if (transactions.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text('No transactions yet',
                    style: TextStyle(color: Color(0xFF94A3B8))),
              ),
            )
          else
            ...transactions.map(_buildTransactionTile),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(TransactionModel item) {
    final categoryIcons = <String, IconData>{
      'Food': Icons.local_cafe_outlined,
      'Shop': Icons.shopping_bag_outlined,
      'Travel': Icons.directions_car_outlined,
      'Health': Icons.favorite_border,
      'Play': Icons.sports_esports_outlined,
      'Gifts': Icons.card_giftcard,
      'Salary': Icons.work_outline,
      'Freelance': Icons.laptop_mac_outlined,
      'Business': Icons.store_outlined,
      'Investment': Icons.trending_up_outlined,
      'Gift': Icons.card_giftcard,
    };
    final icon = categoryIcons[item.category] ?? Icons.attach_money;
    final color = item.isIncome
        ? const Color(0xFF16A34A)
        : const Color(0xFFF97316);

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Ink(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFFF8FAFC),
        ),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A))),
                  const SizedBox(height: 2),
                  Text(
                    '${item.category} • ${_formatDate(item.createdAt)}',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            Text(
              item.isIncome
                  ? '+RM ${item.amount.toStringAsFixed(2)}'
                  : '-RM ${item.amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: item.isIncome
                    ? const Color(0xFF16A34A)
                    : const Color(0xFFDC2626),
                fontWeight: FontWeight.w800,
              ),
            ),
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
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  Widget _buildGoalCard(SavingsGoal goal, BudgetProvider budgetProvider) {
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Savings Goal',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 10),
          Text(
            goal.name,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF334155)),
          ),
          const SizedBox(height: 6),
          Text(
            'RM ${goal.currentAmount.toStringAsFixed(2)} of RM ${goal.targetAmount.toStringAsFixed(2)}',
            style: const TextStyle(
                color: Color(0xFF64748B), fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: goal.progress,
              minHeight: 10,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF22C55E)),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _showTopUpDialog(goal, budgetProvider),
              icon: const Icon(Icons.add_circle_outline_rounded),
              label: const Text('Top Up'),
            ),
          ),
        ],
      ),
    );
  }

  void _showTopUpDialog(SavingsGoal goal, BudgetProvider provider) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Top Up — ${goal.name}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration:
              const InputDecoration(labelText: 'Amount (RM)'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E)),
            onPressed: () async {
              final amount = double.tryParse(ctrl.text);
              if (amount == null || amount <= 0) return;
              await provider.topUpGoal(goal.id, amount);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Add',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ── Shared widgets ──────────────────────────────────────────────────────────

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F0F172A),
              blurRadius: 18,
              offset: Offset(0, 8)),
        ],
      ),
      child: child,
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconBg,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color iconBg;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
              color: iconBg, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 18, color: Colors.white),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    color: Color(0xFFE2E8F0),
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800)),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF334155)),
            ),
          ],
        ),
      ),
    );
  }
}
