import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import '../widgets/fade_in_slide.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = [
    'All', 'Food', 'Shop', 'Travel', 'Health', 'Play', 'Salary', 'Other'
  ];

  static const Map<String, IconData> _categoryIcons = {
    'Food': Icons.local_cafe,
    'Shop': Icons.shopping_bag,
    'Travel': Icons.directions_car,
    'Health': Icons.favorite,
    'Play': Icons.sports_esports,
    'Gifts': Icons.card_giftcard,
    'Salary': Icons.work,
    'Freelance': Icons.laptop_mac,
    'Business': Icons.store,
    'Investment': Icons.trending_up,
    'Gift': Icons.card_giftcard,
    'Other': Icons.attach_money,
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TransactionModel> _filtered(List<TransactionModel> all) {
    final q = _searchController.text.toLowerCase();
    return all.where((t) {
      final matchFilter =
          _selectedFilter == 'All' || t.category == _selectedFilter;
      final matchSearch =
          q.isEmpty || t.title.toLowerCase().contains(q);
      return matchFilter && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider>();
    final filtered = _filtered(txProvider.transactions);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            FadeInSlide(
              duration: const Duration(milliseconds: 400),
              slideOffset: 20,
              child: const Text(
                'Activity',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeInSlide(
              duration: const Duration(milliseconds: 500),
              slideOffset: 30,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Search transactions...',
                    hintStyle:
                        TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Color(0xFF94A3B8)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeInSlide(
              duration: const Duration(milliseconds: 600),
              slideOffset: 40,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: _filters.map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _selectedFilter = filter),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF4F46E5)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF4F46E5)
                                  : const Color(0xFFE2E8F0),
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF4F46E5)
                                          .withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    )
                                  ]
                                : [],
                          ),
                          child: Text(
                            filter,
                            style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF64748B),
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                fontSize: 14),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 32),
            FadeInSlide(
              duration: const Duration(milliseconds: 700),
              slideOffset: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'RECENT TRANSACTIONS',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF94A3B8),
                        letterSpacing: 1.5),
                  ),
                  Text(
                    '${filtered.length} items',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: txProvider.loading
                  ? const Center(child: CircularProgressIndicator())
                  : FadeInSlide(
                      duration: const Duration(milliseconds: 800),
                      slideOffset: 60,
                      child: filtered.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final tx = filtered[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 16.0),
                                  child: _buildActivityCard(tx),
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search_off,
                size: 48, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 16),
          const Text(
            'No transactions found',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827)),
          ),
          const SizedBox(height: 8),
          const Text('Try adjusting your search or filters.',
              style: TextStyle(color: Color(0xFF64748B))),
        ],
      ),
    );
  }

  Widget _buildActivityCard(TransactionModel tx) {
    final icon = _categoryIcons[tx.category] ?? Icons.attach_money;
    final dateStr = _formatDate(tx.createdAt);
    final timeStr =
        '${tx.createdAt.hour.toString().padLeft(2, '0')}:${tx.createdAt.minute.toString().padLeft(2, '0')}';

    return Dismissible(
      key: Key(tx.id),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFF43F5E),
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.centerRight,
        child:
            const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (_) async {
        await context.read<TransactionProvider>().deleteTransaction(tx.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${tx.title} deleted'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 20,
                offset: const Offset(0, 4))
          ],
          border: const Border.fromBorderSide(
              BorderSide(color: Color(0xFFF8FAFC), width: 2)),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: tx.isIncome
                    ? const Color(0xFFD1FAE5)
                    : const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                size: 28,
                color: tx.isIncome
                    ? const Color(0xFF10B981)
                    : const Color(0xFF4F46E5),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$dateStr • $timeStr',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            Text(
              tx.isIncome
                  ? '+RM ${tx.amount.toStringAsFixed(2)}'
                  : '-RM ${tx.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: tx.isIncome
                    ? const Color(0xFF10B981)
                    : const Color(0xFF111827),
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
    return '${dt.day} ${_month(dt.month)}';
  }

  String _month(int m) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[m];
  }
}
