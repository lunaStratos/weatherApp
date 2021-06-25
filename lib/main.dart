import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rainvow_mobile/Domain/FavoriteDomain.dart';
import 'package:rainvow_mobile/Domain/PushNotification.dart';
import 'package:rainvow_mobile/Screen/RainfallWidget/NotificationBadge.dart';
import 'package:rainvow_mobile/SideBar/Home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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

  late final FirebaseMessaging _messaging;
  late int _totalNotifications;
  PushNotification? _notificationInfo;

  void initState() {
    _totalNotifications = 0;
    registerNotification();
    checkForInitialMessage();

    // For handling notification when the app is in background
    // but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );

      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    });

    super.initState();
  }

  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
      );
      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    }
  }

  void registerNotification() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp();

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;
// Add the following line
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      // TODO: handle the received notifications
      // For handling the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );
        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });

        if (_notificationInfo != null) {
          // For displaying the notification as an overlay

          showSimpleNotification(
            Text(_notificationInfo!.title!),
            leading: NotificationBadge(totalNotifications: _totalNotifications),
            subtitle: Text(_notificationInfo!.body!),
            background: Colors.cyan.shade700,
            duration: Duration(seconds: 2),
          );
        }
      });


      _messaging.getToken().then((token){
        print('token : ${token} /');
        prefs.setString("fcmToken", token.toString());
      });


    } else {
      print('User declined or has not accepted permission');
    }
  }


  @override
  Widget build(BuildContext context) {


    return new MaterialApp(
      title: 'NavigationDrawer',
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white
      ),
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