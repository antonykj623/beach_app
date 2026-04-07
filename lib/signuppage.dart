import 'package:flutter/material.dart';

import 'mainscreen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

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
                          "Sign up",
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

                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Create your account and start connecting\n with people who matter.",

                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),

                _buildTextField("Full Name"),
                const SizedBox(height: 10),
                _buildTextField("@Username"),
                const SizedBox(height: 10),
                _buildTextField("Your Email"),
                const SizedBox(height: 10),
                /// COUNTRY + STATE
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown("Country"),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildDropdown("State"),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                /// PHONE ROW
                Row(
                  children: [
                    Container(
                      width: 90,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Color(0xFF1C1C1E),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          dropdownColor: Colors.black,
                          value: "+91",
                          items: ["+91", "+1", "+44"]
                              .map((e) => DropdownMenuItem(
                            child: Text(e,
                                style: TextStyle(color: Colors.white)),
                            value: e,
                          ))
                              .toList(),
                          onChanged: (value) {},
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: _buildTextField("Phone Number"),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                /// PASSWORD FIELD
                TextField(
                  obscureText: isHidden,
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
                        isHidden
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isHidden = !isHidden;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                /// PASSWORD HINT
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Min. 8 characters, 1 number & 1 special character.",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),

                const SizedBox(height: 60),

                /// SAVE BUTTON


               GestureDetector(

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
                       "Save Profile",
                       style: TextStyle(
                         color: Colors.white,
                         fontWeight: FontWeight.bold,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Reusable TextField
  Widget _buildTextField(String hint) {
    return TextField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Color(0xFF1C1C1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// 🔹 Reusable Dropdown
  Widget _buildDropdown(String hint) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          dropdownColor: Colors.black,
          hint: Text(hint, style: TextStyle(color: Colors.grey)),
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          items: ["Option 1", "Option 2"]
              .map((e) => DropdownMenuItem(
            child: Text(e, style: TextStyle(color: Colors.white)),
            value: e,
          ))
              .toList(),
          onChanged: (value) {},
        ),
      ),
    );
  }
}