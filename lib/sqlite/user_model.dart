class User {
  int? id;
  String fullName;
  String email;
  String password;

  User({required this.fullName, required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'password': password,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      fullName: map['fullName'],
      email: map['email'],
      password: map['password'],
    );
  }
}
