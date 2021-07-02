import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainvow_mobile/Domain/DustDomain.dart';
import 'package:rainvow_mobile/Domain/KmaNowDomain.dart';
import 'package:rainvow_mobile/Util/Util.dart';

/**
 * 강우지도 - 2.날씨바
 * */
class WeatherBar extends StatefulWidget {

  String rect_id = "4102000004265";        // 날씨
  KmaNowDomain kmaNowWeatherObject;
  DustDomain kmaNowDustObject;

  WeatherBar({required this.rect_id, required this.kmaNowWeatherObject, required this.kmaNowDustObject,});

  @override
  _WeatherBarState createState() => _WeatherBarState(this.rect_id, this.kmaNowWeatherObject, this.kmaNowDustObject);

}

class _WeatherBarState extends State<WeatherBar>{

  String rect_id = "4102000004265";
  KmaNowDomain kmaNowWeatherObject;
  DustDomain kmaNowDustObject;

  var rainfall_rate = "";
  var temperature = "";
  var humidity = "";
  var windStrength = "";
  var windStrengthDesc = "";
  var pm10Desc = "0";
  var pm25Desc = "0";

  _WeatherBarState(this.rect_id, this.kmaNowWeatherObject , this.kmaNowDustObject);


  @override
  void initState() {
  }


  @override
  Widget build(BuildContext context) {
    kmaNowWeatherObject = widget.kmaNowWeatherObject;

    temperature = "${kmaNowWeatherObject.temperature}";
    rainfall_rate = "${kmaNowWeatherObject.rainfallRate}";
     humidity = "${kmaNowWeatherObject.humidity}";
     windStrength = "${kmaNowWeatherObject.windStrengthCode}";
     windStrengthDesc = "${ kmaNowWeatherObject.windStrengthCodeDescription}";
     pm10Desc = "${ kmaNowDustObject.pm10grade}";
     pm25Desc = "${ kmaNowDustObject.pm25grade}";

    return new Container(
      decoration: BoxDecoration(

        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10.0),
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            /**
             * 비올확률
             * */
            new Padding(
              padding: EdgeInsets.all(3),
              child: new Column(
                children: [
                  Text('비올확률'),
                  Image.asset('assets/images/umbrella.png', width: 40, height: 40,),
                  Text('${rainfall_rate}%'),
                ],
              ),
            ),
            /**
             * 습도
             * */
            Container(
              width: 1,
              height: 45,
              color: Colors.grey,
            ),
            new Padding(
              padding: EdgeInsets.all(2),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('습도'),
                  Image.asset('assets/images/humidity.png', width: 40, height: 40,),
                  Text('${humidity}%'),
                ],
              ),
            ),
            /**
             * 바람세기
             * */
            Container(
              width: 1,
              height: 45,
              color: Colors.grey,
            ),
            new Padding(
              padding: EdgeInsets.all(2),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('바람'),
                  Image.asset('assets/images/wind.png', width: 40, height: 40,),
                  Text('${windStrengthDesc}'),
                ],
              ),
            ),
            /**
             * 미세먼지 그림
             * */
            Container(
              width: 1,
              height: 45,
              color: Colors.grey,
            ),
            new Padding(
              padding: EdgeInsets.all(2),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('미세먼지'),
                  Image.asset('${Util.airGradeImgAddress(pm25Desc)}', width: 40, height: 40,),
                  Text('${pm10Desc}'),
                ],
              ),
            ),
            /**
             * 초미세먼지 그림
             * */
            Container(
              width: 1,
              height: 45,
              color: Colors.grey,
            ),
            new Padding(
              padding: EdgeInsets.all(2),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('초미세먼지'),
                  Image.asset('${Util.airGradeImgAddress(pm10Desc)}', width: 40, height: 40,),
                  Text('${pm25Desc}'),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }



}