import 'dart:convert';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rainvow_mobile/Domain/DustDomain.dart';
import 'package:rainvow_mobile/Domain/FavoriteDomain.dart';
import 'package:rainvow_mobile/Domain/KmaNowDomain.dart';
import 'package:rainvow_mobile/Screen/AlertWidget/AlertImage.dart';
import 'package:rainvow_mobile/Screen/AlertWidget/LoadingWidget.dart';
import 'package:rainvow_mobile/Screen/RainfallWidget/MainWeather.dart';
import 'package:rainvow_mobile/Screen/RainfallWidget/RainfallForecast.dart';
import 'package:rainvow_mobile/Screen/RainfallWidget/ShortForcast.dart';
import 'package:rainvow_mobile/Screen/RainfallWidget/SunRiseWidget.dart';
import 'package:rainvow_mobile/Screen/RainfallWidget/WeatherBar.dart';
import 'package:rainvow_mobile/Screen/RainfallWidget/WeatherMap.dart';
import 'package:rainvow_mobile/Screen/RainfallWidget/WeekForecast.dart';
import 'package:rainvow_mobile/Util/ApiCall.dart';
import 'package:rainvow_mobile/Util/Util.dart';
import 'package:shared_preferences/shared_preferences.dart';

/**
 * 강우지도 화면
 * desc: 강우지역 정보
 * 저장소이름: favoriteLocation
 * */
class WeatherScreen extends StatefulWidget {

  int idx = 0;
  WeatherScreen({required this.idx});

  @override
  _WeatherScreenState createState() => _WeatherScreenState(idx: idx);

}

class _WeatherScreenState extends State<WeatherScreen> {
  int idx = 0;
  _WeatherScreenState({required this.idx});

  bool flag = false;
  List<bool> allFlag = [false, false];

  late SharedPreferences prefs;

  final List<int> showIndexes = const [1, 3, 5];

  // 현재 Screen index
  int _current = 0;

  List<LineChartBarData> tooltipsOnBar = [];
  double weekForecastHeightSize = 275;

  /**
   * =========== 저장 메모리 리스트 ===========
   * */
  // 저장한 지역 => 앱 저장소에서 추출
  List<FavoriteDomain> favoriteArray = [];

  // 현재날씨
  List<KmaNowDomain> getKmaNowWeatherList = [];

  // 미세먼지
  List<DustDomain> getKmaNowDustList = [];

  /**
   * =========== 저장 메모리 리스트 ===========
   * */

  @override
  initState(){
    super.initState();
    _loadFavoriteLocationData().then((value) async{
      print('value ${value}');
          }).then((value) => {
      print('value ${value}')
    });
    if(idx < 0 ){
      setState(() {
        _current = 0;
      });
    }else{
      setState(() {
        _current = idx;
      });
    }
    print("_current ${_current} ${idx}");


  }

  /**
   * 읽기
   * desc: 관심지역과 현위치 권한을 앱저장소로 부터 읽는다.
   * */
  Future<List<FavoriteDomain>>  _loadFavoriteLocationData() async{
    prefs = await SharedPreferences.getInstance();
    final getLocationPermission = prefs.getBool('locationPermission') ?? false;
    var getList = await prefs.getStringList('favoriteLocation') ?? [];
    print('_loadFavoriteLocationData ${getList} ${getList.isNotEmpty} ${getLocationPermission}');


    if(idx < 0){
      if(getLocationPermission){
        favoriteArray = await _getPosition();
        setState(() {
          favoriteArray;
        });
        return favoriteArray;
      }else{
        showDialog(context: context, builder:
            (BuildContext context) {
          return AlertImage(title: "권한이 없습니다.", contents: "위치권한이 없습니다. 설정 -> 위치권한을 활성화 시켜 주십시오.", switchStr: "location");
        }
        );
        return getList.map((item) => FavoriteDomain.fromJson(jsonDecode(item))).toList();
      }

    }else{

      if( getList.isNotEmpty) {
        setState(() {
          favoriteArray = getList.map((item) => FavoriteDomain.fromJson(jsonDecode(item))).toList();
        });
        return getList.map((item) => FavoriteDomain.fromJson(jsonDecode(item))).toList();

      }else{

        if(getLocationPermission){
          favoriteArray = await _getPosition();
          setState(() {
            favoriteArray;
          });
          return favoriteArray;
        }else{
          showDialog(context: context, builder:
              (BuildContext context) {
            return AlertImage(title: "권한이 없습니다.", contents: "위치권한이 없습니다. 설정 -> 위치권한을 활성화 시켜 주십시오.", switchStr: "location");
          }
          );
          return getList.map((item) => FavoriteDomain.fromJson(jsonDecode(item))).toList();
        }


      }


    }

  }


  /**
   * 현위치 클릭
   * */
  Future<List<FavoriteDomain>> _getPosition() async{
    var result = await Util().determinePosition() as Position;
    String latitude = result.latitude.toString();
    String longitude = "127"; //result.longitude.toString();
    var resultMylocaion = await ApiCall.getMylocationInfo(longitude, latitude);

    var result2 = resultMylocaion;
    String kma_point_id = result2['kma_point_id'];
    String rect_id = result2['rect_id'];
    String kmaX  = result2['kmaX'];
    String kmaY = result2['kmaY'];

    //이름 현위치 고정
    favoriteArray.add(
        FavoriteDomain(address: "현위치", dongName: "", longitude: longitude,
            latitude: latitude, kmaX: kmaX, kmaY: kmaY, rect_id: rect_id,
            kma_point_id: kma_point_id, weatherDescription: "", weatherConditions: "",
            rainfallAmount: "", celsius: "20", imgSrc: "", alarmTime: "0800", use: true)
    );

    print('fDomain : ${favoriteArray[0].kma_point_id}');

    return favoriteArray;

  }

  /**
   * 현재날씨 API 불러오기
   * */
  Future <KmaNowDomain> _getKmaNowWeatherApi(rect_id, index) async {
    final resultObj = await ApiCall.getNowKmaWeather(rect_id);
    final getDomain = KmaNowDomain.fromJson(resultObj);
    print('resultObj Now ${rect_id} ${resultObj}  ');

    if(getKmaNowWeatherList.asMap()[index] == null ){
      getKmaNowWeatherList.add(getDomain);
    }else{
      getKmaNowWeatherList[index] = getDomain;
    }
    return getDomain;
  }

  /**
   * 현재 미세먼지 API 불러오기
   * */
  Future <DustDomain> _getKmaNowDustApi(rect_id, longitude, latitude, index) async {
    final resultObj = await ApiCall.getNowDust(rect_id, longitude, latitude);
    print('resultObj ${resultObj}');
    final getDomain = DustDomain.fromJson(resultObj);

    if(getKmaNowDustList.asMap()[index] == null ){
      getKmaNowDustList.add(getDomain);
    }else{
      getKmaNowDustList[index] = getDomain;
    }

    return getDomain;

  }

  /**
   *
   * */
  Future _changedCarouSel(index) async{
    _getKmaNowDustApi(favoriteArray[index].rect_id, favoriteArray[index].longitude, favoriteArray[index].latitude, index);
    _getKmaNowWeatherApi(favoriteArray[index].rect_id, index);
  }



  @override
  Widget build(BuildContext context) {
    print('idx => ${idx}');
    print('init start ${flag}');
    print('favoriteArray.length ==?> ${favoriteArray.length} ');
    print('getKmaNowWeatherList ==?> ${getKmaNowWeatherList.length} ');
    print('getKmaNowDustList ==?> ${getKmaNowDustList.length} ');


    /**
     * DESC : [idx]
     * -1 현위치
     * -2 현위치 버튼 (새창)
     * */
    if(idx == -1){
      return Scaffold(
          body: _buildStack(context)
      );
    }else if(idx == -2){
      return Scaffold(
          appBar: AppBar(
            title: Text('현위치'),
            centerTitle: true,
          ),
          body: _buildStack(context)
      );
    }else{
      return Scaffold(
          body: _buildStack(context)
      );
    }


  }

  Stack _buildStack(BuildContext context){


    return new Stack(
        children: [
          CarouselSlider(
            items: _buildScreen(context)
            /**
             * 아이템 for문 들어감
             * */
            ,
            options: CarouselOptions(
              autoPlay: false,
              height: MediaQuery.of(context).size.height, // 풀사이즈
              viewportFraction: 1,                        // 풀사이즈(양옆이 안보이게 함)
              enableInfiniteScroll: false,                // 무한스크롤 없엠
              /**
               * 페이지 변경시 index 저장
               * */
              onPageChanged: (index, reason) {
                print('index ${index}');
                _changedCarouSel(index);
                setState(() {
                  _current = index;
                });
              },
              initialPage: _current+1
            ),
          ),

          new Center(
            child:  new Container(
                child: _buildDots(context)
            ),
          )
        ]
    );
  }
  /**
   * 점 찍기
   * */
  Widget _buildDots(BuildContext context){
    var xScreen;
    
    if(favoriteArray.length == 0 ){
      xScreen = Container(
        constraints: BoxConstraints(
            maxHeight: 400.0,
            maxWidth: 300.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/no_permission_test.jpg'),
            Container(
              child: Text(
                '관심지역 → 도로명을 검색하여 위치를 추가해 주십시오',
                style: TextStyle(fontSize: 20, ),
              ),


            ),

          ],
        ),
      );
    }else{

        xScreen = DotsIndicator(
            dotsCount: favoriteArray.length,
            position: _current.toDouble(),
            decorator: DotsDecorator(
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
            onTap: (position) {
              print('position ${position}');
              setState(() =>
              _current = position.toInt()
              );
            }
        );

    }

    return xScreen;
  }



  /**
   * 메인화면 구성.
   * */
  List<Widget> _buildScreen(BuildContext context){
    List<Widget> screenList = [];


      for(int i = 0 ; i< favoriteArray.length; i++){

        var screenX = new Container(

          child: SingleChildScrollView(
            child: new Container(
                color: Colors.blueGrey[100],
                child: new Column(
                  children: [
                    new Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // horizontal : 왼쪽 오른쪽띄우기, vertical: 위아래 띄우기
                        child: new Container(
                          child: new Column(
                            children: [
                              /**
                               * =======================[1. 메인날씨 ]=====================
                               * */

                              Container(
                                height: 440,
                                child: FutureBuilder(
                                  future: _getKmaNowWeatherApi(favoriteArray[i].rect_id,i),
                                  builder: (context, snapshot1) {

                                    if (snapshot1.hasData == false) {
                                      return LoadingWidget();
                                    }else{

                                      final body = snapshot1.data as KmaNowDomain;

                                      return FutureBuilder(
                                        future: _getKmaNowDustApi(favoriteArray[i].rect_id, favoriteArray[i].longitude, favoriteArray[i].latitude, i),
                                        builder: (context, snapshot2) {

                                          if (snapshot2.hasData == false) {
                                            return LoadingWidget();
                                          }else{

                                            final dustBody = (getKmaNowDustList.asMap()[i] == null) ? snapshot2.data as DustDomain: getKmaNowDustList[i];

                                            return new Column(
                                              children: [
                                                Text('${favoriteArray[i].address}'),
                                                MainWeather(
                                                    rect_id : favoriteArray[i].rect_id,
                                                    kmaNowWeatherObject: body
                                                ),
                                                /**
                                                 * =======================[2.날씨바]=====================
                                                 * */
                                                WeatherBar(
                                                    rect_id: favoriteArray[i].rect_id,
                                                    kmaNowWeatherObject: getKmaNowWeatherList[i],
                                                    kmaNowDustObject: dustBody
                                                )
                                              ],
                                            );
                                          }

                                        },
                                      );
                                    }
                                  },

                                ),
                              ),




                              SizedBox(
                                height: 15,
                                width: 1,
                              ),
                              /**
                               * =======================[3. 단기예보]=====================
                               * */
                              ShortForecast(rect_id:favoriteArray[i].rect_id),
                              SizedBox(
                                height: 15,
                                width: 1,
                              ),
                              /**
                               * =======================[4.강수예보 그래 ]=====================
                               * */
                              RainfallForecast(rect_id: favoriteArray[i].rect_id),

                              /**
                               * =======================[5. 주간예보]=====================
                               * */
                              SizedBox(
                                height: 15,
                                width: 1,
                              ),
                              WeekForecast(rect_id: favoriteArray[i].rect_id),

                              /**
                               * =======================[6. 강우지도 : 웹뷰]=====================
                               * */
                              SizedBox(
                                height: 15,
                                width: 1,
                              ),
                              WeatherMap(longitude: favoriteArray[i].longitude, latitude:favoriteArray[i].latitude),

                              SizedBox(
                                height: 15,
                                width: 1,
                              ),
                              /**
                               * =======================[7. 일몰일출]=====================
                               * */
                              SizedBox(
                                height: 15,
                                width: 1,
                              ),

                              SunRiseWidget(longitude: favoriteArray[i].longitude, latitude:  favoriteArray[i].latitude),

                              SizedBox(
                                height: 15,
                                width: 1,
                              ),
                              Text('자료 기상청, 레인보우')
                            ],
                          ),
                        )

                    ),

                  ],
                )
            ),
          ),
        );

        screenList.add(screenX);
      }

      return screenList;
  }




}
