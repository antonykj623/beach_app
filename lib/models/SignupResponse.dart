class SignupResponse {
  final bool success;
  final String message;
  final UserData? data; // ✅ nullable

  SignupResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] != null
          ? UserData.fromJson(json["data"])
          : null, // ✅ safe parsing
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "data": data?.toJson(),
    };
  }
}

class UserData {
  final int userId;
  final String name;
  final String mobile;
  final String profileImage;
  final String username;
  final String email;
  final String token;
  final String createdDate;

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

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "name": name,
      "mobile": mobile,
      "profile_image": profileImage,
      "username": username,
      "email": email,
      "token": token,
      "created_date": createdDate,
    };
  }
}