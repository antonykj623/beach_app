class NotificationModel {
  final int id;
  final String title;
  final String description;
  final String date;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json["Id"] ?? 0,
      title: json["Title"] ?? "",
      description: json["Description"] ?? "",
      date: json["Created_date"] ?? "",
    );
  }
}