import 'package:beach_app/signuppage.dart';
import 'package:beach_app/utilities/Utils.dart';
import 'package:beach_app/utilities/native_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'mainscreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'models/SignupResponse.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;

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

              /// HEADER
              Row(
                children: [
                  Expanded(
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios,
                          color: Colors.white),
                    ),
                  ),

                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Hello Again",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),

              SizedBox(height: 25),

              /// SUBTITLE
              Center(
                child: Text(
                  "Welcome back—let’s get you set up\nin just a few steps.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              SizedBox(height: 40),

              /// EMAIL
              TextField(
                controller: emailController,
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
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                ),
              ),

              SizedBox(height: 15),

              /// PASSWORD
              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
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

                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),

                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                ),
              ),

              SizedBox(height: 10),

              /// FORGOT PASSWORD
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Forgot password?",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),

              Spacer(),

              /// LOGIN BUTTON
              GestureDetector(
    onTap: () async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Enter email & password")),
    );
    return;
    }

    /// 🔹 Show Loader
    showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Center(child: CircularProgressIndicator()),
    );

    SignupResponse? res = await loginApi(email, password);

    Navigator.pop(context); // close loader

    if (res != null && res.success && res.data != null) {

    /// ✅ SUCCESS
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(res.message)),
    );

    print("TOKEN: ${res.data!.token}");
    NativeStorage.setValue(Utils.token, res.data!.token);
    NativeStorage.setValue(Utils.mobile, res.data!.mobile);

    Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => HomeScreen()),
    );

    } else {

    /// ❌ ERROR
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text(res?.message ?? "Login failed"),
    ),
    );
    }
    },

                child: Container(
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
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15),

              /// OR
              Center(
                child: Text(
                  "Or with",
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              SizedBox(height: 15),

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
                    Image.asset("assets/google.png",
                        width: 28, height: 28),
                    SizedBox(width: 10),
                    Text(
                      "Sign in with Google",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              /// SIGNUP
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
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SignupScreen()),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  bool validateEmail(String value) {
    final emailRegex =
    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    bool isvalid=false;
    if (emailRegex.hasMatch(value)) {
      isvalid=true;

    }

    return isvalid;
  }





  Future<SignupResponse?> loginApi(String email, String password) async {
    final url = Uri.parse("https://beach.adpedia.in/api/login");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      print("RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return SignupResponse.fromJson(jsonData);
      } else {
        return null;
      }
    } catch (e) {
      print("ERROR: $e");
      return null;
    }
  }
}