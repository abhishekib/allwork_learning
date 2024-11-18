class UserInfo {
  final String firstName;
  final String lastName;
  final String gender;
  final String phone;
  final String? email;

  UserInfo({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.phone,
    this.email,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      firstName: json['firstname'] ?? '',
      lastName: json['lastname'] ?? '',
      gender: json['gender'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'],
    );
  }
}
