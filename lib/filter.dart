import 'dart:convert';

import 'package:beach_app/profile.dart';
import 'package:beach_app/search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'chatlist.dart';
import 'create_post.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {

  /// =========================
  /// SINGLE SELECTION VARIABLES
  /// =========================

  int selectedTab = 0;

  int selectedType = 1;

  int selectedLikes = 1;

  int selectedViews = 0;

  int selectedTopLikes = 1;

  int selectedTopViews = 0;

  int selectedDate = 0;

  bool loading = false;

  final List<String> tabs = [
    "World",
    "Country",
    "States"
  ];

  final List<String> tabsApi = [
    "world",
    "country",
    "states"
  ];

  final List<String> tabsimg = [
    "assets/world.png",
    "assets/country.png",
    "assets/states.png"
  ];

  final List<String> types = [
    "Photos",
    "Reels",
    "Stories"
  ];

  final List<String> typesApi = [
    "photos",
    "reels",
    "stories"
  ];

  final List<String> typesimage = [
    "assets/photos.png",
    "assets/reels.png",
    "assets/stories.png"
  ];

  final List<String> likeOptions = [
    "1K",
    "10K",
    "1K"
  ];

  final List<String> viewOptions = [
    "1M",
    "10k",
    "1K"
  ];

  final List<String> dateOptions = [
    "12 hour",
    "Dates",
    "Hours"
  ];

  @override
  void initState() {
    super.initState();

    getFilter();
  }

  /// =========================
  /// SAVE FILTER API
  /// =========================

  Future<void> saveFilter() async {

    try {

      setState(() {
        loading = true;
      });

      final url = Uri.parse(
        "https://beach.adpedia.in/api/save-filter",
      );

      Map<String, dynamic> body = {

        "filter_scope": tabsApi[selectedTab],

        "media_type": typesApi[selectedType],

        "selected_filter": "views",

        "filter_value": viewOptions[selectedViews],

        "date_filter_type": "hours",

        "date_filter_value": 12
      };

      final response = await http.post(

        url,

        headers: {
          "Content-Type": "application/json",
        },

        body: jsonEncode(body),
      );

      final jsonData = jsonDecode(response.body);

      setState(() {
        loading = false;
      });

      if (jsonData["status"] == true) {

        ScaffoldMessenger.of(context).showSnackBar(

          SnackBar(
            content: Text(jsonData["message"]),
          ),
        );
      }

    } catch (e) {

      setState(() {
        loading = false;
      });

      print(e);
    }
  }

  /// =========================
  /// GET FILTER API
  /// =========================

  Future<void> getFilter() async {

    try {

      String scope = tabsApi[selectedTab];

      String media = typesApi[selectedType];

      final url = Uri.parse(
        "https://beach.adpedia.in/api/get-filter/$scope/$media",
      );

      final response = await http.get(url);

      final jsonData = jsonDecode(response.body);

      if (jsonData["status"] == true) {

        final data = jsonData["data"];

        /// TAB

        selectedTab = tabsApi.indexOf(
          data["filter_scope"].toString(),
        );

        /// TYPE

        selectedType = typesApi.indexOf(
          data["media_type"].toString(),
        );

        /// VIEWS

        String view = data["filter_value"].toString();

        selectedViews = viewOptions.indexWhere(
              (e) => e.toLowerCase() == view.toLowerCase(),
        );

        if (selectedViews == -1) {
          selectedViews = 0;
        }

        setState(() {});
      }

    } catch (e) {

      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      bottomNavigationBar: BottomNavigationBar(

        backgroundColor: const Color(0xff1A1A1A),

        selectedItemColor: Colors.white,

        unselectedItemColor: Colors.grey,

        type: BottomNavigationBarType.fixed,

        items:  [



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

      body: SafeArea(

        child: Padding(

          padding: const EdgeInsets.all(14),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              /// HEADER

              Row(

                children: [

                  GestureDetector(

                    onTap: () {

                      Navigator.pop(context);
                    },

                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),

                  const Expanded(

                    child: Center(

                      child: Text(

                        "Filter",

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),
                ],
              ),

              const SizedBox(height: 25),

              /// TABS

              Row(

                children: List.generate(
                  tabs.length,
                      (index) {

                    return Expanded(

                      child: GestureDetector(

                        onTap: () {

                          setState(() {

                            selectedTab = index;
                          });

                          getFilter();
                        },

                        child: Container(

                          margin: const EdgeInsets.only(right: 8),

                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),

                          decoration: BoxDecoration(

                            color: const Color(0xff161616),

                            borderRadius:
                            BorderRadius.circular(30),

                            border: Border.all(

                              color: selectedTab == index
                                  ? Colors.white
                                  : Colors.orange,
                            ),
                          ),

                          child: Row(

                            mainAxisAlignment:
                            MainAxisAlignment.center,

                            children: [

                              CircleAvatar(

                                radius: 12,

                                backgroundImage:
                                AssetImage(
                                  tabsimg[index],
                                ),
                              ),

                              const SizedBox(width: 8),

                              Text(

                                tabs[index],

                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              /// TYPES

              Row(

                children: List.generate(
                  types.length,
                      (index) {

                    return Expanded(

                      child: GestureDetector(

                        onTap: () {

                          setState(() {

                            selectedType = index;
                          });

                          getFilter();
                        },

                        child: Container(

                          height: 42,

                          margin: const EdgeInsets.only(
                              right: 8),

                          decoration: BoxDecoration(

                            color: selectedType == index
                                ? const Color(0xff242424)
                                : const Color(0xff161616),

                            borderRadius:
                            BorderRadius.circular(25),
                          ),

                          child: Row(

                            mainAxisAlignment:
                            MainAxisAlignment.center,

                            children: [

                              Image.asset(
                                typesimage[index],
                                width: 16,
                                height: 16,
                                fit: BoxFit.fill,
                              ),

                              const SizedBox(width: 6),

                              Text(

                                types[index],

                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 22),

              /// LIKES

              const Text(
                "Likes",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 10),

              Row(

                children: List.generate(
                  likeOptions.length,
                      (index) {

                    return Expanded(

                      child: GestureDetector(

                        onTap: () {

                          setState(() {

                            selectedLikes = index;
                          });
                        },

                        child: _selectionContainer(
                          text: likeOptions[index],
                          selected:
                          selectedLikes == index,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              /// VIEWS

              const Text(
                "Views",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 10),

              Row(

                children: List.generate(
                  viewOptions.length,
                      (index) {

                    return Expanded(

                      child: GestureDetector(

                        onTap: () {

                          setState(() {

                            selectedViews = index;
                          });
                        },

                        child: _selectionContainer(
                          text: viewOptions[index],
                          selected:
                          selectedViews == index,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              /// TOP LIKES

              const Text(
                "Top Likes",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 10),

              Row(

                children: List.generate(
                  types.length,
                      (index) {

                    return Expanded(

                      child: GestureDetector(

                        onTap: () {

                          setState(() {

                            selectedTopLikes = index;
                          });
                        },

                        child: _selectionContainer(
                          text: types[index],
                          selected:
                          selectedTopLikes == index,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              /// TOP VIEWS

              const Text(
                "Top View",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 10),

              Row(

                children: List.generate(
                  types.length,
                      (index) {

                    return Expanded(

                      child: GestureDetector(

                        onTap: () {

                          setState(() {

                            selectedTopViews = index;
                          });
                        },

                        child: _selectionContainer(
                          text: types[index],
                          selected:
                          selectedTopViews == index,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              /// DATES

              const Text(
                "Dates",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 10),

              Row(

                children: List.generate(
                  dateOptions.length,
                      (index) {

                    return Expanded(

                      child: GestureDetector(

                        onTap: () {

                          setState(() {

                            selectedDate = index;
                          });
                        },

                        child: _selectionContainer(
                          text: dateOptions[index],
                          selected:
                          selectedDate == index,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const Spacer(),

              /// BUTTONS

              Row(

                children: [

                  Expanded(

                    child: GestureDetector(

                      onTap: () {

                        saveFilter();
                      },

                      child: Container(

                        height: 50,

                        decoration: BoxDecoration(

                          gradient: const LinearGradient(
                            colors: [
                              Color(0xffFF3B30),
                              Color(0xffFF9F0A),
                            ],
                          ),

                          borderRadius:
                          BorderRadius.circular(30),
                        ),

                        child: Center(

                          child: loading

                              ? const SizedBox(

                            height: 20,
                            width: 20,

                            child:
                            CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )

                              : const Text(

                            "Save",

                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(

                    child: GestureDetector(

                      onTap: () {

                        setState(() {

                          selectedLikes = 0;
                          selectedViews = 0;
                          selectedTopLikes = 0;
                          selectedTopViews = 0;
                          selectedDate = 0;
                        });
                      },

                      child: Container(

                        height: 50,

                        decoration: BoxDecoration(

                          color: Colors.white,

                          borderRadius:
                          BorderRadius.circular(30),
                        ),

                        child: const Center(

                          child: Text(

                            "Clear",

                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  /// =========================
  /// COMMON CONTAINER
  /// =========================

  Widget _selectionContainer({

    required String text,

    required bool selected,
  }) {

    return Container(

      height: 45,

      margin: const EdgeInsets.only(right: 8),

      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),

      decoration: BoxDecoration(

        color: const Color(0xff161616),

        borderRadius:
        BorderRadius.circular(25),
      ),

      child: Row(

        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,

        children: [

          Row(

            children: [

              Container(

                width: 18,

                height: 18,

                decoration: BoxDecoration(

                  shape: BoxShape.circle,

                  color: selected
                      ? Colors.orange
                      : Colors.white,
                ),

                child: selected

                    ? const Icon(
                  Icons.check,
                  size: 12,
                  color: Colors.white,
                )

                    : null,
              ),

              const SizedBox(width: 8),

              Text(

                text,

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white,
            size: 18,
          ),
        ],
      ),
    );
  }
}