import 'dart:convert';

import 'package:beach_app/filter.dart';
import 'package:beach_app/notificationlist.dart';
import 'package:beach_app/profile.dart';
import 'package:beach_app/search.dart';
import 'package:beach_app/utilities/Utils.dart';
import 'package:beach_app/utilities/native_storage.dart';
import 'package:beach_app/utilities/videoitem.dart';
import 'package:beach_app/utilities/videoplayer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'chatlist.dart';
import 'countrybottom.dart';
import 'create_post.dart';
import 'feedscreen.dart';
import 'models/MediaFeed.dart';
import 'models/Stories.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  Map<int, int> postViews = {};
  /// STORIES
  List<Story> futureStories = [];

  /// FEEDS
  List<MediaModel> mediaList = [];
  List<MediaModel> filteredList = [];

  bool loading = true;

  /// PAGINATION VARIABLES
  int feedPage = 1;
  bool feedLoadingMore = false;
  bool feedHasMore = true;

  int storyPage = 1;
  bool storyLoadingMore = false;
  bool storyHasMore = true;

  /// SCROLL CONTROLLERS
  final ScrollController feedScrollController = ScrollController();
  final ScrollController storyScrollController = ScrollController();

  final List<String> tabs = [
    "All",
    "Photos",
    "Reels",
    "Stories",
    "Trending"
  ];

  @override
  void initState() {
    super.initState();

    fetchStories();
    fetchFeeds();

    /// FEED PAGINATION
    feedScrollController.addListener(() {
      if (feedScrollController.position.pixels >=
          feedScrollController.position.maxScrollExtent - 200 &&
          !feedLoadingMore &&
          feedHasMore) {
        fetchFeeds(loadMore: true);
      }
    });

    /// STORIES PAGINATION
    storyScrollController.addListener(() {
      if (storyScrollController.position.pixels >=
          storyScrollController.position.maxScrollExtent - 100 &&
          !storyLoadingMore &&
          storyHasMore) {
        fetchStories(loadMore: true);
      }
    });
  }

  Future<void> loadViewCount(int postId) async {
    try {
      String? token = await NativeStorage.getValue(Utils.token);

      final response = await http.post(
        Uri.parse(
            "https://beach.adpedia.in/api/posts/$postId/view"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData["status"] == true) {
          setState(() {
            postViews[postId] = jsonData["view_count"] ?? 0;
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    feedScrollController.dispose();
    storyScrollController.dispose();
    super.dispose();
  }

  /// =========================
  /// FETCH FEEDS WITH PAGINATION
  /// =========================
  Future<void> fetchFeeds({bool loadMore = false}) async {
    try {
      if (loadMore) {
        feedLoadingMore = true;
      } else {
        loading = true;
      }

      setState(() {});

      String? token = await NativeStorage.getValue(Utils.token);

      final response = await http.get(
        Uri.parse(
            "https://beach.adpedia.in/api/media/feeds/all?page=$feedPage&limit=10"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      final jsonData = jsonDecode(response.body);

      if (jsonData["status"] == 1) {
        List data = jsonData["data"];

        List<MediaModel> newItems =
        data.map((e) => MediaModel.fromJson(e)).toList();
        for (var item in newItems) {
          loadViewCount(item.id!);
        }

        setState(() {
          if (loadMore) {
            mediaList.addAll(newItems);
          } else {
            mediaList = newItems;
          }

          filteredList = mediaList;

          if (newItems.length < 10) {
            feedHasMore = false;
          } else {
            feedPage++;
          }
        });
      }

      loading = false;
      feedLoadingMore = false;

      setState(() {});
    } catch (e) {
      print(e);

      loading = false;
      feedLoadingMore = false;

      setState(() {});
    }
  }

  /// =========================
  /// FETCH STORIES WITH PAGINATION
  /// =========================
  Future<void> fetchStories({bool loadMore = false}) async {
    try {
      if (loadMore) {
        storyLoadingMore = true;
      }

      setState(() {});

      String? token = await NativeStorage.getValue(Utils.token);

      final response = await http.get(
        Uri.parse(
            "https://beach.adpedia.in/api/stories-list?page=$storyPage&limit=10"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        final res = StoriesResponse.fromJson(jsonData);

        if (res.status) {
          setState(() {
            if (loadMore) {
              futureStories.addAll(res.data);
            } else {
              futureStories = res.data;
            }

            if (res.data.length < 10) {
              storyHasMore = false;
            } else {
              storyPage++;
            }
          });
        }
      }

      storyLoadingMore = false;

      setState(() {});
    } catch (e) {
      print(e);

      storyLoadingMore = false;

      setState(() {});
    }
  }

  /// =========================
  /// FILTER MEDIA
  /// =========================
  void filterMedia(int index) {
    if (index == 0) {
      filteredList = mediaList;
    } else if (index == 1) {
      filteredList =
          mediaList.where((e) => e.type == "image").toList();
    } else if (index == 2) {
      filteredList =
          mediaList.where((e) => e.type == "video").toList();
    } else {
      filteredList = mediaList;
    }

    setState(() {});
  }

  void onBottomNavTap(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: Colors.black,

        /// APP BAR
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NotificationScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          title: const Text(
            "Beach",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: GestureDetector(
                child: Image.asset(
                  "assets/filter.png",
                  width: 16,
                  height: 16,
                ),
                onTap: () async {



                  {

                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FilterScreen()),
                    );

                    if (result != null||result==null) {

                      fetchStories();
                      fetchFeeds();


                    }





                  }










                },
              ),
            )
          ],
        ),

        /// BODY
        body: Column(
          children: [
            /// STORIES
            SizedBox(
              height: 100,
              child: futureStories.isNotEmpty
                  ? ListView.builder(
                controller: storyScrollController,
                scrollDirection: Axis.horizontal,
                itemCount: futureStories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) =>
                            CountryBottomSheet(),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10),
                      child: Column(
                        children: [
                          if (futureStories[index].image != null)
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                futureStories[index]
                                    .image
                                    .toString(),
                              ),
                            ),

                          if (futureStories[index].video != null)
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: VideoPlayerWidget(
                                url: futureStories[index]
                                    .video!,
                              ),
                            ),

                          const SizedBox(height: 5),

                          Text(
                            futureStories[index]
                                .title
                                .toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              )
                  : const Center(
                child: Text(
                  "No stories found",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            /// TAB BAR
            TabBar(
              isScrollable: true,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: tabs.map((e) => Tab(text: e)).toList(),
              onTap: filterMedia,
            ),

            /// GRID
            Expanded(
              child: loading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : GridView.builder(
                controller: feedScrollController,
                padding: const EdgeInsets.all(5),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 0.7,
                ),
                itemCount: filteredList.length +
                    (feedLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == filteredList.length) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final item = filteredList[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FeedScreen(),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        item.type == "video"
                            ? VideoItem(
                          videoUrl: item.url,
                        )
                            : Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                              NetworkImage(item.url),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: 5,
                          left: 5,
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/eye.png",
                                width: 15,
                                height: 15,
                              ),
                              const SizedBox(width: 3),
                               Text(
                                 "${postViews[item.id] ?? 0}"  ,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),

        /// BOTTOM NAVIGATION
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onBottomNavTap,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/home.png",
                width: 16,
                height: 16,
              ),
              label: "",
            ),

            BottomNavigationBarItem(
              icon: GestureDetector(
                child: Image.asset(
                  "assets/search.png",
                  width: 16,
                  height: 16,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SearchScreen(),
                    ),
                  );
                },
              ),
              label: "",
            ),

            BottomNavigationBarItem(
              icon: GestureDetector(
                child: Image.asset(
                  "assets/plus.png",
                  width: 16,
                  height: 16,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreatePostScreen(),
                    ),
                  );
                },
              ),
              label: "",
            ),

            BottomNavigationBarItem(
              icon: GestureDetector(
                child: Image.asset(
                  "assets/chat.png",
                  width: 16,
                  height: 16,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatListScreen(),
                    ),
                  );
                },
              ),
              label: "",
            ),

            BottomNavigationBarItem(
              icon: GestureDetector(
                child: Image.asset(
                  "assets/user.png",
                  width: 16,
                  height: 16,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfileScreen(),
                    ),
                  );
                },
              ),
              label: "",
            ),
          ],
        ),
      ),
    );
  }
}