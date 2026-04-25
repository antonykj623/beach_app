import 'package:flutter/material.dart';


class Utils{

  static String getRandomnumber()
  {
    String a=DateTime.now().microsecondsSinceEpoch.toString();

    return a;
  }
  static showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }


  static showAlertDialog(BuildContext context,String message)async{
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Beach'),
          content: Text(message),
          actions: [

            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Add your action here
              },
            ),
          ],
        );
      },
    );

  }



}