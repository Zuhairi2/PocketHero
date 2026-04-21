import 'package:flutter/material.dart';
import '../widgets/fade_in_slide.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = ['All', 'Food', 'Transport', 'Rent', 'Shopping', 'Health', 'Travel'];

  final List<Map<String, dynamic>> _activities = [
    {
      'id': '1',
      'title': 'Grab Food',
      'time': '2:30 PM',
      'date': 'Today',
      'amount': '-RM 24.50',
      'isPositive': false,
      'icon': Icons.fastfood,
      'category': 'Food',
    },
    {
      'id': '2',
      'title': 'Petronas Fuel',
      'time': '11:20 AM',
      'date': 'Today',
      'amount': '-RM 50.00',
      'isPositive': false,
      'icon': Icons.local_gas_station,
      'category': 'Transport',
    },
    {
      'id': '3',
      'title': 'Salary Deposit',
      'time': '9:00 AM',
      'date': 'Yesterday',
      'amount': '+RM 3,200.00',
      'isPositive': true,
      'icon': Icons.account_balance_wallet,
      'category': 'Income',
    },
    {
      'id': '4',
      'title': 'Netflix Subscription',
      'time': '8:00 AM',
      'date': 'Yesterday',
      'amount': '-RM 55.00',
      'isPositive': false,
      'icon': Icons.movie,
      'category': 'Entertainment',
    },
    {
      'id': '5',
      'title': 'Grocery Store',
      'time': '6:30 PM',
      'date': '20 Oct',
      'amount': '-RM 120.00',
      'isPositive': false,
      'icon': Icons.shopping_cart,
      'category': 'Shopping',
    },
    {
      'id': '6',
      'title': 'Gym Membership',
      'time': '7:00 AM',
      'date': '20 Oct',
      'amount': '-RM 150.00',
      'isPositive': false,
      'icon': Icons.fitness_center,
      'category': 'Health',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter logic
    final filteredActivities = _activities.where((activity) {
      final matchesFilter = _selectedFilter == 'All' || activity['category'] == _selectedFilter;
      final matchesSearch = activity['title'].toString().toLowerCase().contains(_searchController.text.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            
            // Header
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

            // Search Bar
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
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Search transactions...',
                    hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Color(0xFF94A3B8)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Filters
            FadeInSlide(
              duration: const Duration(milliseconds: 600),
              slideOffset: 40,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: _filters.map((filter) {
                    bool isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF4F46E5) : Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF4F46E5).withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    )
                                  ]
                                : [],
                          ),
                          child: Text(
                            filter,
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFF64748B),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Activities Title
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
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    '${filteredActivities.length} items',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Activities List
            Expanded(
              child: FadeInSlide(
                duration: const Duration(milliseconds: 800),
                slideOffset: 60,
                child: filteredActivities.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: filteredActivities.length,
                      itemBuilder: (context, index) {
                        final activity = filteredActivities[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _buildActivityCard(activity),
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
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search_off, size: 48, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 16),
          const Text(
            'No transactions found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your search or filters.',
            style: TextStyle(color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    return Dismissible(
      key: Key(activity['id']),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFF43F5E),
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (direction) {
        setState(() {
          _activities.removeWhere((item) => item['id'] == activity['id']);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${activity['title']} deleted'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            action: SnackBarAction(
              label: 'Undo',
              textColor: Colors.white,
              onPressed: () {
                // Mock undo
              },
            ),
          ),
        );
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
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: const Color(0xFFF8FAFC),
            width: 2,
          )
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: activity['isPositive'] 
                  ? const Color(0xFFD1FAE5) // Light green
                  : const Color(0xFFEEF2FF), // Light indigo
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                activity['icon'],
                size: 28,
                color: activity['isPositive'] 
                  ? const Color(0xFF10B981) // Green
                  : const Color(0xFF4F46E5), // Indigo
              ),
            ),
            const SizedBox(width: 16),
            
            // Title & Category
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${activity['date']} • ${activity['time']}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            
            // Amount
            Text(
              activity['amount'],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: activity['isPositive']
                    ? const Color(0xFF10B981) // Green
                    : const Color(0xFF111827), // Dark text instead of red for a cleaner look
              ),
            ),
          ],
        ),
      ),
    );
  }
}
