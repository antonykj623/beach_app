import 'dart:convert';

import 'package:beach_app/chatlist.dart';
import 'package:beach_app/create_post.dart';
import 'package:beach_app/create_story.dart';
import 'package:beach_app/search.dart';
import 'package:beach_app/updateProfile.dart';
import 'package:beach_app/utilities/Utils.dart';
import 'package:beach_app/utilities/native_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'followerfollowlist.dart';
import 'mainscreen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}






class _ProfileScreenState extends State<ProfileScreen> {


  bool isLoading=false;
  Map<String, dynamic>? profileData={};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      /// 🔻 BOTTOM NAV
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
      BottomNavigationBarItem(icon: GestureDetector(

          child: Image.asset("assets/home.png",width: 16,height: 16,fit: BoxFit.fill,),
        onTap: (){

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
      )



       , label: ""),


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

    child: Image.asset("assets/user_selected.png",width: 16,height: 16,fit: BoxFit.fill,) ,
    onTap: (){

    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ProfileScreen()),
    );
    },
    ),label: "")




        ],
      ),

      body: SafeArea(
        child: Column(
          children: [

            /// 🔝 APP BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  GestureDetector(
                    child: Icon(Icons.add, color: Colors.white),
                    onTap: (){

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreateStoryScreen()),
                      );
                    },
                  )
                  ,
                  Text(
                    "Profile",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Icon(Icons.menu, color: Colors.white),
                ],
              ),
            ),

            /// 👤 PROFILE INFO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [

                  /// PROFILE IMAGE
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: profileData!["profile_image"] != null
                        ? NetworkImage(profileData!["profile_image"])
                        : AssetImage("assets/user.png") as ImageProvider,
                  ),

                  SizedBox(width: 15),

                  /// NAME + STATS
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(   profileData!["name"] ?? "",
                            style: TextStyle(color: Colors.white)),

                        SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStat("00", "Posts"),
                            GestureDetector(

                              child:
                              _buildStat(
                                  profileData!["followers"].toString(),
                                  "Followers"),

                              onTap: (){

                                Navigator.push(

                                  context,

                                  MaterialPageRoute(

                                    builder: (context) =>
                                    const FollowersFollowingScreen(
                                      initialTab: 0,
                                    ),
                                  ),
                                );
                              },

                            ),

                            GestureDetector(

                              child:      _buildStat(
                                  profileData!["following"].toString(),
                                  "Following"),
                              onTap: (){
                                Navigator.push(

                                  context,

                                  MaterialPageRoute(

                                    builder: (context) =>
                                    const FollowersFollowingScreen(
                                      initialTab: 1,
                                    ),
                                  ),
                                );

                              },

                            )

                       ,
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: 15),

            /// 🔘 TAGS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  _chip("State ${profileData!["state_id"]}"),
                  SizedBox(width: 8),
                  _chip("Country ${profileData!["country_id"]}"),
                  SizedBox(width: 8),
                  _chip("Saved"),
                ],
              ),
            ),

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (context) =>
                   UpdateProfileScreen()
                  ),
                );

              },

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff1565C0),
                foregroundColor: Colors.white,
              ),

              child: const Text("Edit Profile"),
            ),
            SizedBox(height: 20),

            /// 🔲 TABS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.grid_on, color: Colors.white),
                Icon(Icons.image, color: Colors.grey),
                Icon(Icons.video_collection, color: Colors.grey),
                Icon(Icons.favorite_border, color: Colors.grey),
                Icon(Icons.person_pin, color: Colors.grey),
              ],
            ),

            Divider(color: Colors.grey[800]),

            /// 📭 EMPTY STATE
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.grid_view,
                        color: Colors.grey, size: 40),
                    SizedBox(height: 10),
                    Text(
                      "No Posts Yet",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 STAT WIDGET
  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(height: 2),
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  /// 🔹 CHIP WIDGET
  Widget _chip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }


  Future<void> getProfile() async {
    try {
      String? v=await NativeStorage.getValue(Utils.token);
      final response = await http.get(
        Uri.parse("https://beach.adpedia.in/api/profile"),
          headers: {"Authorization":"Bearer "+v!}
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData["status"] == true) {
          setState(() {
            profileData = jsonData["data"];
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

}