class ProfileModel {
  final int id;
  final String name;
  final String username;
  final String email;
  final int countryId;
  final int stateId;
  final String? profileImage;
  final String? bio;
  final int followers;
  final int following;

  ProfileModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.countryId,
    required this.stateId,
    this.profileImage,
    this.bio,
    required this.followers,
    required this.following,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      countryId: json['country_id'],
      stateId: json['state_id'],
      profileImage: json['profile_image'],
      bio: json['bio'],
      followers: json['followers'],
      following: json['following'],
    );
  }
}