class UserInfo {
  final int id;
  final String name;
  final String email;

  UserInfo({
    required this.id,
    required this.name,
    required this.email,
  });

  String get _email => email;
  String get _name => name;
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}