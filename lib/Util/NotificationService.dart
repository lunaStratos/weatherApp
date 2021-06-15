

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationService {

  var _flutterLocalNotificationsPlugin;
  Future<void> init() async {

  }

  Future selectNotification(String payload) async {
    print('payload ${payload}');
    AlertWid();
  }


}

class AlertWid extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(""),
      title: Text(""),
    );
  }

}