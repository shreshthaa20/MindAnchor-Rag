class AppUser {
  final int id;
  final String name;
  final String email;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
}

class UserSession {
  final String token;
  final AppUser user;

  const UserSession({
    required this.token,
    required this.user,
  });
}
