import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

/**
 * 각종 Util 모음
 * */
class Util {


  /**
   * 위치정보 가져오기
   * */
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    final result = await Geolocator.getCurrentPosition() as Position;

    return result;
  }

  /**
   * int 요일 => str요일 
   * */
  static String dayStr(week){

    String str = "";

    switch(week){
      case 1: {
        str = "월";
      }
      break;
      case 2: {
        str = "화";
      }
      break;
      case 3: {
        str = "수";
      }
      break;
      case 4: {
        str = "목";
      }
      break;
      case 5: {
        str = "금";
      }
      break;
      case 6: {
        str = "토";
      }
      break;
      case 7: {
        str = "일";
      }
      break;

    }
    return str;
  }

  /**
   * 중기예보 => 이미지 주소
   * */
  static String weekImageAddress(weekStr){

    String str = "";
    switch(weekStr){
      case "맑음": {
        str = "assets/images/weather_sun.png";
      }
      break;
      case "구름많음": {
        str = "assets/images/weather_suncloud.png";
      }
      break;
      case "구름많고 비": {
        str = "assets/images/weather_rain.png";
      }
      break;
      case "구름많고 비/눈": {
        str = "assets/images/weather_rainsnow.png";
      }
      break;
      case "구름많고 소나기": {
        str = "assets/images/weather_rainfall.png";
      }
      break;
      case "흐림": {
        str = "assets/images/weather_cloud.png";
      }
      break;
      case "흐리고 비": {
        str = "assets/images/weather_rain.png";
      }
      break;
      case "흐리고 비/눈": {
        str = "assets/images/weather_snowrain.png";
      }
      break;
      case "흐리고 소나기": {
        str = "assets/images/weather_rainfall.png";
      }
      break;
      case "소나기": {
        str = "ssets/images/weather_rainfall.png";
      }
      break;
    }
    return str;
  }



  /**
   * 메인날씨 => 이미지 주소
   * */
  static String kmaNowImgAddress(weather_conditions) {
  String result = "";
  print("weather_conditions ${weather_conditions}");
  switch (weather_conditions){
  case "0":{
    result = "assets/images/weather_sun.png";
  }   // 맑음
  break;
  case "1":   // 비
    {
      result = "assets/images/weather_rain.png";
    }  break;
  case "2":   // 비/눈 === 진눈개비
    {
      result = "assets/images/weather_rainsnow.png";
    }  break;
  case "3":   // 눈
    {
      result = "assets/images/weather_snow.png";
    }  break;
  case "4":   // 소나기
    {
      result = "assets/images/weather_rainfall.png";
    }  break;
  case "5":   // 빗방울
    {
      result = "assets/images/weather_rain.png";
    }  break;
  case "6":   // 빗방울 눈날림
        {
    result = "assets/images/weather_rainsnow.png";
    }  break;
  case "7":   // 눈날림
        {
    result = "assets/images/weather_snow.png";
    }  break;
  default:
    {
    result = "";
    }  }


  return result;
}


  /**
   * 미세먼지 => 이미지 주소
   * */
  static String airGradeImgAddress(str){
  String result = "";
  switch (str){
  case "좋음" :
    {
      result = "assets/images/dust_good.png";
    }
  break;
  case "보통" :
    {
      result = "assets/images/dust_normal.png";
    }    break;
  case "나쁨" :
    {
      result = "assets/images/dust_bad.png";
    }    break;
  case "매우나쁨" :
    {
      result = "assets/images/dust_verybad.png";
    }    break;
  }
  return result;
}


  /**
   * 예보 => 이미지 주소
   * */
  static String kmaForecastImg(weatherType, rainfallType){
  String result = "";

  if(int.parse(rainfallType) == 0){
  //강우상태 : 없음(0) 이면 weatherType을 따른다
    switch (weatherType){
      case "1": // 맑음
        {
          result = "assets/images/weather_sun.png";
        }
      break;
      case "3": // 구름많음
        {
          result = "assets/images/weather_suncloud.png";
        }  break;
      case "4": // 흐림
        {
          result = "assets/images/weather_cloud.png";
        }  break;
    }

  }else{

    //강우상태가 없음(0)이 아니면 상태가 있음.
    switch (rainfallType){
      case "1":   // 비
        {
          result = "assets/images/weather_rain.png";
        }  break;
      case "2":   // 비/눈 === 진눈개비
        {
          result = "assets/images/weather_rainsnow.png";
        }  break;
      case "3":   // 눈
        {
          result = "assets/images/weather_snow.png";
        }  break;
      case "4":   // 소나기
        {
          result = "assets/images/weather_rainfall.png";
        }  break;
      case "5":   // 빗방울
        {
          result = "assets/images/weather_rain.png";
        }  break;
      case "6":   // 빗방울 눈날림
        {
          result = "assets/images/weather_snowrain.png";
        }  break;
      case "7":   // 눈날림
        {
            result = "assets/images/weather_snow.png";
        }  break;
      }

    }
    return result;
  }

  /**
   * 현재시각 불러오기
   * 형태 : yyyyMMddHHmmSS
   * */
  static String dateNowStr(){
      String str = "";
      DateTime date = new DateTime.now();

      String month = (date.month).toString().length == 1 ? "0${date.month}" : date.month.toString();
      String day = (date.day).toString().length == 1 ? "0${date.day}" : date.day.toString();
      String hour = (date.hour).toString().length == 1 ? "0${date.hour}" : date.hour.toString();

      str = '${date.year}${month}${day}${hour}0000';

      return  str;
  }

  /**
   * 시분을 utc 시각으로 변경하기
   * 형태 : HH:mm
   * */
  static String utcTime(hour, minute){

    DateTime date = new DateTime(2020, 1, 13, hour, minute).subtract(Duration(minutes: DateTime.now().timeZoneOffset.inMinutes.toInt()));
    String utcResult = "${date.hour.toString().length ==1 ? '0${date.hour}' : date.hour}:${date.minute.toString().length ==1 ? '0${date.minute}' : date.minute}";

    return utcResult;
  }

}
