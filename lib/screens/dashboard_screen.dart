import 'package:flutter/material.dart';

import '../widgets/fade_in_slide.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedRange = 'Month';

  final List<String> _ranges = ['Week', 'Month', 'Year'];

  final List<_TransactionItem> _transactions = const [
    _TransactionItem(
      title: 'Salary',
      category: 'Income',
      amount: 4200,
      isIncome: true,
      icon: Icons.work_rounded,
      color: Color(0xFF16A34A),
      dateLabel: 'Today',
    ),
    _TransactionItem(
      title: 'Groceries',
      category: 'Food',
      amount: 186.9,
      isIncome: false,
      icon: Icons.shopping_bag_rounded,
      color: Color(0xFFF97316),
      dateLabel: 'Yesterday',
    ),
    _TransactionItem(
      title: 'Netflix',
      category: 'Subscription',
      amount: 45,
      isIncome: false,
      icon: Icons.movie_creation_rounded,
      color: Color(0xFF8B5CF6),
      dateLabel: '2 days ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
              _buildHeader(),
              const SizedBox(height: 20),
              FadeInSlide(
                duration: const Duration(milliseconds: 350),
                slideOffset: 16,
                child: _buildBalanceCard(),
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
                child: _buildBudgetCard(),
              ),
              const SizedBox(height: 18),
              FadeInSlide(
                duration: const Duration(milliseconds: 650),
                slideOffset: 20,
                child: _buildTransactionsCard(),
              ),
              const SizedBox(height: 18),
              FadeInSlide(
                duration: const Duration(milliseconds: 750),
                slideOffset: 20,
                child: _buildGoalCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'PocketHero',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
                color: Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Good morning, Hafiz',
              style: TextStyle(
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
          child: IconButton(
            onPressed: () => _showInfo('Profile tapped'),
            icon: const Icon(Icons.person_rounded, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard() {
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
              _buildRangeSelector(),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'RM 12,450.80',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: const [
              Expanded(
                child: _StatTile(
                  label: 'Income',
                  value: '+RM 4,200',
                  icon: Icons.south_west_rounded,
                  iconBg: Color(0x3322C55E),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _StatTile(
                  label: 'Expense',
                  value: '-RM 1,850',
                  icon: Icons.north_east_rounded,
                  iconBg: Color(0x33FB7185),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRangeSelector() {
    return Wrap(
      spacing: 6,
      children: _ranges.map((range) {
        final bool selected = _selectedRange == range;
        return GestureDetector(
          onTap: () => setState(() => _selectedRange = range),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              range,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selected ? const Color(0xFF4F46E5) : Colors.white,
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
            onTap: () => _showInfo('Add Income clicked'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionButton(
            title: 'Add Expense',
            icon: Icons.remove_circle_rounded,
            color: const Color(0xFFF43F5E),
            onTap: () => _showInfo('Add Expense clicked'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionButton(
            title: 'Set Goal',
            icon: Icons.track_changes_rounded,
            color: const Color(0xFF6366F1),
            onTap: () => _showInfo('Set Goal clicked'),
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetCard() {
    const spent = 1850.0;
    const limit = 3000.0;
    final progress = spent / limit;

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
                  color: Color(0xFF0F172A),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'On Track',
                  style: TextStyle(
                    color: Color(0xFF166534),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Spent RM 1,850 of RM 3,000 this month',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4F46E5)),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Text(
                'RM 1,150 left',
                style: TextStyle(
                  color: Color(0xFF334155),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              Text(
                '61.6% used',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsCard() {
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
                  color: Color(0xFF0F172A),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _showInfo('View all transactions'),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._transactions.map(_buildTransactionTile),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(_TransactionItem item) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showInfo('${item.title} details'),
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
                  color: item.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: item.color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.category} • ${item.dateLabel}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                item.isIncome ? '+RM ${item.amount}' : '-RM ${item.amount}',
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
      ),
    );
  }

  Widget _buildGoalCard() {
    const current = 8800.0;
    const target = 12000.0;
    final completion = current / target;

    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Savings Goal',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Emergency Fund',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'RM 8,800 of RM 12,000',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: completion,
              minHeight: 10,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF22C55E)),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _showInfo('Top up goal'),
              icon: const Icon(Icons.add_circle_outline_rounded),
              label: const Text('Top Up'),
            ),
          ),
        ],
      ),
    );
  }

  void _showInfo(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}

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
            offset: Offset(0, 8),
          ),
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
            color: iconBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: Colors.white),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFFE2E8F0),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
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
                color: Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionItem {
  const _TransactionItem({
    required this.title,
    required this.category,
    required this.amount,
    required this.isIncome,
    required this.icon,
    required this.color,
    required this.dateLabel,
  });

  final String title;
  final String category;
  final double amount;
  final bool isIncome;
  final IconData icon;
  final Color color;
  final String dateLabel;
}
