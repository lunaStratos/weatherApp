import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';


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

  double height = 200.0; // starting height value
  var iconArrow = Icons.arrow_downward;
  bool openFlag = false;


  @override
  Widget build(BuildContext context) {

      return Scaffold(
        appBar: AppBar(
          title: Text('test'),
          brightness: Brightness.light,
        ),
          body: Container(

            child:

            Container(
                height: height,
                decoration: BoxDecoration(
                    border:
                    Border(top: BorderSide(color: Theme.of(context).dividerColor))),
                child: Row(children: [
                  Expanded(
                      child:  Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text('Some text here!'),
                      )
                  ),
                  Expanded(
                    child: IconButton(
                        icon: Icon(iconArrow),
                        // color: themeData.primaryColor,
                        onPressed: () => _onPressed(context)
                    ),
                  ),
                ]))




        ),
    );
  }

  _onPressed(BuildContext context) {
    var x = context.widget;
    if(openFlag){
      setState(() {
        height = 200.0; // new height value
        iconArrow = Icons.arrow_downward;
        openFlag = false;
      });
    }else{
      setState(() {
        height = 400.0; // new height value
        iconArrow = Icons.arrow_upward;
        openFlag = true;
      });
    }

  }
}