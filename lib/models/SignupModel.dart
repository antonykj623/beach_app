class SignupModel {
  String name;
  String username;
  String email;
  String phone;
  int countryId;
  int stateId;
  String password;
  String confirmPassword;

  SignupModel({
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.countryId,
    required this.stateId,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "username": username,
      "email": email,
      "phone": phone,
      "country_id": countryId,
      "state_id": stateId,
      "password": password,
      "confirm_password": confirmPassword,
    };
  }
}