import 'dart:convert';

import 'package:beach_app/utilities/Utils.dart';
import 'package:beach_app/utilities/native_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatMessageScreen
    extends StatefulWidget {

  final int conversationId;

  final String userName;

  final String profileImage;

  const ChatMessageScreen({

    super.key,

    required this.conversationId,

    required this.userName,

    required this.profileImage,
  });

  @override
  State<ChatMessageScreen> createState() =>
      _ChatMessageScreenState();
}

class _ChatMessageScreenState
    extends State<ChatMessageScreen> {

  List messageList = [];

  bool loading = true;

  int page = 1;

  bool hasNext = true;

  bool paginationLoading = false;

  final ScrollController scrollController =
  ScrollController();

  final TextEditingController
  messageController =
  TextEditingController();

  /// 🔥 CURRENT USER ID
  int currentUserId = 12;

  /// 🔥 TOKEN
  String token = "YOUR_TOKEN";

  @override
  void initState() {

    super.initState();

    getMessages();

    scrollController.addListener(() {

      if (scrollController.position.pixels >=
          scrollController
              .position.maxScrollExtent - 200 &&
          !paginationLoading &&
          hasNext) {

        page++;

        getMessages();
      }
    });
  }

  /// 🔥 GET MESSAGES
  Future<void> getMessages() async {

    try {
      String? v=await NativeStorage.getValue(Utils.token);

      token=v.toString();
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

          "https://beach.adpedia.in/api/chat-history?conversation_id=${widget.conversationId}&page=$page&limit=10",
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

          messageList.addAll(data["Data"]);

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

  /// 🔥 SEND MESSAGE UI ONLY
  void sendMessage() {

    if (messageController.text.trim().isEmpty) {
      return;
    }

    setState(() {

      messageList.insert(0, {

        "user_id": currentUserId,

        "chat_message":
        messageController.text,

        "chat_type": "text",
      });
    });

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        backgroundColor: Colors.black,

        elevation: 0,

        titleSpacing: 0,

        title: Row(

          children: [

            CircleAvatar(

              radius: 18,

              backgroundColor:
              Colors.grey.shade800,

              backgroundImage:
              widget.profileImage
                  .isNotEmpty

                  ? NetworkImage(
                  widget.profileImage)

                  : null,

              child:
              widget.profileImage.isEmpty

                  ? const Icon(

                Icons.person,

                color:
                Colors.white,
              )

                  : null,
            ),

            const SizedBox(width: 10),

            Text(

              widget.userName,

              style: const TextStyle(

                color: Colors.white,

                fontSize: 16,
              ),
            )
          ],
        ),
      ),

      body: Column(

        children: [

          /// 🔥 MESSAGE LIST
          Expanded(

            child: loading

                ? const Center(

              child:
              CircularProgressIndicator(),
            )

                : ListView.builder(

              reverse: true,

              controller:
              scrollController,

              padding:
              const EdgeInsets.all(
                  15),

              itemCount:
              messageList.length,

              itemBuilder:
                  (context, index) {

                final item =
                messageList[index];

                bool isMe =
                    item["user_id"] ==
                        currentUserId;

                return Align(

                  alignment: isMe

                      ? Alignment
                      .centerRight

                      : Alignment
                      .centerLeft,

                  child: Container(

                    margin:
                    const EdgeInsets.only(
                      bottom: 12,
                    ),

                    padding:
                    const EdgeInsets.symmetric(

                      horizontal: 15,

                      vertical: 10,
                    ),

                    constraints:
                    BoxConstraints(

                      maxWidth:
                      MediaQuery.of(
                          context)
                          .size
                          .width *
                          .75,
                    ),

                    decoration:
                    BoxDecoration(

                      color: isMe

                          ? Colors.blue

                          : Colors
                          .grey
                          .shade900,

                      borderRadius:
                      BorderRadius.circular(
                          18),
                    ),

                    child: Text(

                      item["chat_message"] ??
                          "",

                      style:
                      const TextStyle(

                        color:
                        Colors.white,

                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          /// 🔥 INPUT
          Container(

            padding:
            const EdgeInsets.symmetric(

              horizontal: 10,

              vertical: 10,
            ),

            color: Colors.black,

            child: Row(

              children: [

                Expanded(

                  child: TextField(

                    controller:
                    messageController,

                    style:
                    const TextStyle(
                      color:
                      Colors.white,
                    ),

                    decoration:
                    InputDecoration(

                      hintText:
                      "Message...",

                      hintStyle:
                      const TextStyle(
                        color:
                        Colors.grey,
                      ),

                      filled: true,

                      fillColor:
                      Colors.grey
                          .shade900,

                      border:
                      OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(
                            30),

                        borderSide:
                        BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                GestureDetector(

                  onTap: () {

                    sendMessage();
                  },

                  child: Container(

                    padding:
                    const EdgeInsets.all(
                        13),

                    decoration:
                    const BoxDecoration(

                      color:
                      Colors.blue,

                      shape:
                      BoxShape.circle,
                    ),

                    child: const Icon(

                      Icons.send,

                      color: Colors.white,

                      size: 20,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}