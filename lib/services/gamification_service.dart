import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/gamification_model.dart';

class GamificationService {
  SupabaseClient get _client => Supabase.instance.client;
  String? get _uid => _client.auth.currentUser?.id;

  Future<GamificationModel?> get() async {
    if (_uid == null) return null;
    final row = await _client
        .from('user_gamification')
        .select()
        .eq('user_id', _uid!)
        .maybeSingle();
    return row != null ? GamificationModel.fromMap(row) : null;
  }

  Future<void> addXpAndUpdateStreak(int xpGain) async {
    if (_uid == null) return;
    final current = await get();
    if (current == null) return;

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final lastLogged = current.lastLoggedAt != null
        ? DateTime(current.lastLoggedAt!.year, current.lastLoggedAt!.month,
            current.lastLoggedAt!.day)
        : null;

    int newStreak;
    if (lastLogged == null) {
      newStreak = 1;
    } else if (todayDate == lastLogged) {
      newStreak = current.streakDays;
    } else if (todayDate.difference(lastLogged).inDays == 1) {
      newStreak = current.streakDays + 1;
    } else {
      newStreak = 1;
    }

    await _client.from('user_gamification').update({
      'xp': current.xp + xpGain,
      'streak_days': newStreak,
      'last_logged_at': todayDate.toIso8601String().split('T')[0],
    }).eq('user_id', _uid!);
  }

  Future<void> unlockAchievement(String achievementId) async {
    if (_uid == null) return;
    final current = await get();
    if (current == null ||
        current.unlockedAchievementIds.contains(achievementId)) {
      return;
    }
    await _client.from('user_gamification').update({
      'unlocked_achievement_ids': [
        ...current.unlockedAchievementIds,
        achievementId,
      ],
    }).eq('user_id', _uid!);
  }
}
