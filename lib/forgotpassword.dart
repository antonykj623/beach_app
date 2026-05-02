import 'package:beach_app/verifyotpscreen.dart';
import 'package:beach_app/web/ApiServices.dart';
import 'package:flutter/material.dart';


class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  TextEditingController emailController = TextEditingController();
  bool loading = false;

  void sendOtp() async {
    setState(() => loading = true);

    var res = await ApiService.forgotPassword(emailController.text);

    setState(() => loading = false);

    if (res["status"] == true) {

      String otp=res["otp"].toString();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res["message"])),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyOtpScreen(
            email: emailController.text,
            otp: otp,
          ),
        ),
      );



    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(title: Text("Forgot Password",style: TextStyle(color: Colors.white),)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: loading ? null : sendOtp,
              child: loading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Send OTP"),
            )
          ],
        ),
      ),
    );
  }
}