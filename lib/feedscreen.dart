import 'package:beach_app/profile.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  final List posts = [
    {
      "name": "John Kennedy",
      "location": "Universal Studio America",
      "image": "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e",
      "profile": "https://randomuser.me/api/portraits/men/1.jpg",
      "caption": "ps. kevin also, she gave my lego the also I'm yet to...",
      "time": "12 hours ago"
    },
    {
      "name": "Kim Jong Un",
      "location": "Universal Studio America",
      "image": "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d",
      "profile": "https://randomuser.me/api/portraits/men/2.jpg",
      "caption": "Stylish look 😎",
      "time": "10 hours ago"
    },
    {
      "name": "John Doe",
      "location": "Universal Studio America",
      "image": "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d",
      "profile": "https://randomuser.me/api/portraits/men/3.jpg",
      "caption": "Stylish look 😎",
      "time": "10 hours ago"
    }
  ];

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
        child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 🔝 HEADER
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(post["profile"]),
                  ),
                  title: Text(
                    post["name"],
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    post["location"],
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  trailing: Icon(Icons.more_vert, color: Colors.white),
                ),

                /// 🖼 POST IMAGE
                Image.network(
                  post["image"],
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),

                /// ❤️ ACTIONS
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 8),
                  child: Row(
                    children: [
                      Icon(Icons.favorite_border, color: Colors.white),
                      SizedBox(width: 15),
                      Image.asset("assets/chat.png",width: 18,height: 18,fit: BoxFit.fill,),

                      SizedBox(width: 15),
                      Image.asset("assets/send.png",width: 18,height: 18,fit: BoxFit.fill,),
                      Spacer(),
                      Icon(Icons.bookmark_border,
                          color: Colors.white),
                    ],
                  ),
                ),

                /// 📝 CAPTION
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    post["caption"],
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                /// ⏱ TIME
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  child: Text(
                    post["time"],
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),

                SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}