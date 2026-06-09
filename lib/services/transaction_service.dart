import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/transaction_model.dart';

class TransactionService {
  SupabaseClient get _client => Supabase.instance.client;
  String? get _uid => _client.auth.currentUser?.id;

  Future<List<TransactionModel>> fetchAll() async {
    if (_uid == null) return [];
    final rows = await _client
        .from('transactions')
        .select()
        .eq('user_id', _uid!)
        .order('created_at', ascending: false);
    return rows.map(TransactionModel.fromMap).toList();
  }

  Future<TransactionModel> insert({
    required String title,
    required double amount,
    required String category,
    required bool isIncome,
    String? note,
  }) async {
    final row = await _client
        .from('transactions')
        .insert({
          'user_id': _uid!,
          'title': title,
          'amount': amount,
          'category': category,
          'is_income': isIncome,
          'note': note,
        })
        .select()
        .single();
    return TransactionModel.fromMap(row);
  }

  Future<void> delete(String id) async {
    await _client.from('transactions').delete().eq('id', id);
  }

  Future<Map<String, double>> summary(String range) async {
    if (_uid == null) return {'income': 0, 'expense': 0, 'balance': 0};

    final now = DateTime.now();
    final from = switch (range) {
      'Week' => now.subtract(const Duration(days: 7)),
      'Year' => DateTime(now.year, 1, 1),
      _ => DateTime(now.year, now.month, 1),
    };

    final rows = await _client
        .from('transactions')
        .select('amount, is_income')
        .eq('user_id', _uid!)
        .gte('created_at', from.toIso8601String());

    double income = 0, expense = 0;
    for (final r in rows) {
      final v = (r['amount'] as num).toDouble();
      if (r['is_income'] as bool) {
        income += v;
      } else {
        expense += v;
      }
    }
    return {'income': income, 'expense': expense, 'balance': income - expense};
  }
}
