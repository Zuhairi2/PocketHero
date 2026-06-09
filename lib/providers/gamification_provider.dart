import 'package:flutter/material.dart';
import '../models/gamification_model.dart';
import '../services/gamification_service.dart';

class GamificationProvider extends ChangeNotifier {
  final _service = GamificationService();

  GamificationModel? _data;
  bool _loading = false;

  GamificationModel? get data => _data;
  bool get loading => _loading;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    try {
      _data = await _service.get();
    } catch (_) {}
    _loading = false;
    notifyListeners();
  }

  Future<void> unlockAchievement(String id) async {
    await _service.unlockAchievement(id);
    await load();
  }
}
