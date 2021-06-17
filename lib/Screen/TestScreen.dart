import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';
import 'package:rainvow_mobile/Domain/PushNotification.dart';
import 'package:rainvow_mobile/Screen/RainfallWidget/NotificationBadge.dart';
import 'package:vibration/vibration.dart';


/**
 * 테스트 모듈
 * desc: 테스트 모듈, prod시 사용하지 말것
 * */

/**
 * 메모장
 * https://blog.logrocket.com/flutter-push-notifications-with-firebase-cloud-messaging/
 * https://console.firebase.google.com/u/1/project/studioxrainvow/notification/compose
 * */


class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        title: 'Notify',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        debugShowCheckedModeBanner: false,
        home: TestScreen2(),
      ),
    );
  }
}


class TestScreen2 extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<TestScreen2> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notify'),
        brightness: Brightness.dark,
      ),
      body: Container(

      ),
    );
  }
}