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
import 'package:rainvow_mobile/Screen/RainfallWidget/WeekForecast.dart';
import 'package:rainvow_mobile/Util/ApiCall.dart';
import 'package:rainvow_mobile/Util/Dependencys.dart';
import 'package:rainvow_mobile/Util/Util.dart';
import 'package:shared_preferences/shared_preferences.dart';

/**
 * 강우지도 화면
 * desc: 강우지역 정보
 * 저장소이름: favoriteLocation
 * */
class WeatherScreen extends StatefulWidget {

  int idx = 0;
  String action = "real"; //clickMylocation, clickFavorite, real

  WeatherScreen({required this.idx, required this.action});

  @override
  _WeatherScreenState createState() => _WeatherScreenState(idx: idx, action: action);

}

class _WeatherScreenState extends State<WeatherScreen> {

  int count = 0;

  int idx = 0;
  String action = "real"; //clickMylocation, clickFavorite, real

  _WeatherScreenState({required this.idx, required this.action});

  bool flag = false; // _loadFavoriteLocationData 모두 로드되었을 때 true
  bool mylocationFlag = false;
  bool locationPermission = false;

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
      flag = true;
      });

    print('idx ${idx} ${action}');

    if(idx < 0 ){
      setState(() {
        _current = 0;
      });
    }else{
      /**
       * 특정 지역 조회시 사용
       * */
      if(action == "clickFavorite"){
        setState(() {
          _current = idx;
        });
      }else{
        setState(() {
          _current = 0;
        });
      }

    }


  }

  /**
   * 읽기
   * desc: 관심지역과 현위치 권한을 앱저장소로 부터 읽는다.
   * */
  Future<List<FavoriteDomain>> _loadFavoriteLocationData() async{
    prefs = await SharedPreferences.getInstance();
    final getLocationPermission = prefs.getBool('locationPermission') ?? false; // 권한
    var getList = await prefs.getStringList('favoriteLocation') ?? [];          // 저장된 지역 리스트 불러오기(String List)
    locationPermission = getLocationPermission;

    if(idx == -2){
      favoriteArray = await _getPosition();
      setState(() {
        favoriteArray;
        locationPermission = true;
      });
      return favoriteArray;

    }else{

      print('getList ${getList.length}');
      print('getLocationPermission ${getLocationPermission}');
      // 리스트가 있을 경우 리스트로 띄워줌
      if(getList.isNotEmpty) {
        favoriteArray = await _getPosition();

        var templist = getList.map((item) => FavoriteDomain.fromJson(jsonDecode(item))).toList();
        for(int i = 0 ; i < templist.length ; i++){
          favoriteArray.add(templist[i]);
        }

        setState(() {
          favoriteArray = favoriteArray;
        });

        return getList.map((item) => FavoriteDomain.fromJson(jsonDecode(item))).toList();

      }else{

        if(getLocationPermission){
          favoriteArray = await _getPosition();
          print('no length ${favoriteArray.length}');
          setState(() {
            favoriteArray = favoriteArray;
            mylocationFlag = true;
            locationPermission = true;
          });
          return favoriteArray;
        }else{
          // 권한이 없으면
          showDialog(context: context, builder:
              (BuildContext context) {
            return AlertImage(title: "권한이 없습니다.", contents: "위치권한이 없습니다. 설정 -> 위치권한을 활성화 시켜 주십시오.", switchStr: "locationPermission");
          });

          return getList.map((item) => FavoriteDomain.fromJson(jsonDecode(item))).toList();
        }


      }


    }

  }

  // Future <void> _refresh() async{
  //   for(int i = 0 ; i < favoriteArray.length ; i++){
  //     await _getKmaNowWeatherApi(favoriteArray[i].rect_id,i);
  //     await _getKmaNowDustApi(favoriteArray[i].rect_id, favoriteArray[i].longitude, favoriteArray[i].latitude, i);
  //   }
  // }


  /**
   * 현위치 좌표얻기
   * 현위치가 외국인 경우 favoriteArray을 반환
   * */
  Future<List<FavoriteDomain>> _getPosition() async{
    var result = await Util().determinePosition() as Position;

    String latitude = "";
    String longitude = "";
    //권한 없으면 가짜 위치 보냄
    if(locationPermission == false){
      latitude = "12.0";
      latitude = "12.0";
    }else{
      latitude = result.latitude.toString();
      longitude = result.longitude.toString();
    }

    var resultMylocaion = await ApiCall.getMylocationInfoForScreen("${longitude}", "${latitude}");


    bool isTrue = true;
    /**
     * 빈값체크
     * */
    if(resultMylocaion['kma_point_id'] == null) isTrue = false;


    String kma_point_id = resultMylocaion['kma_point_id'];
    String rect_id = resultMylocaion['rect_id'];
    String kmaX  = resultMylocaion['kmaX'];
    String kmaY = resultMylocaion['kmaY'];

    // 클리어
    favoriteArray.clear();

    // 이름 현위치 고정
    favoriteArray.add(
        FavoriteDomain(address: "현위치", dongName: "현위치", longitude: longitude,
            latitude: latitude, kmaX: kmaX, kmaY: kmaY, rect_id: rect_id,
            kma_point_id: kma_point_id, weatherDescription: "", weatherConditions: "",
            rainfallAmount: "", celsius: "20", imgSrc: "", alarmTime: "0800",utcAlarmTime: "2300", use: true, isTrue : isTrue)
    );

    return favoriteArray;

  }

  /**
   * 현재날씨 API 불러오기
   * */
  Future <KmaNowDomain> _getKmaNowWeatherApi(rect_id, index) async {
    final resultObj = await ApiCall.getNowKmaWeather(rect_id);
    final getDomain = KmaNowDomain.fromJson(resultObj);
    var temp = getKmaNowWeatherList;

    if(temp.asMap()[index] == null ){
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

  //async wait 을 쓰기 위해서는 Future 타입을 이용함
  Future<Null> refreshList() async {
    count++;
    _loadFavoriteLocationData().then((value) async{
      // print('value ${value}');
      // _refresh().then((value) => setState(() {
      //   flag = true;
      // }));

      setState(() {
        count = count;
      });
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    // print('idx => ${idx}');
    // print('init start flag ${flag}');
    // print('favoriteArray.length ==?> ${favoriteArray.length} ');
    // print('getKmaNowWeatherList ==?> ${getKmaNowWeatherList.length} ');
    // print('getKmaNowDustList ==?> ${getKmaNowDustList.length} ');
    // print("last _current  ${_current} ${favoriteArray.length} ${mylocationFlag} ${locationPermission}");


    /**
     * DESC : [idx]
     * -2 현위치 버튼 (새창)
     * */
    if(idx == -2){
      return Scaffold(
          appBar: AppBar(
            title: Text('현위치'),
            centerTitle: true,
          ),
          body: _buildStack(context)
      );
    }else{

      if(flag){
        return Scaffold(
            body: _buildStack(context)
        );
      }else{
        return new Container(
            child: LoadingWidget(),
        );
      }

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
                _changedCarouSel(index);
                setState(() {
                  _current = index;
                });
              },
              initialPage: _current
            ),
          ),

          new Container(
                child: _buildDots(context)
          ),

        ]
    );
  }
  /**
   * 점 찍기
   * */
  Widget _buildDots(BuildContext context){

    var xScreen;
    if(flag){
      if(favoriteArray.length == 0 ){

        xScreen = new Center(
          child: new Container(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: 400.0,
                  maxWidth: 300.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/no_contents.gif'),
                    Container(
                      child: Text(
                        '위치권한이 없어 현위치의 날씨를 표시할 수 없습니다.',
                        style: TextStyle(fontSize: 20, ),
                      ),


                    ),

                  ],
                ),
              )
          ),
        );

      }else{

        double getPosition = 0.0;
        if(mylocationFlag){
          getPosition = 0.0;
        }else{
          getPosition = _current.toDouble();
        }

        print("getPosition ${getPosition} ${mylocationFlag}" );

        xScreen = new Center(
          child:  new Column(
              children: [
                new Column(
                  children: [
                    DotsIndicator(
                        dotsCount: favoriteArray.length,
                        position:  getPosition,
                        decorator: DotsDecorator(
                          size: const Size.square(9.0),
                          activeSize: const Size(18.0, 9.0),
                          activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                        ),
                        onTap: (position) {
                          setState(() =>
                          _current = position.toInt()
                          );
                        }
                    )
                  ],
                )
              ]
          ),
        );

      }
    }else{
      xScreen = Container();
    }



    return xScreen;
  }



  /**
   * 메인화면 구성.
   * */
  List<Widget> _buildScreen(BuildContext context){
    List<Widget> screenList = [];

      for(int i = 0 ; i< favoriteArray.length; i++){
        var screenX = null;

        print("favoriteArray[i].isTrue ${i} ${favoriteArray[i].latitude} ${favoriteArray[i].longitude}");

        if(favoriteArray[i].isTrue == false) {
          screenX =
              new Center(
                child: new Container(
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: 400.0,
                        maxWidth: 300.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/no_contents.gif'),
                          Container(
                            child: Text(
                              '위치궈한이 없어 현위치의 날씨를 표시할 수 없습니다.',
                              style: TextStyle(fontSize: 20,),
                            ),


                          ),

                        ],
                      ),
                    )
                ),
              );

        }else{

          screenX = RefreshIndicator(child: new Container(
            child: SingleChildScrollView(
                child: new Container(
                    color: Dependencys.AppBackGroundColor,
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

                                  // Container(
                                  //   height: 440,
                                  //   child: MainWeather(rect_id: favoriteArray[i].rect_id, kmaNowWeatherObject: getKmaNowWeatherList[i],)
                                  //
                                  // ),
                                  // Container(
                                  //     height: 100,
                                  //     child: WeatherBar(rect_id: favoriteArray[i].rect_id, kmaNowWeatherObject: getKmaNowWeatherList[i], kmaNowDustObject: getKmaNowDustList[i],)
                                  //
                                  // ),

                                  Container(
                                    height: 520,
                                    child: FutureBuilder(
                                      future: _getKmaNowWeatherApi(favoriteArray[i].rect_id, i),
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
                                                    MainWeather(
                                                      rect_id : favoriteArray[i].rect_id,
                                                      kmaNowWeatherObject: body,
                                                      dongName: favoriteArray[i].dongName,
                                                    ),
                                                    /**
                                                     * =======================[2.날씨바]=====================
                                                     * */
                                                    WeatherBar(
                                                        rect_id: favoriteArray[i].rect_id,
                                                        kmaNowWeatherObject: body,
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
                                   * =======================[4.강수예보 그래프 ]=====================
                                   * */
                                  RainfallForecast(rect_id: favoriteArray[i].rect_id),

                                  /**
                                   * =======================[5. 주간예보]=====================
                                   * */
                                  SizedBox(
                                    height: 15,
                                    width: 1,
                                  ),
                                  WeekForecast(rect_id: favoriteArray[i].rect_id,),


                                  SizedBox(
                                    height: 15,
                                    width: 1,
                                  ),
                                  /**
                                   * =======================[6. 일몰일출]=====================
                                   * */
                                  SizedBox(
                                    height: 15,
                                    width: 1,
                                  ),

                                  SunRiseWidget(longitude: favoriteArray[i].longitude, latitude:  favoriteArray[i].latitude),


                                  new Container(
                                      margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                                      child: Divider(
                                        color: Colors.black,
                                        height: 36,)
                                  ),

                                  SizedBox(
                                    height: 10,
                                    width: 1,
                                  ),

                                  Text('자료 기상청, 레인보우'),

                                  Center(
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Text(
                                              '미세먼지 자료 출처: 환경부/한국환경공단, \n 데이터 오류 가능성: 데이터는 실시간 관측된 자료이며 측정소 현지 사정이나 데이터의 수신상태에 따라 미수신 될 수 있음',
                                              style: TextStyle(
                                                fontSize: 10,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                            ),
                                            width: 300.0,
                                            height: 100.0,
                                          ),
                                        ],
                                      )
                                  ),


                                ],
                              ),
                            )

                        ),

                      ],
                    )
                ),
              ),
            )
              , onRefresh: refreshList,
          );
        }

        screenList.add(screenX);
      }

      return screenList;
  }




}
