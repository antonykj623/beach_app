class StoriesResponse {
  final bool status;
  final String message;
  final List<Story> data;

  StoriesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory StoriesResponse.fromJson(Map<String, dynamic> json) {
    return StoriesResponse(
      status: json["Status"] ?? false,
      message: json["Message"] ?? "",
      data: json["Data"] != null
          ? List<Story>.from(
          json["Data"].map((x) => Story.fromJson(x)))
          : [],
    );
  }
}

class Story {
  final int id;
  final String? title;
  final String? description;
  final String? image;
  final String? video;
  final String createdDate;

  Story({
    required this.id,
    this.title,
    this.description,
    this.image,
    this.video,
    required this.createdDate,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json["Id"] ?? 0,
      title: json["Title"],
      description: json["Description"],
      image: json["Image"],
      video: json["Video"],
      createdDate: json["Created_date"] ?? "",
    );
  }
}