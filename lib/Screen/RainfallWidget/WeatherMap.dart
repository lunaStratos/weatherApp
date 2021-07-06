import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


/**
 * 강우지도 - 6. 강우지도
 * desc: 모바일 웹 강우지도 표시
 * 웹뷰 - 위경도를 파라메터로 날린후 사용.
 * */
class WeatherMap extends StatefulWidget {

  @override
  WeatherMapState createState() => WeatherMapState(longitude: longitude, latitude: latitude);

  String longitude = "";
  String latitude = "";

  WeatherMap({required this.longitude, required this.latitude});

}

class WeatherMapState extends State<WeatherMap>{

  String longitude = "";
  String latitude = "";
  WeatherMapState({required this.longitude, required this.latitude});


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(child:
        Container(
          /**
           * 사각 둥글게 radious
           * */
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
           * 웹뷰 설정
           * gestureNavigationEnabled
           * isApp에 값 있을때 App 모드의 웹으로 작동
           * */
          child: new WebView(
            initialUrl: 'http://rainvow.net/demo?longitude=${longitude}&latitude=${latitude}&isApp=true',
            javascriptMode: JavascriptMode.unrestricted,
            gestureNavigationEnabled: true,
          ),

        ),),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

}