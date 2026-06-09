class SavingsGoal {
  final String id;
  final String userId;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime? deadline;
  final DateTime createdAt;

  const SavingsGoal({
    required this.id,
    required this.userId,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    this.deadline,
    required this.createdAt,
  });

  factory SavingsGoal.fromMap(Map<String, dynamic> map) => SavingsGoal(
        id: map['id'] as String,
        userId: map['user_id'] as String,
        name: map['name'] as String,
        targetAmount: (map['target_amount'] as num).toDouble(),
        currentAmount: (map['current_amount'] as num).toDouble(),
        deadline: map['deadline'] != null
            ? DateTime.parse(map['deadline'] as String)
            : null,
        createdAt: DateTime.parse(map['created_at'] as String),
      );

  double get progress =>
      targetAmount > 0 ? (currentAmount / targetAmount).clamp(0.0, 1.0) : 0;
}
