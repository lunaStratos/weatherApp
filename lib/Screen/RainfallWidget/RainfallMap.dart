import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/**
 * 강우지도 - 6. 강우지도
 * desc: 모바일 웹 강우지도 표시
 * 웹뷰 - 위경도를 파라메터로 날린후 사용.
 * */
class RainfallMap extends StatefulWidget {

  @override
  RainfallMapState createState() => RainfallMapState(longitude: longitude, latitude: latitude);

  String longitude = "";
  String latitude = "";

  RainfallMap({required this.longitude, required this.latitude});

}

class RainfallMapState extends State<RainfallMap>{

  String longitude = "";
  String latitude = "";
  RainfallMapState({required this.longitude, required this.latitude});


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10.0),
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        ),
      ),

      // child: WebView(
      //   initialUrl: 'http://rainvow.net/demo?longitude=${longitude}&latitude=${latitude}',
      //   javascriptMode: JavascriptMode.unrestricted,
      //   gestureNavigationEnabled: true,
      // ),

      // child: WebviewScaffold(
      //   url: 'https://www.google.com/',
      //   useWideViewPort: true,
      //   withOverviewMode: true,
      // ),
      child: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse("http://rainvow.net/demo?longitude=${longitude}&latitude=${latitude}")),

      ),


    );
  }

}