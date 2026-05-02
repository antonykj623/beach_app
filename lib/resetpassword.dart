import 'package:beach_app/web/ApiServices.dart';
import 'package:flutter/material.dart';


class ResetPasswordScreen extends StatefulWidget {
  final String email;

  ResetPasswordScreen({required this.email});

  @override
  _ResetPasswordScreenState createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  TextEditingController passController = TextEditingController();
  bool loading = false;

  void resetPassword() async {
    setState(() => loading = true);

    var res = await ApiService.resetPassword(
        widget.email, passController.text);

    setState(() => loading = false);

    if (res["status"] == true) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password Updated")),
      );

      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reset Password")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: passController,
              obscureText: true,
              decoration: InputDecoration(labelText: "New Password"),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: loading ? null : resetPassword,
              child: loading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Reset Password"),
            )
          ],
        ),
      ),
    );
  }
}