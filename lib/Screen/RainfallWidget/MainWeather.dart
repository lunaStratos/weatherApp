import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainvow_mobile/Domain/KmaNowDomain.dart';
import 'package:rainvow_mobile/Util/Util.dart';

/**
 * 강우지도 - 1.메인날씨
 * */
class MainWeather extends StatefulWidget {

  String rect_id = "4102000004265";        // 날씨
  KmaNowDomain kmaNowWeatherObject;

  MainWeather({required this.rect_id, required this.kmaNowWeatherObject});

  @override
  _MainWeatherState createState() => _MainWeatherState(this.rect_id, this.kmaNowWeatherObject);

}

class _MainWeatherState extends State<MainWeather>{

  String rect_id = "4102000004265";
  KmaNowDomain kmaNowWeatherObject;

  String address = "";
  String temperature = "";
  String rainfall_rate = "";
  String weatherDesc = "";
  String weatherPredictDesc = "맑음";

  _MainWeatherState(this.rect_id, this.kmaNowWeatherObject);


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    print('kmaNowWeatherObject temperature  ${kmaNowWeatherObject.temperature}');

    temperature = "${kmaNowWeatherObject.temperature}";
    rainfall_rate = "${kmaNowWeatherObject.rainfallRate}";
    weatherDesc = "${kmaNowWeatherObject.weatherConditionsKeyword}";

    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: new Column(
        children: [

          new Column(
            children: [
              /**
               * 14도, 구름많음
               * */
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Text('${temperature}도', style: TextStyle(fontSize:60),),
                  ),
                  new Column(
                    children: [
                      Text('${weatherDesc}', style: TextStyle(fontSize: 20) ),
                      Text('어제보다 4도 높아요', style: TextStyle(fontSize: 12)),
                      Text('체감온도 -4도', style: TextStyle(fontSize: 12)),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 15,
                width: 1,
              ),
              SizedBox(
                height: 100,
                width: 100,
                child: Image.asset('${Util.kmaNowImgAddress(kmaNowWeatherObject.weatherConditions)}'),
              ),
              SizedBox(
                height: 15,
                width: 1,
              ),
              Text('30분 후 ${weatherPredictDesc} 예정', style: TextStyle(fontSize: 25) ),
              SizedBox(
                height: 30,
                width: 1,
              ),
            ],

          ),





        ],
      ),
    );

  }

}