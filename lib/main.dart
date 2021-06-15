import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rainvow_mobile/SideBar/Home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:rainvow_mobile/Util/Dependencys.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    runApp(
    new MyApp()
    );
}


class MyApp extends StatefulWidget {

  MyAppState createState() => MyAppState();

}

class MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      title: 'NavigationDrawer',
      // theme: new ThemeData(
      //   primarySwatch: Colors.deepOrange,
      // ),
      home: new HomePage(index: -100,),
    );
  }
}