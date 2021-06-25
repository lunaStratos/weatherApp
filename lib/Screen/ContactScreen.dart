import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/**
 * 고객접촉
 * */
class ContactScreen extends StatefulWidget {

  @override
  ContactScreenState createState() => ContactScreenState();

}

class ContactScreenState extends State<ContactScreen>{

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10.0),
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        ),
      ),
      /**
       * 웹뷰
       * */
      child: new WebView(
        initialUrl: 'http://rainvow.net/communication/contactUs',
        javascriptMode: JavascriptMode.unrestricted,
        gestureNavigationEnabled: true,
      ),
    );
  }

}