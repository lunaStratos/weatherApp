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

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
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
   * int요일 => str요일
   * 주간예보 에서 사용
   * */
  static String dayStr(week){

    String str = "";

    switch(week){
      case 1: {
        str = "월";
      } break;
      case 2: {
        str = "화";
      } break;
      case 3: {
        str = "수";
      } break;
      case 4: {
        str = "목";
      } break;
      case 5: {
        str = "금";
      } break;
      case 6: {
        str = "토";
      } break;
      case 7: {
        str = "일";
      } break;
    }
    return str;
  }

  /**
   * 중기예보 => 이미지 주소
   * 중기예보 날씨상황 그림에서 사용
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
   * 메인날씨 그림 표시
   * */
  static String kmaNowImgAddress(weather_conditions) {
  String result = "";
  print("weather_conditions ${weather_conditions}");
  switch (weather_conditions){
  case "0":{  // 맑음
    result = "assets/images/weather_sun.png";
  }   break;
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
    }
  }
  return result;
}


  /**
   * 미세먼지 => 이미지 주소
   * 날씨바 미세먼지, 초미세먼지에 사용
   * */
  static String airGradeImgAddress(str){
  String result = "";
  switch (str){
  case "좋음" :
    {
      result = "assets/images/dust_good.png";
    }    break;
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
   * 단기예보에 사용, 기상청 1시간, 3시간(동네예보)에 적용가능
   * */
  static String kmaForecastImg(weatherType, rainfallType){
  String result = "";

  if(int.parse(rainfallType) == 0){
  //강우상태 : 없음(0) 이면 weatherType을 따른다
    switch (weatherType){
      case "1": // 맑음
        {
          result = "assets/images/weather_sun.png";
        }  break;
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
   * 기상청 1시간, 레인보우-기상청 그래프 API 에서 사용
   * */
  static String dateNowStr(){
      String str = "";
      DateTime date = new DateTime.now();

      String month = Util.trans2Digit(date.month);
      String day = Util.trans2Digit(date.day);
      String hour = Util.trans2Digit(date.hour);

      str = '${date.year}${month}${day}${hour}0000';

      return  str;
  }

  /**
   * 현재시각 불러오기
   * 형태 : yyyyMMdd
   * 기상청 3시간(동네예보), 레인보우-기상청 그래프 API 에서 사용
   * */
  static String dateNowyyyyMMddStr(){
    String str = "";
    DateTime date = new DateTime.now();

    String month = Util.trans2Digit(date.month);
    String day = Util.trans2Digit(date.day);
    String hour = Util.trans2Digit(date.hour);

    str = '${date.year}${month}${day}';

    return  str;
  }

  /**
   * 현재시각 불러오기
   * 형태 : HHmmSS
   * 기상청 3시간(동네예보), 레인보우-기상청 그래프 API 에서 사용
   * */
  static String dateNowHHmmSSStr(){
    String str = "";
    DateTime date = new DateTime.now();

    String month = Util.trans2Digit(date.month);
    String day = Util.trans2Digit(date.day);
    String hour = Util.trans2Digit(date.hour);

    str = '${hour}00';

    return  str;
  }

  /**
   * 시분을 utc 시각으로 변경하기
   * 형태 : HH:mm
   * */
  static String utcTime(hour, minute){

    DateTime date = new DateTime(2020, 1, 13, hour, minute).subtract(Duration(minutes: DateTime.now().timeZoneOffset.inMinutes.toInt()));
    String utcResult = "${trans2Digit(date.hour)}:${trans2Digit(date.minute)}";

    return utcResult;
  }

  /**
   * 시 분의 1자리를 2자리로 바꾸는 기능
   * 많은곳에서 사용하니 수정하지 말것!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   * */
  static String trans2Digit(int hm){
    String str = hm.toString().length == 1? "0${hm}" : hm.toString();
    return str;
  }

}
