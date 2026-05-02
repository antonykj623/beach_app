import 'dart:convert';
import 'package:beach_app/utilities/Utils.dart';
import 'package:beach_app/utilities/native_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  List notifications = [];

  int page = 1;
  bool isLoading = false;
  bool hasNext = true;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchNotifications();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (hasNext && !isLoading) {
          page++;
          fetchNotifications();
        }
      }
    });
  }

  Future<void> fetchNotifications() async {
    setState(() => isLoading = true);

    String? v=await NativeStorage.getValue(Utils.token);

    final url = Uri.parse(
        "https://beach.adpedia.in/api/notification?page=$page&limit=10");

    final response = await http.get(url, headers: {"Authorization":"Bearer "+v!});

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData["Status"] == true) {
        setState(() {
          notifications.addAll(jsonData["Data"]);
          hasNext = jsonData["Pagination"]["has_next"];
        });
      }
    }

    setState(() => isLoading = false);
  }

  /// 🔹 FORMAT DATE (simple)
  String formatDate(String date) {
    return date.split(" ")[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Notifications"),
      ),

      body: notifications.isEmpty && isLoading
          ? Center(child: CircularProgressIndicator())
          : notifications.isEmpty
          ? Center(
        child: Text(
          "No Notifications",
          style: TextStyle(color: Colors.white),
        ),
      )
          : ListView.builder(
        controller: scrollController,
        itemCount: notifications.length + 1,
        itemBuilder: (context, index) {

          if (index == notifications.length) {
            return hasNext
                ? Padding(
              padding: EdgeInsets.all(15),
              child: Center(
                  child: CircularProgressIndicator()),
            )
                : SizedBox();
          }

          final item = notifications[index];

          return Container(
            margin:
            EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [

                /// 🔹 ICON
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.notifications,
                      color: Colors.white, size: 18),
                ),

                SizedBox(width: 12),

                /// 🔹 TEXT
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      Text(
                        item["Title"],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 4),

                      Text(
                        item["Description"],
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                /// 🔹 DATE
                Text(
                  formatDate(item["Created_date"]),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}