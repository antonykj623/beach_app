/// =============================
/// CHAT LIST SCREEN
/// =============================

import 'dart:convert';

import 'package:beach_app/utilities/Utils.dart';
import 'package:beach_app/utilities/native_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'chatmessage.dart';



class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() =>
      _ChatListScreenState();
}

class _ChatListScreenState
    extends State<ChatListScreen> {

  List chatList = [];

  bool loading = true;

  int page = 1;

  bool hasNext = true;

  bool paginationLoading = false;

  final ScrollController scrollController =
  ScrollController();

  /// 🔥 TOKEN
  String token = "";

  @override
  void initState() {

    super.initState();

    getChatList();

    scrollController.addListener(() {

      if (scrollController.position.pixels >=
          scrollController
              .position.maxScrollExtent - 200 &&
          !paginationLoading &&
          hasNext) {

        page++;

        getChatList();
      }
    });
  }

  /// 🔥 GET CHAT LIST
  Future<void> getChatList() async {
    String? v=await NativeStorage.getValue(Utils.token);

    token=v.toString();
    try {

      if (page == 1) {

        setState(() {

          loading = true;
        });

      } else {

        setState(() {

          paginationLoading = true;
        });
      }

      final response = await http.get(

        Uri.parse(
          "https://beach.adpedia.in/api/chat-list?page=$page&limit=10",
        ),

        headers: {

          "Authorization":
          "Bearer $token",
        },
      );

      final data =
      jsonDecode(response.body);

      print(data);

      if (data["Status"] == true) {

        setState(() {

          chatList.addAll(data["Data"]);

          hasNext =
          data["Pagination"]["has_next"];
        });
      }

    } catch (e) {

      print(e);
    }

    setState(() {

      loading = false;

      paginationLoading = false;
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

          "Messages",

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: loading

          ? const Center(
        child:
        CircularProgressIndicator(),
      )

          : chatList.isEmpty

          ? const Center(

        child: Text(

          "No Chats Found",

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      )

          : ListView.builder(

        controller: scrollController,

        itemCount:
        chatList.length +
            (paginationLoading ? 1 : 0),

        itemBuilder:
            (context, index) {

          if (index == chatList.length) {

            return const Padding(

              padding:
              EdgeInsets.all(15),

              child: Center(

                child:
                CircularProgressIndicator(),
              ),
            );
          }

          final item =
          chatList[index];

          String image = "";

          if (item["profile_image"] !=
              null) {

            image =
            "https://beach.adpedia.in/uploads/profile_images/${item["profile_image"]}";
          }

          return GestureDetector(

            onTap: () {

              Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (context) =>
                      ChatMessageScreen(

                        conversationId:
                        item[
                        "conversation_id"],

                        userName:
                        item["name"],

                        profileImage:
                        image,
                      ),
                ),
              );
            },

            child: Container(

              padding:
              const EdgeInsets.symmetric(

                horizontal: 15,

                vertical: 12,
              ),

              child: Row(

                children: [

                  /// 🔥 PROFILE
                  CircleAvatar(

                    radius: 28,

                    backgroundColor:
                    Colors.grey
                        .shade800,

                    backgroundImage:
                    image.isNotEmpty

                        ? NetworkImage(
                        image)

                        : null,

                    child:
                    image.isEmpty

                        ? const Icon(

                      Icons.person,

                      color:
                      Colors
                          .white,
                    )

                        : null,
                  ),

                  const SizedBox(
                      width: 15),

                  /// 🔥 DETAILS
                  Expanded(

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        Text(

                          item["name"],

                          style:
                          const TextStyle(

                            color: Colors
                                .white,

                            fontSize: 15,

                            fontWeight:
                            FontWeight
                                .bold,
                          ),
                        ),

                        const SizedBox(
                            height: 5),

                        Row(

                          children: [

                            Expanded(

                              child: Text(

                                item["last_message"] ??
                                    "",

                                maxLines: 1,

                                overflow:
                                TextOverflow
                                    .ellipsis,

                                style:
                                TextStyle(

                                  color: item[
                                  "unread_count"] >
                                      0

                                      ? Colors
                                      .white

                                      : Colors
                                      .grey,

                                  fontWeight: item[
                                  "unread_count"] >
                                      0

                                      ? FontWeight
                                      .bold

                                      : FontWeight
                                      .normal,
                                ),
                              ),
                            ),

                            if (item[
                            "unread_count"] >
                                0)

                              Container(

                                margin:
                                const EdgeInsets.only(
                                  left: 10,
                                ),

                                padding:
                                const EdgeInsets.all(
                                    7),

                                decoration:
                                const BoxDecoration(

                                  color:
                                  Colors.blue,

                                  shape:
                                  BoxShape.circle,
                                ),

                                child: Text(

                                  item[
                                  "unread_count"]
                                      .toString(),

                                  style:
                                  const TextStyle(

                                    color: Colors
                                        .white,

                                    fontSize:
                                    11,
                                  ),
                                ),
                              )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}