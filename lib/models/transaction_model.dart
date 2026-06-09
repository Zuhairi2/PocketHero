class TransactionModel {
  final String id;
  final String userId;
  final String title;
  final double amount;
  final String category;
  final bool isIncome;
  final String? note;
  final DateTime createdAt;

  const TransactionModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.category,
    required this.isIncome,
    this.note,
    required this.createdAt,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) => TransactionModel(
        id: map['id'] as String,
        userId: map['user_id'] as String,
        title: map['title'] as String,
        amount: (map['amount'] as num).toDouble(),
        category: map['category'] as String,
        isIncome: map['is_income'] as bool,
        note: map['note'] as String?,
        createdAt: DateTime.parse(map['created_at'] as String),
      );

  Map<String, dynamic> toInsertMap() => {
        'user_id': userId,
        'title': title,
        'amount': amount,
        'category': category,
        'is_income': isIncome,
        'note': note,
      };
}
