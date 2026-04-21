import 'package:flutter/material.dart';

class AddTransactionModal extends StatefulWidget {
  const AddTransactionModal({Key? key}) : super(key: key);

  @override
  State<AddTransactionModal> createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends State<AddTransactionModal> {
  bool _isExpense = true;
  String _selectedCategory = 'Food'; // Default selection

  final List<Map<String, dynamic>> _expenseCategories = [
    {'icon': Icons.shopping_bag_outlined, 'label': 'Shop'},
    {'icon': Icons.local_cafe_outlined, 'label': 'Food'},
    {'icon': Icons.directions_car_outlined, 'label': 'Travel'},
    {'icon': Icons.sports_esports_outlined, 'label': 'Play'},
    {'icon': Icons.favorite_border, 'label': 'Health'},
    {'icon': Icons.card_giftcard, 'label': 'Gifts'},
    {'icon': Icons.search, 'label': 'Other'},
  ];

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
        mainAxisSize: MainAxisSize.min, // To make it wrap content
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
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

          // Toggle Buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isExpense = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: _isExpense ? Colors.white : Colors.white,
                      border: Border.all(
                        color: _isExpense ? const Color(0xFFF43F5E) : const Color(0xFFE2E8F0),
                        width: _isExpense ? 1.5 : 1.0,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_outward,
                          color: _isExpense ? const Color(0xFFF43F5E) : const Color(0xFF94A3B8),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Expense',
                          style: TextStyle(
                            color: _isExpense ? const Color(0xFFF43F5E) : const Color(0xFF6B7280),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isExpense = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: !_isExpense ? Colors.white : Colors.white,
                      border: Border.all(
                        color: !_isExpense ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
                        width: !_isExpense ? 1.5 : 1.0,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.call_received,
                          color: !_isExpense ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Income',
                          style: TextStyle(
                            color: !_isExpense ? const Color(0xFF10B981) : const Color(0xFF6B7280),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Title & Scan Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isExpense ? 'Add Expense' : 'Add Income',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              if (_isExpense)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.qr_code_scanner, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'AI Scan Receipt',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),

          // Amount Input
          const Text(
            'Amount',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF94A3B8),
              fontWeight: FontWeight.w500,
            ),
          ),
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
                  color: _isExpense ? const Color(0xFFF43F5E) : const Color(0xFF10B981),
                  height: 1.2,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6B7280), // Gray until focused/typed
                  ),
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

          // Categories Grid
          if (_isExpense)
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
                itemCount: _expenseCategories.length,
                itemBuilder: (context, index) {
                  final cat = _expenseCategories[index];
                  bool isSelected = _selectedCategory == cat['label'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = cat['label'];
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFFEE2E2) : const Color(0xFFF8FAFC), // Light red or light gray
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? const Color(0xFFFCA5A5) : Colors.transparent,
                            ),
                          ),
                          child: Icon(
                            cat['icon'],
                            color: isSelected ? const Color(0xFFF43F5E) : const Color(0xFF64748B),
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          cat['label'],
                          style: TextStyle(
                            fontSize: 11,
                            color: isSelected ? const Color(0xFFF43F5E) : const Color(0xFF94A3B8),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

          if (!_isExpense)
             const SizedBox(height: 180), // Placeholder to maintain height

          const SizedBox(height: 24),

          // Save Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close modal
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _isExpense ? const Color(0xFFE11D48) : const Color(0xFF10B981),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                _isExpense ? 'Save Expense' : 'Save Income',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // To push it above keyboard if needed
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
