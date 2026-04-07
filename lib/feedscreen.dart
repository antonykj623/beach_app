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
                      Icon(Icons.chat_bubble_outline,
                          color: Colors.white),
                      SizedBox(width: 15),
                      Icon(Icons.send, color: Colors.white),
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