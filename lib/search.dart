import 'dart:convert';

import 'package:beach_app/utilities/Utils.dart';
import 'package:beach_app/utilities/native_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() =>
      _SearchScreenState();
}

class _SearchScreenState
    extends State<SearchScreen> {

  /// 🔥 SEARCH CONTROLLER
  final TextEditingController searchController =
  TextEditingController();

  /// 🔥 USER LIST
  List users = [];

  /// 🔥 LOADING
  bool loading = false;

  /// 🔥 FOLLOW LOADING INDEX
  int followLoadingIndex = -1;

  /// 🔥 TOKEN
  String token = "";

  @override
  void initState() {

    super.initState();

    /// 🔥 SET YOUR TOKEN HERE
    token = "";
    getToken();
  }

  getToken()async{
    String? v=await NativeStorage.getValue(Utils.token);
    token=v.toString();

  }

  /// 🔥 SEARCH USERS API
  Future<void> searchUsers(String query) async {

    if (query.trim().isEmpty) {

      setState(() {

        users = [];
      });

      return;
    }

    try {

      setState(() {

        loading = true;
      });

      final response = await http.get(

        Uri.parse(
          "https://beach.adpedia.in/api/users/search?q=$query",
        ),

        headers: {

          "Authorization": "Bearer $token",
        },
      );

      final data = jsonDecode(response.body);

      if (data["status"] == true) {

        setState(() {

          users = data["data"];

          /// 🔥 DEFAULT FOLLOW STATUS
          for (var user in users) {

            user["is_following"] ??= false;
          }

          loading = false;
        });
      } else {

        setState(() {

          users = [];

          loading = false;
        });
      }

    } catch (e) {

      print(e);

      setState(() {

        loading = false;
      });
    }
  }

  /// 🔥 FOLLOW USER
  Future<void> followUser(
      int followingId,
      int index,
      ) async {

    try {

      setState(() {

        followLoadingIndex = index;
      });

      final response = await http.post(

        Uri.parse(
          "https://beach.adpedia.in/api/follow-user",
        ),

        headers: {

          "Content-Type": "application/json",

          "Authorization": "Bearer $token",
        },

        body: jsonEncode({

          "following_id": followingId,
        }),
      );

      final data = jsonDecode(response.body);

      if (data["status"] == true) {

        setState(() {

          users[index]["is_following"] = true;
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(
            content:
            Text(data["message"]),
          ),
        );
      }

    } catch (e) {

      print(e);
    }

    setState(() {

      followLoadingIndex = -1;
    });
  }

  /// 🔥 UNFOLLOW USER
  Future<void> unfollowUser(
      int followingId,
      int index,
      ) async {

    try {

      setState(() {

        followLoadingIndex = index;
      });

      final response = await http.post(

        Uri.parse(
          "https://beach.adpedia.in/api/unfollow-user",
        ),

        headers: {

          "Content-Type": "application/json",

          "Authorization": "Bearer $token",
        },

        body: jsonEncode({

          "following_id": followingId,
        }),
      );

      final data = jsonDecode(response.body);

      if (data["status"] == true) {

        setState(() {

          users[index]["is_following"] = false;
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(
            content:
            Text(data["message"]),
          ),
        );
      }

    } catch (e) {

      print(e);
    }

    setState(() {

      followLoadingIndex = -1;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        backgroundColor: Colors.black,

        elevation: 0,

        title: Container(

          height: 45,

          decoration: BoxDecoration(

            color: const Color(0xff1A1A1A),

            borderRadius:
            BorderRadius.circular(12),
          ),

          child: TextField(

            controller: searchController,

            style: const TextStyle(
              color: Colors.white,
            ),

            onChanged: (value) {

              searchUsers(value);
            },

            decoration: InputDecoration(

              hintText: "Search users",

              hintStyle: TextStyle(
                color: Colors.grey.shade500,
              ),

              prefixIcon: const Icon(

                Icons.search,

                color: Colors.grey,
              ),

              border: InputBorder.none,

              contentPadding:
              const EdgeInsets.only(top: 12),
            ),
          ),
        ),
      ),

      body: loading

          ? const Center(
        child: CircularProgressIndicator(),
      )

          : users.isEmpty

          ? Center(

        child: Column(

          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            Icon(

              Icons.search,

              color: Colors.grey.shade700,

              size: 70,
            ),

            const SizedBox(height: 15),

            Text(

              "Search users",

              style: TextStyle(

                color:
                Colors.grey.shade500,

                fontSize: 18,
              ),
            ),
          ],
        ),
      )

          : ListView.builder(

        itemCount: users.length,

        itemBuilder: (context, index) {

          final user = users[index];

          bool isFollowing =
              user["is_following"] ??
                  false;

          return Container(

            margin:
            const EdgeInsets.symmetric(

              horizontal: 12,

              vertical: 8,
            ),

            child: Row(

              children: [

                /// 🔥 PROFILE IMAGE
                CircleAvatar(

                  radius: 28,

                  backgroundColor:
                  Colors.grey.shade800,

                  backgroundImage:

                  user["profile_image"] !=
                      null

                      ? NetworkImage(
                    user["profile_image"],
                  )

                      : null,

                  child:
                  user["profile_image"] ==
                      null

                      ? const Icon(

                    Icons.person,

                    color:
                    Colors.white,
                  )

                      : null,
                ),

                const SizedBox(width: 12),

                /// 🔥 USER DETAILS
                Expanded(

                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                    children: [

                      /// USERNAME
                      Text(

                        user["username"],

                        style:
                        const TextStyle(

                          color:
                          Colors.white,

                          fontWeight:
                          FontWeight.bold,

                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 3),

                      /// NAME
                      Text(

                        user["name"],

                        style:
                        TextStyle(

                          color:
                          Colors.grey
                              .shade400,

                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 5),

                      /// FOLLOWERS
                      Row(

                        children: [

                          Text(

                            "${user["followers_count"]} followers",

                            style:
                            TextStyle(

                              color:
                              Colors.grey
                                  .shade500,

                              fontSize:
                              12,
                            ),
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          Text(

                            "${user["posts_count"]} posts",

                            style:
                            TextStyle(

                              color:
                              Colors.grey
                                  .shade500,

                              fontSize:
                              12,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                /// 🔥 FOLLOW BUTTON
                GestureDetector(

                  onTap: () {

                    if (followLoadingIndex ==
                        index) {
                      return;
                    }

                    if (isFollowing) {

                      unfollowUser(
                        user["id"],
                        index,
                      );

                    } else {

                      followUser(
                        user["id"],
                        index,
                      );
                    }
                  },

                  child: Container(

                    width: 100,

                    height: 38,

                    decoration:
                    BoxDecoration(

                      color: isFollowing

                          ? Colors
                          .grey.shade900

                          : Colors
                          .blueAccent,

                      borderRadius:
                      BorderRadius
                          .circular(8),

                      border: Border.all(

                        color: isFollowing

                            ? Colors.grey

                            : Colors
                            .blueAccent,
                      ),
                    ),

                    child: Center(

                      child:
                      followLoadingIndex ==
                          index

                          ? const SizedBox(

                        width: 18,

                        height: 18,

                        child:
                        CircularProgressIndicator(

                          color:
                          Colors
                              .white,

                          strokeWidth:
                          2,
                        ),
                      )

                          : Text(

                        isFollowing

                            ? "Following"

                            : "Follow",

                        style:
                        const TextStyle(

                          color:
                          Colors
                              .white,

                          fontWeight:
                          FontWeight
                              .bold,
                        ),
                      ),
                    ),
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