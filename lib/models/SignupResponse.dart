class SignupResponse {
  bool success;
  String message;
  UserData data;

  SignupResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: UserData.fromJson(json["data"]),
    );
  }
}

class UserData {
  int userId;
  String name;
  String mobile;
  String profileImage;
  String username;
  String email;
  String token;
  String createdDate;

  UserData({
    required this.userId,
    required this.name,
    required this.mobile,
    required this.profileImage,
    required this.username,
    required this.email,
    required this.token,
    required this.createdDate,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json["user_id"] ?? 0,
      name: json["name"] ?? "",
      mobile: json["mobile"] ?? "",
      profileImage: json["profile_image"] ?? "",
      username: json["username"] ?? "",
      email: json["email"] ?? "",
      token: json["token"] ?? "",
      createdDate: json["created_date"] ?? "",
    );
  }
}