class BudgetModel {
  final String id;
  final String userId;
  final double monthlyLimit;
  final int month;
  final int year;

  const BudgetModel({
    required this.id,
    required this.userId,
    required this.monthlyLimit,
    required this.month,
    required this.year,
  });

  factory BudgetModel.fromMap(Map<String, dynamic> map) => BudgetModel(
        id: map['id'] as String,
        userId: map['user_id'] as String,
        monthlyLimit: (map['monthly_limit'] as num).toDouble(),
        month: map['month'] as int,
        year: map['year'] as int,
      );
}
