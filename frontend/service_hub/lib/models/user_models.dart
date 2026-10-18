class UserModel {
  final String fullName;
  final String email;
  final String phone;

  UserModel({required this.fullName, required this.email, required this.phone});

  Map<String, dynamic> toJson() {
    return {"fullName": fullName, "email": email, "phone": phone};
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json["full_name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
    );
  }
}
