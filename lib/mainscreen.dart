import 'package:beach_app/filter.dart';
import 'package:beach_app/notificationlist.dart';
import 'package:beach_app/profile.dart';
import 'package:beach_app/search.dart';
import 'package:beach_app/utilities/Utils.dart';
import 'package:beach_app/utilities/native_storage.dart';
import 'package:beach_app/utilities/videoitem.dart';
import 'package:beach_app/utilities/videoplayer.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
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


   List<Story> futureStories=[];

  List<MediaModel> mediaList = [];
  List<MediaModel> filteredList = [];
  bool loading = true;
  final List<String> categories = [
    "World",
    "Country",
    "State",
    "Following",
    "You"
  ];

  final List<String> tabs = [
    "All",
    "Photos",
    "Reels",
    "Stories",
    "Trending"
  ];

  final List<String> images = [
    "https://picsum.photos/300/400?1",
    "https://picsum.photos/300/400?2",
    "https://picsum.photos/300/400?3",
    "https://picsum.photos/300/400?4",
    "https://picsum.photos/300/400?5",
    "https://picsum.photos/300/400?6",
    "https://picsum.photos/300/400?7",
    "https://picsum.photos/300/400?8",
    "https://picsum.photos/300/400?9",
    "https://picsum.photos/300/400?10",
    "https://picsum.photos/300/400?11",
    "https://picsum.photos/300/400?12",
  ];

  void onBottomNavTap(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchStories();
    fetchFeeds();

  }

  Future<void> fetchFeeds() async {
    try {

      String? v=await NativeStorage.getValue(Utils.token);


      final response = await http.get(
        Uri.parse("https://beach.adpedia.in/api/media/feeds/all?page=1&limit=10"),
        headers: {"Authorization":"Bearer "+v!}
      );

      final jsonData = jsonDecode(response.body);

      if (jsonData["status"] == 1) {
        List data = jsonData["data"];

        setState(() {

          mediaList = data.map((e) => MediaModel.fromJson(e)).toList();

          filteredList = mediaList; // default ALL

        });

        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: Colors.black,

        /// 🔹 APP BAR
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(onPressed: (){

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NotificationScreen(

                ),
              ),
            );


          }, icon:



          Icon(Icons.notifications_none,
              color: Colors.white, size: 25)),
          centerTitle: true,
          title: const Text(
            "Beach",
            style: TextStyle(
              fontFamily: "cursive",
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FilterScreen()),
                  );
                },
              ),
            )
          ],
        ),

        /// 🔹 BODY
        body: Column(
          children: [

            /// 🔹 CATEGORY SCROLL
            SizedBox(
              height: 100,
              child: (futureStories.length>0)? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: futureStories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                        if  (futureStories[index].image!=null) CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                                futureStories[index].image.toString()),
                          ),

                        if(futureStories[index].video!=null)    SizedBox(
                    height: 200,
                    child: VideoPlayerWidget(
                        url: futureStories[index].video!),
                  ),




                          const SizedBox(height: 5),
                          Text(
                            futureStories[index].title.toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) =>
                            CountryBottomSheet(),
                      );
                    },
                  );
                },
              ) : Align(
                alignment: FractionalOffset.center,
                child: Text("No stories found",style: TextStyle(fontSize: 14,color: Colors.white),),
              ),
            ),

            /// 🔹 TABS
            TabBar(
              isScrollable: true,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: tabs.map((t) => Tab(text: t)).toList(),
              onTap: (index) {
                filterMedia(index);
              },
            ),

            /// 🔹 GRID VIEW
            Expanded(
              child: loading

                  ? const Center(
                child: CircularProgressIndicator(),
              )

                  : GridView.builder(

                padding: const EdgeInsets.all(5),

                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(

                  crossAxisCount: 3,

                  crossAxisSpacing: 5,

                  mainAxisSpacing: 5,

                  childAspectRatio: 0.7,
                ),

                itemCount: filteredList.length,

                itemBuilder: (context, index) {

                  final item = filteredList[index];

                  return GestureDetector(

                    child: Stack(

                      children: [

                        /// 🔹 VIDEO
                        item.type == "video"

                            ? VideoItem(
                          videoUrl: item.url,
                        )

                            :

                        /// 🔹 IMAGE
                        Container(

                          decoration: BoxDecoration(

                            image: DecorationImage(

                              image: NetworkImage(item.url),

                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        /// 🔹 PLAY ICON
                        // if (item.type == "video")
                        //
                        //   const Center(
                        //
                        //     child: Icon(
                        //
                        //       Icons.play_circle_fill,
                        //
                        //       color: Colors.white,
                        //
                        //       size: 40,
                        //     ),
                        //   ),

                        /// 🔹 VIEWS
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

                              const Text(

                                "12.4K",

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

                    onTap: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (context) => FeedScreen(),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),

        /// 🔹 BOTTOM NAV
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onBottomNavTap,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Image.asset("assets/home.png",
                    width: 16, height: 16),
                label: ""),
            BottomNavigationBarItem(icon: GestureDetector(

              child:Image.asset("assets/search.png",width: 16,height: 16,fit: BoxFit.fill,)  ,
              onTap: (){

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
              },
            )


                , label: ""),
            BottomNavigationBarItem(icon: GestureDetector(

              child: Image.asset("assets/plus.png",width: 16,height: 16,fit: BoxFit.fill,),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreatePostScreen()),
                );

              },
            )


                , label: ""),



            BottomNavigationBarItem(icon: GestureDetector(

              child: Image.asset("assets/chat.png",width: 16,height: 16,fit: BoxFit.fill,),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatListScreen()),
                );

              },
            )



                , label: ""),



            BottomNavigationBarItem(icon: GestureDetector(

              child: Image.asset("assets/user.png",width: 16,height: 16,fit: BoxFit.fill,) ,
              onTap: (){

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),label: "")
          ],
        ),
      ),
    );
  }

  void filterMedia(int index) {
    if (index == 0) {
      filteredList = mediaList; // ALL
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


  fetchStories() async {

    String? v=await NativeStorage.getValue(Utils.token);
    final url = Uri.parse(
        "https://beach.adpedia.in/api/stories-list?page=1&limit=10");

    final response = await http.get(url,

        headers: {"Authorization":"Bearer "+v!}


    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      final res = StoriesResponse.fromJson(jsonData);

      if(res.status)
        {

          setState(() {
            futureStories.clear();
            futureStories.addAll(res.data);
          });
        }

    } else {
      throw Exception("Failed to load stories");
    }
  }
}