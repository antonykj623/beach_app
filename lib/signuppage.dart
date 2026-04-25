import 'package:beach_app/utilities/Utils.dart';
import 'package:beach_app/web/ApiServices.dart';
import 'package:beach_app/web/Apimethodes.dart';
import 'package:flutter/material.dart';

import 'mainscreen.dart';
import 'models/SignupModel.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isHidden = true;


  String countryid="1";

  String state_id="2";

  String selected_country="India";
  String selected_state="Kerala";

  TextEditingController namecontroller=new TextEditingController();

  TextEditingController usernamecontroller=new TextEditingController();

  TextEditingController phonecontroller=new TextEditingController();

  TextEditingController emailcontroller=new TextEditingController();

  TextEditingController passwordcontroller=new TextEditingController();
  String passwordError = "",emailError="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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

                _buildTextField("Full Name",namecontroller),
                const SizedBox(height: 10),
                _buildTextField("@Username",usernamecontroller),
                const SizedBox(height: 10),
                _buildTextField("Your Email",emailcontroller),
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
                      child: _buildTextField("Phone Number",phonecontroller),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                /// PASSWORD FIELD
                TextField(
                  obscureText: isHidden,
                  controller: passwordcontroller,
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
                    passwordError.isEmpty
                        ? "Min. 8 characters, 1 number & 1 special character."
                        : passwordError,
                    style: TextStyle(
                      color: passwordError.isEmpty ? Colors.grey : Colors.red,
                      fontSize: 12,
                    ),
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
                 onTap: () async {


                   if(namecontroller.text.trim().isNotEmpty){
                     if(usernamecontroller.text.trim().isNotEmpty){
                       if(emailcontroller.text.trim().isNotEmpty && validateEmail(emailcontroller.text.trim())){

                         if(phonecontroller.text.trim().isNotEmpty){

                           if(passwordcontroller.text.trim().isNotEmpty && passwordError==""){



                             SignupModel user = SignupModel(
                               name: namecontroller.text,
                               username: usernamecontroller.text,
                               email: emailcontroller.text,
                               phone: phonecontroller.text,
                               countryId: 1,
                               stateId: 2,
                               password: passwordcontroller.text,
                               confirmPassword: passwordcontroller.text,
                             );

                             final response =
                                 await ApiService.postRequest(Apimethodes.register, user.toJson());







                           }
                           else{


                             Utils.showAlertDialog(context, "Password should be Min. 8 characters, 1 number & 1 special character.");
                           }

                         }
                         else{


                           Utils.showAlertDialog(context, "Enter phone number");
                         }

                       }
                       else{


                         Utils.showAlertDialog(context, "Enter valid email");
                       }


                     }
                     else{


                       Utils.showAlertDialog(context, "Enter username");
                     }


                   }
                   else{


                     Utils.showAlertDialog(context, "Enter your name");
                   }





                   // Navigator.push(
                   //   context,
                   //   MaterialPageRoute(builder: (context) => HomeScreen()),
                   // );

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

  bool validateEmail(String value) {
    final emailRegex =
    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    bool isvalid=false;
    if (emailRegex.hasMatch(value)) {
      emailError = "Please enter a valid email address";
      isvalid=true;

    }
    
    return isvalid;
  }

  void validatePassword(String value) {
    final passwordRegex =
    RegExp(r'^(?=.*[0-9])(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$');

    setState(() {
      if (value.isEmpty) {
        passwordError = "";
      } else if (!passwordRegex.hasMatch(value)) {
        passwordError =
        "Min. 8 characters, 1 number & 1 special character.";
      } else {
        passwordError = "";
      }
    });
  }


  /// 🔹 Reusable TextField
  Widget _buildTextField(String hint,TextEditingController controller) {
    return TextField(
      style: TextStyle(color: Colors.white),
      controller: controller,
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
        child: DropdownButton<String>(
          value: (hint == "Country") ? selected_country : selected_state,
          dropdownColor: Colors.black,
          hint: Text(
            hint,
            style: TextStyle(color: Colors.grey),
          ),
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          items: ((hint == "Country")
              ? ["India", "USA", "UK"]
              : ["Kerala", "Tamil Nadu", "Karnataka"])
              .map((e) => DropdownMenuItem<String>(
            value: e,
            child: Text(
              e,
              style: TextStyle(color: Colors.white),
            ),
          ))
              .toList(),
          onChanged: (value) {
            setState(() {
              if (hint == "Country") {
                selected_country = value!;
              } else {
                selected_state = value!;
              }
            });
          },
        ),
      ),
    );
  }
}