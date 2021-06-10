

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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