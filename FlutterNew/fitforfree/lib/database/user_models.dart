class User {
  final String email;

  User({required this.email});

  Map<String, dynamic> toMap() {
    return {'email': email};
  }
}
