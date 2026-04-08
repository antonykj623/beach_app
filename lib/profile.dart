import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
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
      BottomNavigationBarItem(icon: Image.asset("assets/home.png",width: 16,height: 16,fit: BoxFit.fill,) , label: ""),
    BottomNavigationBarItem(icon: Image.asset("assets/search.png",width: 16,height: 16,fit: BoxFit.fill,) , label: ""),
    BottomNavigationBarItem(icon: Image.asset("assets/plus.png",width: 16,height: 16,fit: BoxFit.fill,) , label: ""),
    BottomNavigationBarItem(icon: Image.asset("assets/chat.png",width: 16,height: 16,fit: BoxFit.fill,) , label: ""),
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
                  Icon(Icons.add, color: Colors.white),
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
                    backgroundImage: NetworkImage(
                        "https://randomuser.me/api/portraits/men/1.jpg"),
                  ),

                  SizedBox(width: 15),

                  /// NAME + STATS
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("John Kennedy",
                            style: TextStyle(color: Colors.white)),

                        SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStat("00", "Posts"),
                            _buildStat("03", "Followers"),
                            _buildStat("00", "Following"),
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
                  _chip("State  Kerala"),
                  SizedBox(width: 8),
                  _chip("Country  India"),
                  SizedBox(width: 8),
                  _chip("Saved"),
                ],
              ),
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
}