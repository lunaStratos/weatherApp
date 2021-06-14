import 'package:rainvow_mobile/Util/Api.dart';
import 'package:rainvow_mobile/Util/Util.dart';

/**
 * Api List 모음
 * 여기서 Api 추가해서 사용
 * */
class ApiCall {

  /**
   * 주소지 찾기 기능
   * rect_id, kma_point_id, kmaX, kmaY 추가
   * 관심지역 찾기시 사용
   * */
  static Future<List> getFavoriteSearchList(searchLocationText) async{
      String address = 'http://rainvow.net/api/service/appapi/address-search-app?address='+searchLocationText;
      //String address = 'http://rainvow.net/api/service/weather/weather-address-search-app?address='+searchLocationText;
      final jsonArray = await Api.callapi(address);
      return jsonArray;
  }

  /**
   * 현위치의 rect_id, kma_point_id, kmaX, kmaY
   * 현위치 검색시 rect_id 사용
   * */
  static Future<dynamic> getMylocationInfo(longitude, latitude) async{
    String address = 'http://rainvow.net/api/service/appapi/rainvow-rectid-search?longitude=${longitude}&latitude=${latitude}';
    //String address = 'http://rainvow.net/api/service/weather/weather-mylocation-search?longitude=${longitude}&latitude=${latitude}';
    final jsonObj = await Api.callapiObject(address);
    return jsonObj;
  }

  /**====================================================[ 날씨 관련 api ]========================================================*/

  /**
   * 기상청 초단기 - 현재날씨
   * 현재날씨
   * */
  static Future<dynamic> getNowKmaWeather(rectid) async{
    print('rectid ${rectid}');
    String address = 'http://rainvow.net/api/service/appapi/kma-weather-now?rect_id=${rectid}';
    //String address = 'http://rainvow.net/api/service/weather/weather-kma-now-longlat?longitude=${longitude}&latitude=${latitude}';
    final jsonObject = await Api.callapiObject(address);
    return jsonObject;
  }

  /**
   * 미세먼지 - rect_id용
   * 날씨바 사용
   * */
  static Future<dynamic> getNowDust(rect_id, longitude, latitude) async{
    String address = 'http://rainvow.net/api/service/appapi/kma-weather-dust?rect_id=${rect_id}&longitude=${longitude}&latitude=${latitude}';
    //String address = 'http://rainvow.net/api/service/weather/weather-airkorea-dust?rect_id=${rect_id}';
    final jsonArray = await Api.callapiObject(address);
    return jsonArray;
  }

  /**
   * 3시간 단위 예보 - rect_id
   * 강수예보 그래프 사용
   * */
  static Future<List> getWeatherForecast(rect_id) async{
    String address = 'http://rainvow.net/api/service/appapi/kma-weather-3hour?rect_id=${rect_id}';
    //String address = 'http://rainvow.net/api/service/weather/weather-kma-forecast?rect_id=${rect_id}';
    final jsonArray = await Api.callapi(address);
    return jsonArray;
  }

  /**
   * 레인보우 예보 - rect_id, nowtime
   * 강수예보 그래프 사용
   * */
  static Future<List> getRainvowInfoForecast(rect_id) async{
    String address = 'http://rainvow.net/api/service/appapi/rainvow-weather-1hour?rect_id=${rect_id}&nowtime=${Util.dateNowStr()}';
    //String address = 'http://rainvow.net/api/service/weather/weather-rainvow-forecast?rect_id=${rect_id}&nowtime=${Util.dateNowStr()}';
    final jsonArray = await Api.callapi(address);
    return jsonArray;
  }


  /**
   * 1시간 단위 예보 - rect_id
   * 단기예보 표시
   * */
  static Future<List> getWeatherUltraForecast(rect_id) async{
    String address = 'http://rainvow.net/api/service/appapi/kma-weather-1hour?rect_id=${rect_id}';
    //String address = 'http://rainvow.net/api/service/weather/weather-kma-ultra-forecast-rectid?rect_id=${rect_id}';
    final jsonArray = await Api.callapi(address);
    return jsonArray;
  }


  /**
   * 중기예보 - 중기예보(날씨)
   * 주간예보 날씨[맑음]
   * 10일치 날씨 가져옴
   * */
  static Future<dynamic> getKmaMidTermForecast(rect_id) async{
    String address = 'http://rainvow.net/api/service/appapi/kma-weather-midterm-weather?';
    //String address = 'http://rainvow.net/api/service/weather/weather-midterm-forecast?';
    address+= 'rect_id=${rect_id}';

    final jsonArray = await Api.callapi(address);
    return jsonArray;
  }

  /**
   * 중기예보 - 중기에보(온도)
   * 주간날씨 온도
   * 10일치 날씨 가져옴
   * */
  static Future<dynamic> getKmaMidTermForecastTemperature(rect_id) async{
    String address = 'http://rainvow.net/api/service/appapi/kma-weather-midterm-temperature?';
    //String address = 'http://rainvow.net/api/service/weather/weather-midterm-forecast-celsius?';
    address+= 'rect_id=${rect_id}';

    final jsonArray = await Api.callapi(address);
    return jsonArray;
  }

  /**
   * 일출일몰 api
   * 일출 일몰 시간 표시
   * 기상청 api 아님, 오류없음
   * */
  static Future<Map<String, dynamic>> getNowSunSet(longitude, latitude) async{
    DateTime now = new DateTime.now();
    String month = now.month.toString().length == 1 ? '0${now.month.toString()}' : now.month.toString();
    String day = now.day.toString().length == 1 ? '0${now.day.toString()}' : now.day.toString();
    String nowDate = '${now.year}-${month}-${day}';
    String address = 'http://api.sunrise-sunset.org/json?lat=${latitude}&lng=${longitude}&date=${nowDate}&formatted=0';
    final jsonArray = await Api.callapiObject(address);
    var results = jsonArray['results'];
    String sunriseStr = results['sunrise'];
    String sunsetStr = results['sunset'];

    var sunrise = DateTime.parse(sunriseStr);
    var sunset = DateTime.parse(sunsetStr);

    sunrise = sunrise.add(const Duration(hours: 9));
    sunset = sunset.add(const Duration(hours: 9));

    String sunriseString = '${sunrise.year}-${sunrise.month}-${sunrise.day} ${sunrise.hour}:${sunrise.minute}:${sunrise.second}';
    String sunsetString = '${sunset.year}-${sunset.month}-${sunset.day} ${sunset.hour}:${sunset.minute}:${sunset.second}';

    Map<String, dynamic> resultArr = {'sunrise': sunriseString, 'sunset':sunsetString};

    return resultArr;

  }

  //
}
