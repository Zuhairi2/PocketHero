import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/budget_model.dart';
import '../models/savings_goal_model.dart';

class BudgetService {
  SupabaseClient get _client => Supabase.instance.client;
  String? get _uid => _client.auth.currentUser?.id;

  Future<BudgetModel?> getMonthlyBudget() async {
    if (_uid == null) return null;
    final now = DateTime.now();
    final row = await _client
        .from('budget_limits')
        .select()
        .eq('user_id', _uid!)
        .eq('month', now.month)
        .eq('year', now.year)
        .maybeSingle();
    return row != null ? BudgetModel.fromMap(row) : null;
  }

  Future<void> setMonthlyBudget(double limit) async {
    if (_uid == null) return;
    final now = DateTime.now();
    await _client.from('budget_limits').upsert(
      {
        'user_id': _uid!,
        'monthly_limit': limit,
        'month': now.month,
        'year': now.year,
      },
      onConflict: 'user_id,month,year',
    );
  }

  Future<List<SavingsGoal>> getGoals() async {
    if (_uid == null) return [];
    final rows = await _client
        .from('savings_goals')
        .select()
        .eq('user_id', _uid!)
        .order('created_at');
    return rows.map(SavingsGoal.fromMap).toList();
  }

  Future<SavingsGoal> createGoal({
    required String name,
    required double targetAmount,
    DateTime? deadline,
  }) async {
    final row = await _client
        .from('savings_goals')
        .insert({
          'user_id': _uid!,
          'name': name,
          'target_amount': targetAmount,
          'current_amount': 0,
          'deadline': deadline?.toIso8601String().split('T')[0],
        })
        .select()
        .single();
    return SavingsGoal.fromMap(row);
  }

  Future<void> topUpGoal(String goalId, double amount) async {
    final row = await _client
        .from('savings_goals')
        .select('current_amount')
        .eq('id', goalId)
        .single();
    final newAmount = (row['current_amount'] as num).toDouble() + amount;
    await _client
        .from('savings_goals')
        .update({'current_amount': newAmount}).eq('id', goalId);
  }
}
