class User {
  final String id;
  final String username;
  final String password;

  User({
    required this.id,
    required this.username,
    required this.password,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        password = json['password'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }
}
