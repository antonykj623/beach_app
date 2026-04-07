import 'package:beach_app/signuppage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'mainscreen.dart';


class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔙 BACK BUTTON



              /// TITLE
              Align(
                alignment: FractionalOffset.center,
                child: Row(
                  children: [
                    Expanded(child:   IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white,size: 25,),
                    ),flex: 1,),

                    Expanded(child:  Align(
                      alignment: FractionalOffset.centerRight,
                      child:Text(
                        "Hello Again",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ) ,
                    )



                    ,flex: 3,)
                  ],
                )


              ,
              ),

              const SizedBox(height: 25),

              /// SUBTITLE
              Center(
                child: Text(
                  "Welcome back—let’s get you set up\nin just a few steps.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              /// EMAIL FIELD
              TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Email Address",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFF1C1C1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: 18),
                ),
              ),

              const SizedBox(height: 15),

              /// PASSWORD FIELD
              TextField(
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFF1C1C1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: Icon(Icons.visibility_off, color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: 18),
                ),
              ),

              const SizedBox(height: 10),

              /// FORGOT PASSWORD
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Forgot password?",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),

              const Spacer(),

              /// LOGIN BUTTON

            GestureDetector(

              child:  Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red, Colors.orange],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              onTap: (){

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );


              },
            )

             ,

              const SizedBox(height: 15),

              /// OR TEXT
              Center(
                child: Text(
                  "Or with",
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              const SizedBox(height: 15),

              /// GOOGLE BUTTON
              Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  color: Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/google.png",width: 28,height: 28,),
                    SizedBox(width: 10),
                    Text(
                      "Sign in with Google",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// SIGN UP TEXT


      Center(
      child: RichText(
      text: TextSpan(
        text: "Don't have an account? ",
        style: TextStyle(color: Colors.grey),
        children: [
          TextSpan(
            text: "Sign up now !",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // 👉 Your action here
                print("Signup clicked");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                );
                // Example: Navigate to signup page
                // Navigator.push(context,
                //   MaterialPageRoute(builder: (context) => SignupScreen()));
              },
          ),
        ],
      ),
    ),
    ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}