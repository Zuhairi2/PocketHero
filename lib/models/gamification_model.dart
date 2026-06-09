class GamificationModel {
  final String userId;
  final int xp;
  final int streakDays;
  final DateTime? lastLoggedAt;
  final List<String> unlockedAchievementIds;

  const GamificationModel({
    required this.userId,
    required this.xp,
    required this.streakDays,
    this.lastLoggedAt,
    required this.unlockedAchievementIds,
  });

  factory GamificationModel.fromMap(Map<String, dynamic> map) =>
      GamificationModel(
        userId: map['user_id'] as String,
        xp: map['xp'] as int,
        streakDays: map['streak_days'] as int,
        lastLoggedAt: map['last_logged_at'] != null
            ? DateTime.parse(map['last_logged_at'] as String)
            : null,
        unlockedAchievementIds:
            List<String>.from(map['unlocked_achievement_ids'] as List? ?? []),
      );

  // ── Rank thresholds ───────────────────────────────────────────────────────
  static const _thresholds = [0, 500, 1500, 3000, 6000, 10000];
  static const _rankNames = [
    'Bronze Beginner',
    'Silver Saver',
    'Gold Guardian',
    'Platinum Protector',
    'Diamond Master',
    'Pocket Hero',
  ];

  int get _rankIndex {
    for (var i = _thresholds.length - 1; i >= 0; i--) {
      if (xp >= _thresholds[i]) return i;
    }
    return 0;
  }

  String get rankName => _rankNames[_rankIndex];

  String get nextRankName {
    final next = _rankIndex + 1;
    return next < _rankNames.length ? _rankNames[next] : 'Max Rank';
  }

  double get rankProgress {
    final idx = _rankIndex;
    if (idx >= _thresholds.length - 1) return 1.0;
    final min = _thresholds[idx];
    final max = _thresholds[idx + 1];
    return ((xp - min) / (max - min)).clamp(0.0, 1.0);
  }
}
