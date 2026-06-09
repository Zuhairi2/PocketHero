import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';
import '../services/gamification_service.dart';

class TransactionProvider extends ChangeNotifier {
  final _txService = TransactionService();
  final _gamService = GamificationService();

  List<TransactionModel> _transactions = [];
  Map<String, double> _summary = {'income': 0, 'expense': 0, 'balance': 0};
  String _range = 'Month';
  bool _loading = false;
  String? _error;

  List<TransactionModel> get transactions => _transactions;
  Map<String, double> get summary => _summary;
  String get range => _range;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> load({String? range}) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      if (range != null) _range = range;
      _transactions = await _txService.fetchAll();
      _summary = await _txService.summary(_range);
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> addTransaction({
    required String title,
    required double amount,
    required String category,
    required bool isIncome,
    String? note,
  }) async {
    final tx = await _txService.insert(
      title: title,
      amount: amount,
      category: category,
      isIncome: isIncome,
      note: note,
    );
    _transactions.insert(0, tx);
    _summary = await _txService.summary(_range);
    await _gamService.addXpAndUpdateStreak(10);
    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    await _txService.delete(id);
    _transactions.removeWhere((t) => t.id == id);
    _summary = await _txService.summary(_range);
    notifyListeners();
  }

  void setRange(String range) {
    if (_range == range) return;
    load(range: range);
  }
}
