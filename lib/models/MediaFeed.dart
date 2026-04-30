class MediaModel {
  final int id;
  final String type;
  final String url;

  MediaModel({
    required this.id,
    required this.type,
    required this.url,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: json["media_id"],
      type: json["type"],
      url: json["media_url"],
    );
  }
}