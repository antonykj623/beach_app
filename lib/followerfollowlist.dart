import 'dart:convert';

import 'package:beach_app/utilities/Utils.dart';
import 'package:beach_app/utilities/native_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FollowersFollowingScreen
    extends StatefulWidget {

  /// 0 = Followers
  /// 1 = Following
  final int initialTab;

  const FollowersFollowingScreen({

    super.key,

    required this.initialTab,
  });

  @override
  State<FollowersFollowingScreen>
  createState() =>
      _FollowersFollowingScreenState();
}

class _FollowersFollowingScreenState
    extends State<FollowersFollowingScreen>
    with SingleTickerProviderStateMixin {

  late TabController tabController;

  /// 🔥 FOLLOWERS
  List followersList = [];

  /// 🔥 FOLLOWING
  List followingList = [];

  bool loadingFollowers = true;

  bool loadingFollowing = true;

  /// 🔥 TOKEN
  String token = "";

  @override
  void initState() {

    super.initState();
    getToken();

    tabController = TabController(

      length: 2,

      vsync: this,

      initialIndex: widget.initialTab,
    );

    getFollowers();

    getFollowing();
  }
  getToken()async{

    String? v=await NativeStorage.getValue(Utils.token);
    token=v.toString();
  }

  /// 🔥 FOLLOWERS API
  Future<void> getFollowers() async {

    try {

      String? v=await NativeStorage.getValue(Utils.token);
      token=v.toString();
      setState(() {

        loadingFollowers = true;
      });

      final response = await http.get(

        Uri.parse(
          "https://beach.adpedia.in/api/followers-list",
        ),

        headers: {

          "Authorization":
          "Bearer $token",
        },
      );

      final data =
      jsonDecode(response.body);

      print(data);

      if (data["status"] == true) {

        setState(() {

          followersList = data["data"];
        });
      }

    } catch (e) {

      print(e);
    }

    setState(() {

      loadingFollowers = false;
    });
  }

  /// 🔥 FOLLOWING API
  Future<void> getFollowing() async {

    try {

      String? v=await NativeStorage.getValue(Utils.token);
      token=v.toString();
      setState(() {

        loadingFollowing = true;
      });

      final response = await http.get(

        Uri.parse(
          "https://beach.adpedia.in/api/following-list",
        ),

        headers: {

          "Authorization":
          "Bearer $token",
        },
      );

      final data =
      jsonDecode(response.body);

      print(data);

      if (data["status"] == true) {

        setState(() {

          followingList = data["data"];
        });
      }

    } catch (e) {

      print(e);
    }

    setState(() {

      loadingFollowing = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        backgroundColor: Colors.black,

        elevation: 0,

        title: const Text(

          "Connections",

          style: TextStyle(
            color: Colors.white,
          ),
        ),

        bottom: TabBar(

          controller: tabController,

          indicatorColor: Colors.white,

          labelColor: Colors.white,

          unselectedLabelColor: Colors.grey,

          tabs: [

            Tab(
              text:
              "Followers (${followersList.length})",
            ),

            Tab(
              text:
              "Following (${followingList.length})",
            ),
          ],
        ),
      ),

      body: TabBarView(

        controller: tabController,

        children: [

          /// 🔥 FOLLOWERS TAB
          loadingFollowers

              ? const Center(

            child:
            CircularProgressIndicator(),
          )

              : followersList.isEmpty

              ? const Center(

            child: Text(

              "No Followers",

              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )

              : ListView.builder(

            itemCount:
            followersList.length,

            itemBuilder:
                (context, index) {

              final item =
              followersList[index];

              return userCard(item);
            },
          ),

          /// 🔥 FOLLOWING TAB
          loadingFollowing

              ? const Center(

            child:
            CircularProgressIndicator(),
          )

              : followingList.isEmpty

              ? const Center(

            child: Text(

              "No Following",

              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )

              : ListView.builder(

            itemCount:
            followingList.length,

            itemBuilder:
                (context, index) {

              final item =
              followingList[index];

              return userCard(item);
            },
          ),
        ],
      ),
    );
  }

  /// 🔥 USER CARD
  Widget userCard(dynamic item) {

    String imageUrl = "";

    if (item["profile_image"] != null &&
        item["profile_image"]
            .toString()
            .isNotEmpty) {

      imageUrl =
      "https://beach.adpedia.in/uploads/profile_images/${item["profile_image"]}";
    }

    return Container(

      padding:
      const EdgeInsets.symmetric(

        horizontal: 15,

        vertical: 12,
      ),

      child: Row(

        children: [

          /// 🔥 PROFILE IMAGE
          CircleAvatar(

            radius: 28,

            backgroundColor:
            Colors.grey.shade800,

            backgroundImage:
            imageUrl.isNotEmpty

                ? NetworkImage(imageUrl)

                : null,

            child: imageUrl.isEmpty

                ? const Icon(

              Icons.person,

              color: Colors.white,
            )

                : null,
          ),

          const SizedBox(width: 15),

          /// 🔥 USER INFO
          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(

                  item["name"] ?? "",

                  style: const TextStyle(

                    color: Colors.white,

                    fontSize: 15,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 3),

                Text(

                  "@${item["username"]}",

                  style: const TextStyle(

                    color: Colors.grey,

                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          /// 🔥 BUTTON
          Container(

            padding:
            const EdgeInsets.symmetric(

              horizontal: 18,

              vertical: 8,
            ),

            decoration: BoxDecoration(

              color:
              Colors.grey.shade900,

              borderRadius:
              BorderRadius.circular(8),
            ),

            child: const Text(

              "View",

              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}