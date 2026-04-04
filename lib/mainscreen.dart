import 'package:flutter/material.dart';




class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<String> categories = const [
    "World",
    "Country",
    "State",
    "Following",
    "You"
  ];

  final List<String> tabs = const [
    "All",
    "Photos",
    "Reels",
    "Stories",
    "Live"
  ];

  final List<String> images = const [
    "https://picsum.photos/300/400?1",
    "https://picsum.photos/300/400?2",
    "https://picsum.photos/300/400?3",
    "https://picsum.photos/300/400?4",
    "https://picsum.photos/300/400?5",
    "https://picsum.photos/300/400?6",
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: Colors.black,

        // 🔹 APP BAR
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: const Icon(Icons.notifications_none),
          centerTitle: true,
          title: const Text(
            "Beach",
            style: TextStyle(fontFamily: "cursive"),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(Icons.chat_bubble_outline),
            )
          ],
        ),

        body: Column(
          children: [

            // 🔹 CATEGORY SCROLL
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              "https://picsum.photos/100?${index + 1}"),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          categories[index],
                          style: const TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),

            // 🔹 TABS
            TabBar(
              isScrollable: true,
              indicatorColor: Colors.white,
              tabs: tabs.map((t) => Tab(text: t)).toList(),
            ),

            // 🔹 GRID VIEW
            Expanded(
              child: TabBarView(
                children: tabs.map((tab) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(5),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(images[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          // 🔹 Likes & Views
                          Positioned(
                            bottom: 5,
                            left: 5,
                            child: Row(
                              children: const [
                                Icon(Icons.visibility,
                                    color: Colors.white, size: 14),
                                SizedBox(width: 3),
                                Text("12.4K",
                                    style: TextStyle(color: Colors.white)),
                                SizedBox(width: 8),
                                Icon(Icons.favorite,
                                    color: Colors.white, size: 14),
                                SizedBox(width: 3),
                                Text("6.4K",
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),

        // 🔹 BOTTOM NAV BAR
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.filter_list), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
          ],
        ),
      ),
    );
  }
}