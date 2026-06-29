import 'package:flutter/material.dart';
import '../models/budget_model.dart';
import '../models/savings_goal_model.dart';
import '../services/budget_service.dart';
import '../services/transaction_service.dart';

class BudgetProvider extends ChangeNotifier {
  final _service = BudgetService();
  final _txService = TransactionService();

  BudgetModel? _budget;
  List<SavingsGoal> _goals = [];
  bool _loading = false;

  BudgetModel? get budget => _budget;
  List<SavingsGoal> get goals => _goals;
  bool get loading => _loading;
  double get monthlyLimit => _budget?.monthlyLimit ?? 3000;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    try {
      _budget = await _service.getMonthlyBudget();
      _goals = await _service.getGoals();
    } catch (_) {}
    _loading = false;
    notifyListeners();
  }

  Future<void> setMonthlyBudget(double limit) async {
    await _service.setMonthlyBudget(limit);
    await load();
  }

  Future<void> createGoal({
    required String name,
    required double targetAmount,
    DateTime? deadline,
  }) async {
    await _service.createGoal(
        name: name, targetAmount: targetAmount, deadline: deadline);
    await load();
  }

  Future<void> deleteGoal(String goalId) async {
    await _service.deleteGoal(goalId);
    _goals.removeWhere((g) => g.id == goalId);
    notifyListeners();
  }

  Future<void> topUpGoal(String goalId, double amount, String goalName) async {
    await _service.topUpGoal(goalId, amount);
    await _txService.insert(
      title: 'Savings: $goalName',
      amount: amount,
      category: 'Savings',
      isIncome: false,
      note: 'Top-up for savings goal',
    );
    await load();
  }

  Future<void> withdrawFromGoal(String goalId, double amount, String goalName) async {
    await _service.withdrawFromGoal(goalId, amount);
    await _txService.insert(
      title: 'Savings Withdrawal: $goalName',
      amount: amount,
      category: 'Savings',
      isIncome: true,
      note: 'Withdrawal from savings goal',
    );
    await load();
  }
}
