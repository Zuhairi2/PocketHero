import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transaction_provider.dart';

class AddTransactionModal extends StatefulWidget {
  const AddTransactionModal({Key? key, this.onSaved}) : super(key: key);

  final VoidCallback? onSaved;

  @override
  State<AddTransactionModal> createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends State<AddTransactionModal> {
  bool _isExpense = true;
  String _selectedCategory = 'Food';
  bool _saving = false;

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  final List<Map<String, dynamic>> _expenseCategories = [
    {'icon': Icons.shopping_bag_outlined, 'label': 'Shop'},
    {'icon': Icons.local_cafe_outlined, 'label': 'Food'},
    {'icon': Icons.directions_car_outlined, 'label': 'Travel'},
    {'icon': Icons.sports_esports_outlined, 'label': 'Play'},
    {'icon': Icons.favorite_border, 'label': 'Health'},
    {'icon': Icons.card_giftcard, 'label': 'Gifts'},
    {'icon': Icons.search, 'label': 'Other'},
  ];

  final List<Map<String, dynamic>> _incomeCategories = [
    {'icon': Icons.work_outline, 'label': 'Salary'},
    {'icon': Icons.laptop_mac_outlined, 'label': 'Freelance'},
    {'icon': Icons.store_outlined, 'label': 'Business'},
    {'icon': Icons.trending_up_outlined, 'label': 'Investment'},
    {'icon': Icons.card_giftcard, 'label': 'Gift'},
    {'icon': Icons.more_horiz, 'label': 'Other'},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _categories =>
      _isExpense ? _expenseCategories : _incomeCategories;

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final amountText = _amountController.text.trim();

    if (title.isEmpty) {
      _showError('Please enter a title');
      return;
    }
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      _showError('Please enter a valid amount');
      return;
    }

    setState(() => _saving = true);
    try {
      await context.read<TransactionProvider>().addTransaction(
            title: title,
            amount: amount,
            category: _selectedCategory,
            isIncome: !_isExpense,
          );
      if (mounted) {
        Navigator.pop(context);
        widget.onSaved?.call();
      }
    } catch (e) {
      if (mounted) _showError('Failed to save. Please try again.');
    }
    if (mounted) setState(() => _saving = false);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Expense / Income toggle
          Row(
            children: [
              Expanded(child: _toggleBtn(isExpense: true)),
              const SizedBox(width: 12),
              Expanded(child: _toggleBtn(isExpense: false)),
            ],
          ),
          const SizedBox(height: 24),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isExpense ? 'Add Expense' : 'Add Income',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827)),
              ),
              if (_isExpense)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.qr_code_scanner,
                          color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'AI Scan Receipt',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Title field
          const Text('Title',
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            textCapitalization: TextCapitalization.sentences,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827)),
            decoration: const InputDecoration(
              hintText: 'e.g. Lunch at Mamak',
              hintStyle:
                  TextStyle(color: Color(0xFF9CA3AF), fontWeight: FontWeight.w400),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE2E8F0))),
              focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color(0xFF4F46E5), width: 2)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE2E8F0))),
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
          ),
          const SizedBox(height: 20),

          // Amount field
          const Text('Amount',
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _isExpense ? '-\nRM' : '+\nRM',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _isExpense
                        ? const Color(0xFFF43F5E)
                        : const Color(0xFF10B981),
                    height: 1.2),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B7280)),
                  decoration: const InputDecoration(
                    hintText: '0.00',
                    hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Categories
          SizedBox(
            height: 180,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat['label'];
                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedCategory = cat['label']),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (_isExpense
                                  ? const Color(0xFFFEE2E2)
                                  : const Color(0xFFD1FAE5))
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? (_isExpense
                                    ? const Color(0xFFFCA5A5)
                                    : const Color(0xFF6EE7B7))
                                : Colors.transparent,
                          ),
                        ),
                        child: Icon(
                          cat['icon'] as IconData,
                          color: isSelected
                              ? (_isExpense
                                  ? const Color(0xFFF43F5E)
                                  : const Color(0xFF10B981))
                              : const Color(0xFF64748B),
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        cat['label'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          color: isSelected
                              ? (_isExpense
                                  ? const Color(0xFFF43F5E)
                                  : const Color(0xFF10B981))
                              : const Color(0xFF94A3B8),
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Save button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isExpense
                    ? const Color(0xFFE11D48)
                    : const Color(0xFF10B981),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: _saving
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5),
                    )
                  : Text(
                      _isExpense ? 'Save Expense' : 'Save Income',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  Widget _toggleBtn({required bool isExpense}) {
    final active = _isExpense == isExpense;
    final activeColor =
        isExpense ? const Color(0xFFF43F5E) : const Color(0xFF10B981);
    return GestureDetector(
      onTap: () => setState(() {
        _isExpense = isExpense;
        _selectedCategory = isExpense ? 'Food' : 'Salary';
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: active ? activeColor : const Color(0xFFE2E8F0),
            width: active ? 1.5 : 1.0,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isExpense ? Icons.arrow_outward : Icons.call_received,
              color: active ? activeColor : const Color(0xFF94A3B8),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              isExpense ? 'Expense' : 'Income',
              style: TextStyle(
                  color:
                      active ? activeColor : const Color(0xFF6B7280),
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
