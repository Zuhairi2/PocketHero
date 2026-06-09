class AppUser {
  final String id;
  final String fullName;
  final String email;

  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) => AppUser(
        id: map['id'] as String,
        fullName: map['full_name'] as String? ?? '',
        email: map['email'] as String? ?? '',
      );
}
