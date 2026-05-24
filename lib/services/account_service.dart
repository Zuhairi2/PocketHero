class UserProfile {
  String fullName;
  String email;
  String phoneNumber;
  String? avatarUrl;

  UserProfile({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.avatarUrl,
  });

  UserProfile copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? avatarUrl,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

class AccountService {
  static final AccountService instance = AccountService._internal();

  AccountService._internal();

  // In-memory user profile data acting as our local mock database.
  UserProfile _profile = UserProfile(
    fullName: 'Wan Hafizuddin',
    email: 'hafiz@glowcare.com',
    phoneNumber: '+60 12-345 6789',
  );

  /// Fetches the user profile.
  Future<UserProfile> getProfile() async {
    // Simulate database delay
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return _profile;
  }

  /// Updates the user profile.
  Future<bool> updateProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
    String? avatarUrl,
  }) async {
    // Simulate database delay
    await Future<void>.delayed(const Duration(milliseconds: 600));
    _profile = _profile.copyWith(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      avatarUrl: avatarUrl,
    );
    return true;
  }
}
