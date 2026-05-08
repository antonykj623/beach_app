import 'package:beach_app/utilities/Utils.dart';
import 'package:beach_app/utilities/native_storage.dart';
import 'package:beach_app/web/ApiServices.dart';
import 'package:beach_app/web/Apimethodes.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'mainscreen.dart';
import 'models/SignupModel.dart';
import 'models/SignupResponse.dart';
import 'models/country.dart';
import 'models/state.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();


}

class _SignupScreenState extends State<SignupScreen> {
  bool isHidden = true;


  String countryid="0";

  String state_id="0";

  String selected_country="";
  String selected_state="";
  String country_code="";

  TextEditingController namecontroller=new TextEditingController();

  TextEditingController usernamecontroller=new TextEditingController();

  TextEditingController phonecontroller=new TextEditingController();

  TextEditingController emailcontroller=new TextEditingController();

  TextEditingController passwordcontroller=new TextEditingController();
  String passwordError = "",emailError="";

  List<Country>countrylist=[];
  List<StateModel> statemodels=[];

   Country? country_obj;
   StateModel? stateModel_obj;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCountries();

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
                        onPressed: () {
                          Navigator.pop(context);


                        },
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
                    (country_code.isNotEmpty)? Container(
                      width: 90,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Color(0xFF1C1C1E),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          dropdownColor: Colors.black,
                          value: country_code,
                          items: [country_code]
                              .map((e) => DropdownMenuItem(
                            child: Text(e,
                                style: TextStyle(color: Colors.white)),
                            value: e,
                          ))
                              .toList(),
                          onChanged: (value) {},
                        ),
                      ),
                    ):Container(),

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
                  onChanged: (txt){
                    validatePassword(txt);
                  },
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

                             Utils.showLoaderDialog(context);


                             SignupModel user = SignupModel(
                               name: namecontroller.text,
                               username: usernamecontroller.text,
                               email: emailcontroller.text,
                               phone: phonecontroller.text,
                               countryId: int.parse(countryid),
                               stateId: int.parse(state_id),
                               password: passwordcontroller.text,
                               confirmPassword: passwordcontroller.text,
                             );

                             final response =
                                 await ApiService.postRequest(Apimethodes.register, user.toJson());


                             Navigator.pop(context);


                             SignupResponse result =
                             SignupResponse.fromJson(response);

                             if(result.success)
                               {

                                 NativeStorage.setValue(Utils.token, result.data!.token);


                                 NativeStorage.setValue(Utils.mobile, result.data!.mobile);

                                 Navigator.push(
                                   context,
                                   MaterialPageRoute(builder: (context) => HomeScreen()),
                                 );

                               }
                             else{

                               Utils.showAlertDialog(context, result.message);
                             }






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


   fetchStates(String countryId) async {
    final response = await http.get(
      Uri.parse(
        ApiService.baseUrl+Apimethodes.states+"?country_id=$countryId",
      ),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData["success"] == true) {
        List list = jsonData["data"];

        setState(() {

          statemodels.clear();

          statemodels.addAll(list.map((e) => StateModel.fromJson(e)).toList());

          stateModel_obj=statemodels.first;

        });


      } else {
        throw Exception("Failed to load states");
      }
    } else {
      throw Exception("Server error");
    }
  }

   fetchCountries() async {
    final response = await http.get(
      Uri.parse(ApiService.baseUrl+Apimethodes.country),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData["success"] == true) {
        List list = jsonData["data"];
         setState(() {
           countrylist.clear();
           countrylist.addAll( list.map((e) => Country.fromJson(e)).toList());

           country_obj=countrylist.first;
           country_code=country_obj!.country_code;
         });
      } else {
        throw Exception("API failed");
      }
    } else {
      throw Exception("Server error");
    }
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



    if(hint=="Country") {

      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(30),
        ),

        child: DropdownButtonHideUnderline(
          child: DropdownButton<Country>(
            isExpanded: true, // 🔥 important

            value: country_obj!=null ? country_obj : null,

            dropdownColor: Colors.black,

            hint: Text(
              hint,
              style: TextStyle(color: Colors.grey),
            ),

            icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),

            items: countrylist.map((e) {
              return DropdownMenuItem<Country>(
                value: e,
                child: Text(
                  e.name,
                  style: TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis, // 🔥 fix overflow
                ),
              );
            }).toList(),

            onChanged: (value) {
              setState(() {
                country_obj=value!;
                selected_country = value!.name;
                countryid=value!.id.toString();
                country_code=value!.country_code;

                fetchStates(countryid);
              });
            },
          ),
        ),
      );

    }
    else{

      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(30),
        ),

        child: DropdownButtonHideUnderline(
          child: DropdownButton<StateModel>(
            isExpanded: true, // 🔥 important

            value: stateModel_obj!=null ? stateModel_obj : null,

            dropdownColor: Colors.black,

            hint: Text(
              hint,
              style: TextStyle(color: Colors.grey),
            ),

            icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),

            items: statemodels.map((e) {
              return DropdownMenuItem<StateModel>(
                value: e,
                child: Text(
                  e.name,
                  style: TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis, // 🔥 fix overflow
                ),
              );
            }).toList(),

            onChanged: (value) {
              setState(() {
                selected_state = value!.name;
                state_id=value!.id.toString();

                stateModel_obj=value;


              });
            },
          ),
        ),
      );


    }
  }
}