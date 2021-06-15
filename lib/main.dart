import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rainvow_mobile/Domain/FavoriteDomain.dart';
import 'package:rainvow_mobile/SideBar/Home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:rainvow_mobile/Util/Dependencys.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  late SharedPreferences prefs;
  bool flag = false;

  Future<List<FavoriteDomain>> _loadFavoriteLocationData() async{
    prefs = await SharedPreferences.getInstance();
    var getList = await prefs.getStringList('favoriteLocation') ?? [];
    return getList.map((item) => FavoriteDomain.fromJson(jsonDecode(item))).toList();
  }

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {


    return new MaterialApp(
      title: 'NavigationDrawer',

      home: new FutureBuilder(
          future: _loadFavoriteLocationData(),
          builder: (context, snapshot) {
            if(snapshot.data == null){
              return Container();
            }else{
              return new HomePage(index: 0, action: "real");
            }

          }
      )

    );


  }
}