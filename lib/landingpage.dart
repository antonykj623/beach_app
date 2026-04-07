import 'package:beach_app/loginpage.dart';
import 'package:beach_app/signuppage.dart';
import 'package:flutter/material.dart';



class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              /// 🔝 TOP CONTENT
              Column(
                children: [
                  const SizedBox(height: 60),

                  /// LOGO
                  Container(
                    height: 80,
                    width: 80,
                   
                    child: Image.asset("assets/beach_icon.png",width: 70,height: 70,fit: BoxFit.fill,),
                  ),

                  const SizedBox(height: 15),

                  /// TITLE
                  Text(
                    "Connect with your friends",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// SUBTITLE
                  Text(
                    "Connect, share stories, and grow together in one trusted space.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              /// 🔽 BUTTONS
              Column(
                children: [

                  /// SIGN IN BUTTON
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
                        child: GestureDetector(
                          child:  Center(
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );

                          },
                        )


                    ),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );

                    },
                  )

                  ,

                  const SizedBox(height: 15),

                  /// SIGN UP BUTTON
                  ///
                  ///

                 GestureDetector(
                   child: Container(
                       width: double.infinity,
                       height: 55,
                       decoration: BoxDecoration(
                         color: Colors.grey[900],
                         borderRadius: BorderRadius.circular(30),
                       ),
                       child: GestureDetector(

                         child:    Center(
                           child: Text(
                             "Sign Up",
                             style: TextStyle(
                               color: Colors.white70,
                               fontSize: 16,
                             ),
                           ),
                         ),
                         onTap: (){
                           Navigator.pushReplacement(
                             context,
                             MaterialPageRoute(builder: (context) => SignupScreen()),
                           );


                         },
                       )



                   ),
                   onTap: (){

                     Navigator.pushReplacement(
                       context,
                       MaterialPageRoute(builder: (context) => SignupScreen()),
                     );
                   },
                 )

                  ,

                  const SizedBox(height: 30),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}