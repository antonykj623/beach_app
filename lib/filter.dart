import 'package:beach_app/profile.dart';
import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {

  int selectedTab = 0;

  /// toggle selections
  Map<String, bool> topLikes = {
    "Photos": false,
    "Reels": true,
    "Stories": true,
  };

  Map<String, bool> topViews = {
    "Photos": true,
    "Reels": true,
    "Stories": true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

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

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              /// 🔝 HEADER
              Row(
                children: [

                  GestureDetector(
                    child:                   Icon(Icons.arrow_back, color: Colors.white),
onTap: (){

             Navigator.pop(context);
},
                  ),
                  Expanded(
                    child: Center(
                      child: Text("Filter",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18)),
                    ),
                  ),
                  SizedBox(width: 24)
                ],
              ),

              SizedBox(height: 20),

              /// 🌍 TABS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _tabItem("World", 0),
                  _tabItem("Country", 1),
                  _tabItem("States", 2),
                ],
              ),

              SizedBox(height: 20),

              /// 📸 TYPE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _chip("Photos"),
                  _chip("Reels"),
                  _chip("Stories"),
                ],
              ),

              SizedBox(height: 20),

              /// ❤️ LIKES
              _sectionTitle("Likes"),
              SizedBox(height: 4,),
              _dropdownRow(["1K", "10K", "1K"]),

              SizedBox(height: 15),

              /// 👁 VIEWS
              _sectionTitle("Views"),
              SizedBox(height: 4,),

              _dropdownRow(["1M", "10K", "1K"]),

              SizedBox(height: 15),

              /// 🔥 TOP LIKES
              _sectionTitle("Top Likes"),
              SizedBox(height: 4,),

              _toggleRow(topLikes),

              SizedBox(height: 15),

              /// 🔥 TOP VIEWS
              _sectionTitle("Top View"),
              SizedBox(height: 4,),

              _toggleRow(topViews),

              SizedBox(height: 15),

              /// 📅 DATES
              _sectionTitle("Dates"),
              SizedBox(height: 4,),

              _dropdownRow(["12 hour", "Dates", "Dates"]),

              Spacer(),

              /// 🔘 BUTTONS
              Row(
                children: [
                  Expanded(
                    child: _gradientButton("Save"),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _clearButton("Clear"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 TAB
  Widget _tabItem(String text, int index) {
    bool selected = selectedTab == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.white10 : Colors.grey[900],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? Colors.white : Colors.transparent),
        ),
        child: Text(text,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500)),
      ),
    );
  }

  /// 🔹 CHIP
  Widget _chip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }

  /// 🔹 SECTION TITLE
  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title,
          style: TextStyle(color: Colors.grey, fontSize: 13)),
    );
  }

  /// 🔹 DROPDOWN ROW
  Widget _dropdownRow(List<String> values) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: values.map((e) => _dropdown(e)).toList(),
    );
  }

  Widget _dropdown(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(text, style: TextStyle(color: Colors.white)),
          Icon(Icons.arrow_drop_down, color: Colors.white),
        ],
      ),
    );
  }

  /// 🔹 TOGGLE ROW
  Widget _toggleRow(Map<String, bool> data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: data.keys.map((key) {
        return GestureDetector(
          onTap: () {
            setState(() {
              data[key] = !data[key]!;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  data[key]! ? Icons.check_circle : Icons.circle_outlined,
                  color: data[key]! ? Colors.orange : Colors.white,
                  size: 18,
                ),
                SizedBox(width: 6),
                Text(key, style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 🔹 SAVE BUTTON
  Widget _gradientButton(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange, Colors.red],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(text,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  /// 🔹 CLEAR BUTTON
  Widget _clearButton(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(text,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }
}