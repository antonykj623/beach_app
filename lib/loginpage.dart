import 'package:beach_app/signuppage.dart';
import 'package:flutter/material.dart';

import 'mainscreen.dart';



class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [

                // 🔹 APP TITLE
                const Text(
                  "Beach",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: "cursive",
                  ),
                ),

                const SizedBox(height: 40),

                // 🔹 MOBILE FIELD
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Mobile Number",
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon:
                    const Icon(Icons.phone, color: Colors.white),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 20),

                // 🔹 PASSWORD FIELD
                TextField(
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon:
                    const Icon(Icons.lock, color: Colors.white),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // 🔹 LOGIN BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // TODO: Call login API

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // 🔹 FORGOT PASSWORD
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 10),

                // 🔹 REGISTER
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to Register

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignupPage()),
                        );

                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.orange),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}