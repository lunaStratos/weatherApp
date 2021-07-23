import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * 이미지 있는 alert
 * */
class AlertImage extends StatelessWidget{

  String title = "";
  String contents = "";
  String switchStr = "";

  AlertImage({required this.title, required this.contents, required this.switchStr});

  @override
  Widget build(BuildContext context) {
    return _buildAlertImage(context, title, contents, switchStr);
  }

  String switchImageStr(switchStr){
    String imageStr = "assets/images/toggle_on_location.png";
    switch(switchStr){
      case "locationPermission" :
        imageStr = "assets/images/toggle_on_location.png";
      break;
      case "alarmPermission" :
        imageStr = "assets/images/toggle_on_alarm.png";
      break;
    }

    return imageStr;
  }

  Widget _buildAlertImage(BuildContext context, title, contents, switchStr){

    String imageStr = switchImageStr(switchStr);

    return new Container(
        child:  AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Image.asset(imageStr),
                Text(contents),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        )
    );
  }

}