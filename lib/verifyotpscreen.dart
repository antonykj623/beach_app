import 'package:beach_app/resetpassword.dart';
import 'package:beach_app/web/ApiServices.dart';
import 'package:flutter/material.dart';


class VerifyOtpScreen extends StatefulWidget {
  final String email;
  final String otp;

  VerifyOtpScreen({required this.email,required this.otp});

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {

  TextEditingController otpController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      otpController.text=widget.otp;
    });
  }

  void verifyOtp() async {
    setState(() => loading = true);

    var res = await ApiService.verifyOtp(
        widget.email, int.parse(otpController.text));

    setState(() => loading = false);

    if (res["status"] == true) {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(
            email: widget.email,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid OTP")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify OTP")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            Text("OTP sent to ${widget.email}"),

            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Enter OTP"),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: loading ? null : verifyOtp,
              child: loading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Verify"),
            )
          ],
        ),
      ),
    );
  }
}