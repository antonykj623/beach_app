import 'dart:convert';

import 'package:beach_app/profile.dart';
import 'package:beach_app/utilities/Utils.dart';
import 'package:beach_app/utilities/native_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {

  /// 🔥 FEED LIST
  List feeds = [];

  /// 🔥 LOADING
  bool loading = true;

  /// 🔥 PAGINATION LOADING
  bool paginationLoading = false;

  /// 🔥 CURRENT PAGE
  int page = 1;

  /// 🔥 LIMIT
  int limit = 10;

  /// 🔥 HAS NEXT PAGE
  bool hasNext = true;

  /// 🔥 BOTTOM NAV INDEX
  int selectedIndex = 0;

  /// 🔥 SCROLL CONTROLLER
  final ScrollController scrollController =
  ScrollController();

  @override
  void initState() {

    super.initState();

    getFeeds();

    /// 🔥 PAGINATION LISTENER
    scrollController.addListener(() {

      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {

        if (!paginationLoading &&
            hasNext &&
            !loading) {

          getFeeds();
        }
      }
    });
  }

  /// 🔥 API CALL
  Future<void> getFeeds() async {
    String? v=await NativeStorage.getValue(Utils.token);


    try {

      if (page == 1) {

        loading = true;

        setState(() {});
      } else {


        paginationLoading = true;

        setState(() {});
      }

      final response = await http.get(

        Uri.parse(
          "https://beach.adpedia.in/api/media/feeds/all?page=$page&limit=$limit",
        ),
        headers: {"Authorization":"Bearer "+v!}
      );

      final data = jsonDecode(response.body);

      if (data["status"] == 1) {

        List newData = data["data"];

        setState(() {

          feeds.addAll(newData);

          hasNext =
          data["Pagination"]["has_next"];

          page++;

          loading = false;

          paginationLoading = false;
        });
      } else {

        setState(() {

          loading = false;

          paginationLoading = false;
        });
      }

    } catch (e) {

      print(e);

      setState(() {

        loading = false;

        paginationLoading = false;
      });
    }
  }

  @override
  void dispose() {

    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      /// 🔻 BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(

        currentIndex: selectedIndex,

        onTap: (index) {

          setState(() {

            selectedIndex = index;
          });

          /// 🔥 PROFILE PAGE
          if (index == 4) {

            Navigator.push(

              context,

              MaterialPageRoute(

                builder: (context) =>
                    ProfileScreen(),
              ),
            );
          }
        },

        backgroundColor: Colors.black,

        selectedItemColor: Colors.white,

        unselectedItemColor: Colors.grey,

        type: BottomNavigationBarType.fixed,

        items: [

          BottomNavigationBarItem(

            icon: Image.asset(

              "assets/home.png",

              width: 18,

              height: 18,
            ),

            label: "",
          ),

          BottomNavigationBarItem(

            icon: Image.asset(

              "assets/search.png",

              width: 18,

              height: 18,
            ),

            label: "",
          ),

          BottomNavigationBarItem(

            icon: Image.asset(

              "assets/plus.png",

              width: 18,

              height: 18,
            ),

            label: "",
          ),

          BottomNavigationBarItem(

            icon: Image.asset(

              "assets/chat.png",

              width: 18,

              height: 18,
            ),

            label: "",
          ),

          BottomNavigationBarItem(

            icon: Image.asset(

              "assets/user.png",

              width: 18,

              height: 18,
            ),

            label: "",
          ),
        ],
      ),

      /// 🔥 BODY
      body: SafeArea(

        child: loading

            ? const Center(
          child: CircularProgressIndicator(),
        )

            : ListView.builder(

          controller: scrollController,

          itemCount:
          feeds.length +
              (paginationLoading ? 1 : 0),

          itemBuilder: (context, index) {

            /// 🔥 PAGINATION LOADER
            if (index == feeds.length) {

              return const Padding(

                padding: EdgeInsets.all(20),

                child: Center(

                  child:
                  CircularProgressIndicator(),
                ),
              );
            }

            final post = feeds[index];

            String mediaUrl =
            post["media_url"];

            /// 🔥 FIX LOCALHOST URL
            mediaUrl = mediaUrl.replaceAll(
              "http://localhost:3000",
              "https://beach.adpedia.in",
            );

            return Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                /// 🔝 HEADER
                ListTile(

                  leading: CircleAvatar(

                    backgroundImage:
                    NetworkImage(
                      "https://randomuser.me/api/portraits/men/${(index % 10) + 1}.jpg",
                    ),
                  ),

                  title: const Text(

                    "Beach User",

                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: const Text(

                    "Beach Media",

                    style: TextStyle(

                      color: Colors.grey,

                      fontSize: 12,
                    ),
                  ),

                  trailing: const Icon(

                    Icons.more_vert,

                    color: Colors.white,
                  ),
                ),

                /// 🔥 IMAGE / VIDEO
                post["type"] == "image"

                    ? Image.network(

                  mediaUrl,

                  width: double.infinity,

                  height: 320,

                  fit: BoxFit.cover,

                  errorBuilder:
                      (context, error, stackTrace) {

                    return Container(

                      height: 320,

                      color: Colors.grey.shade900,

                      child: const Center(

                        child: Icon(

                          Icons.image,

                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                )

                    : VideoWidget(
                  videoUrl: mediaUrl,
                ),

                /// ❤️ ACTIONS
                Padding(

                  padding:
                  const EdgeInsets.symmetric(

                    horizontal: 10,

                    vertical: 8,
                  ),

                  child: Row(

                    children: [

                      const Icon(

                        Icons.favorite_border,

                        color: Colors.white,
                      ),

                      const SizedBox(width: 15),

                      Image.asset(

                        "assets/chat.png",

                        width: 18,

                        height: 18,
                      ),

                      const SizedBox(width: 15),

                      Image.asset(

                        "assets/send.png",

                        width: 18,

                        height: 18,
                      ),

                      const Spacer(),

                      const Icon(

                        Icons.bookmark_border,

                        color: Colors.white,
                      ),
                    ],
                  ),
                ),

                /// 📝 CAPTION
                const Padding(

                  padding:
                  EdgeInsets.symmetric(
                    horizontal: 10,
                  ),

                  child: Text(

                    "Beach Media Feed",

                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),

                /// ⏱ DATE
                Padding(

                  padding:
                  const EdgeInsets.symmetric(

                    horizontal: 10,

                    vertical: 5,
                  ),

                  child: Text(

                    post["created_date"],

                    style: const TextStyle(

                      color: Colors.grey,

                      fontSize: 12,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// 🔥 VIDEO PLAYER
class VideoWidget extends StatefulWidget {

  final String videoUrl;

  const VideoWidget({
    super.key,
    required this.videoUrl,
  });

  @override
  State<VideoWidget> createState() =>
      _VideoWidgetState();
}

class _VideoWidgetState
    extends State<VideoWidget> {

  late VideoPlayerController controller;

  bool initialized = false;

  bool error = false;

  @override
  void initState() {

    super.initState();

    controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    )

      ..initialize().then((_) {

        if (mounted) {

          setState(() {

            initialized = true;
          });

          controller.setLooping(true);

          controller.setVolume(0);

          controller.play();
        }

      }).catchError((e) {

        print(e);

        setState(() {

          error = true;
        });
      });
  }

  @override
  void dispose() {

    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (error) {

      return Container(

        height: 320,

        color: Colors.black,

        child: const Center(

          child: Icon(

            Icons.error,

            color: Colors.white,
          ),
        ),
      );
    }

    if (!initialized) {

      return Container(

        height: 320,

        color: Colors.black12,

        child: const Center(

          child: CircularProgressIndicator(),
        ),
      );
    }

    return SizedBox(

      width: double.infinity,

      height: 320,

      child: FittedBox(

        fit: BoxFit.cover,

        child: SizedBox(

          width: controller.value.size.width,

          height: controller.value.size.height,

          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}