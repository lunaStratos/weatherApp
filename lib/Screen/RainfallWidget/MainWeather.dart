import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainvow_mobile/Domain/KmaNowDomain.dart';
import 'package:rainvow_mobile/Screen/DecorationWidget/AnimatedImage.dart';
import 'package:rainvow_mobile/Util/ApiCall.dart';
import 'package:rainvow_mobile/Util/Util.dart';

/**
 * 강우지도 - 1.메인날씨
 * */
class MainWeather extends StatefulWidget {

  String rect_id = "4102000004265";        // 날씨
  KmaNowDomain kmaNowWeatherObject;
  String dongName = "현위치";

  MainWeather({required this.rect_id, required this.kmaNowWeatherObject, required this.dongName});

  @override
  _MainWeatherState createState() => _MainWeatherState(this.rect_id, this.kmaNowWeatherObject, this.dongName);

}

class _MainWeatherState extends State<MainWeather>{

  String rect_id = "4102000004265";
  KmaNowDomain kmaNowWeatherObject;
  double effectDouble = 0.0;
  String address = "";
  String temperature = "";
  String rainfall_rate = "";
  String weatherDesc = "";
  String weatherPredictDesc = "맑음";
  String dongName = "현위치";


  _MainWeatherState(this.rect_id, this.kmaNowWeatherObject, this.dongName);

  Future _callWeather3Hour()async{
    final resultArray = await ApiCall.getWeatherForecast(rect_id);

    if(resultArray.isNotEmpty){
      weatherPredictDesc = resultArray[0]['weatherTypeDescription'];
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      effectDouble = 1.0;
    });

  }


  @override
  Widget build(BuildContext context) {
    _callWeather3Hour();
    kmaNowWeatherObject = widget.kmaNowWeatherObject;
    temperature = "${kmaNowWeatherObject.temperature}";
    rainfall_rate = "${kmaNowWeatherObject.rainfallRate}";
    weatherDesc = "${kmaNowWeatherObject.weatherConditionsKeyword}";
    String windStrengthCodeDescription = "${kmaNowWeatherObject.windStrengthCodeDescription}";
    String rainfallRate = "${kmaNowWeatherObject.rainfallRate}";
    String rainfallAmount = kmaNowWeatherObject.rainfallRate != 0 ? "/ 현재 강우량: ${kmaNowWeatherObject.rainfallAmount}mm" : "";

    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: new Column(
        children: [

          new Column(
            children: [
              /**
               * 동이름
               * */
              Text('${dongName}', style: TextStyle(fontSize: 20),),

              /**
               * 온도, 날씨, 바람강도, 비올확률
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
                      Text('바람강도: ${windStrengthCodeDescription}', style: TextStyle(fontSize: 12)),
                      Text('비올확률 ${rainfallRate} ${rainfallAmount}%', style: TextStyle(fontSize: 12)),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 15,
                width: 1,
              ),
              /**
               * 날씨 이미지 표시 부분
               * */
              SizedBox(
                height: 150,
                width: 150,
                child: AnimatedImage(weatherConditions: kmaNowWeatherObject.weatherConditions),
              ),
              SizedBox(
                height: 15,
                width: 1,
              ),
              /**
               * 3시간 후 예정
               * */
              Text('약 3시간 후 ${weatherPredictDesc} 예정', style: TextStyle(fontSize: 25) ),
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