import 'package:flutter/material.dart';

import 'mainscreen.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [

                // 🔹 TITLE
                const Text(
                  "Create Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                // 🔹 NAME
                buildInputField(
                  hint: "Full Name",
                  icon: Icons.person,
                ),

                const SizedBox(height: 20),

                // 🔹 MOBILE
                buildInputField(
                  hint: "Mobile Number",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 20),

                // 🔹 EMAIL
                buildInputField(
                  hint: "Email",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 20),

                // 🔹 PASSWORD
                buildInputField(
                  hint: "Password",
                  icon: Icons.lock,
                  isPassword: true,
                ),

                const SizedBox(height: 30),

                // 🔹 SIGNUP BUTTON
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
                      // TODO: Call register API

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // 🔹 LOGIN LINK
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Login",
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

  // 🔥 Reusable Input Field
  Widget buildInputField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      obscureText: isPassword,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}