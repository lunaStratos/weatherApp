import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

import 'package:rainvow_mobile/Domain/FavoriteDomain.dart';
import 'package:rainvow_mobile/Domain/FavoriteJsonDomain.dart';
import 'package:rainvow_mobile/Screen/AlarmModifyScreen.dart';
import 'package:rainvow_mobile/Screen/AlertWidget/AlertImage.dart';
import 'package:rainvow_mobile/Screen/AlertWidget/AlertNormal.dart';
import 'package:rainvow_mobile/Screen/WeatherScreen.dart';
import 'package:rainvow_mobile/SideBar/Home.dart';
import 'package:rainvow_mobile/Util/ApiCall.dart';
import 'package:rainvow_mobile/Util/Util.dart';
import 'package:shared_preferences/shared_preferences.dart';

/**
 * 관심지역 화면
 * desc: 관심지역의 저장과 관리
 * 저장소이름: favoriteLocation
 * */
class FavoriteScreen extends StatefulWidget {
  /**
   * createState 이름은 고정
   * */
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();

}

class _FavoriteScreenState extends State<FavoriteScreen>{

   late SharedPreferences prefs;

  String searchLocationText = "";                   // 검색어
  bool locationPermission = false;                  // 현위치 권한
  List<FavoriteJsonDomain> suggestionListReal = []; // 검색어 추천단어


  @override
  void initState() {
    super.initState();
    _loadFavoriteLocationData();

  }

  /**
   * 데이터 LIST 부분
   * */
  List<FavoriteDomain> favoriteArray = [];

  /**
   * 읽기
   * desc: 관심지역과 현위치 권한을 앱저장소로 부터 읽는다.
   * */
  _loadFavoriteLocationData() async{
    prefs = await SharedPreferences.getInstance();

    final getList = prefs.getStringList('favoriteLocation') ?? [];
    final getLocationPermission = prefs.getBool('locationPermission') ?? false;

    favoriteArray = getList.map((item) => FavoriteDomain.fromJson(jsonDecode(item))).toList();

    for(int i = 0 ; i < favoriteArray.length ; i++){
      final getItem = await ApiCall.getNowKmaWeather(favoriteArray[i].rect_id);
      print('getItem ${getItem}');
      favoriteArray[i].celsius = getItem['temperature'];
      favoriteArray[i].weatherConditions = getItem['weatherConditions'];
      favoriteArray[i].weatherDescription = getItem['weatherConditionsKeyword'];
      favoriteArray[i].rainfallAmount = getItem['rainfallAmount'].toString();
      print("${favoriteArray[i].celsius} ${getItem['temperature']}");
    }

    setState(() {
      favoriteArray = favoriteArray;
      locationPermission = getLocationPermission;
    });


  }

  /**
   * 저장기능
   * desc: 관심지역을 저장한다.
   * */
  _saveFavoriteLocationData(itemInput) async{

    var item = itemInput as FavoriteJsonDomain;
    prefs = await SharedPreferences.getInstance();

    final getItem = await ApiCall.getNowKmaWeather(item.rect_id);
    print('_saveFavoriteLocationData ${item.rect_id}');
    favoriteArray.add(
        FavoriteDomain(
            address:"${item.address}",
            dongName: "${item.dongName}",
            longitude: "${item.longitude}" ,
            latitude: "${item.latitude}",
            kmaX: "${item.kmaX}",
            kmaY: "${item.kmaY}",
            kma_point_id: "${item.kma_point_id}",
            rect_id: "${item.rect_id}",
            weatherDescription: getItem['weatherConditionsKeyword'],//temp
            weatherConditions: getItem['weatherConditions'],
            rainfallAmount: getItem['rainfallAmount'],            //temp
            celsius: getItem['temperature'],                   //temp
            imgSrc:"",
            alarmTime: "08:00",
            use: false)
    );

    List<String> tempSaveList = [];

    favoriteArray.map((it) => {
      tempSaveList.add(jsonEncode(it))
    });

    List<String> strList = favoriteArray.map((item) => jsonEncode(item)).toList();
    await prefs.setStringList('favoriteLocation', strList );
    /**
     * 도로명주소가 저장되었음을 알림
     * */
    Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('${item.dongName}을 저장했습니다.')
    ));

    setState( () => favoriteArray);
  }

  /**
   * 현위치 클릭
   * */
  _getPosition () async{
      var result = await Util().determinePosition() as Position;
      String latitude = result.latitude.toString();
      String longitude = result.longitude.toString();
      var resultMylocaion = await ApiCall.getMylocationInfo(longitude, latitude);
      var result2 = json.decode(resultMylocaion);
      String kma_point_id = result2['kma_point_id'];
      String rect_id = result2['rect_id'];
      String kmaX  = result2['kmaX'];
      String kmaY = result2['kmaY'];

      final fDomain = FavoriteJsonDomain(
          address: '현위치',
          dongName: '현위치',
          latitude: latitude,
          longitude: longitude,
          kma_point_id: kma_point_id,
          rect_id: rect_id,
          kmaX: kmaX,
          kmaY: kmaY

      );

      print('fDomain : ${fDomain.kmaX}');
      //저장소 저장
      await prefs.setString("favoriteNowLocation", jsonEncode(fDomain));


  }

  _removeItem(index) async{
    prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteArray.removeAt(index);
    });

    List<String> strList = favoriteArray.map((item) => jsonEncode(item)).toList();
    await prefs.setStringList('favoriteLocation', strList );

  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
     body: new Column(
       children: [
         /**
          * 검색창
          * */
         new Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                  autofocus: true,
                  style: DefaultTextStyle.of(context).style.copyWith(
                      fontStyle: FontStyle.italic
                  ),
                  decoration: InputDecoration(
                      border: OutlineInputBorder()
                  ),
                  /**
                   * 관심지역 검색 텍스트 변경
                   * desc: 변경시 텍스트 값을 setState로 변조
                   * */
                  onChanged: (inputText) async {
                        setState(() {
                          searchLocationText = inputText;
                        });
                  },
                  onSubmitted: (value) {
                    print('value ${value}');
                  },
              ),
              /**
               * 관심지역 제안 검색어 가져오기
               * desc: 제안 검색어를 리스트로 가져와 뿌려줌
               * */
              suggestionsCallback: (pattern) async {

                final jsonArray = await ApiCall.getFavoriteSearchList(searchLocationText);
                setState(() {
                  suggestionListReal = jsonArray.map((item) => FavoriteJsonDomain.fromJson(item)).toList();
                });
                return await suggestionListReal;
              },
              itemBuilder: (context, item ) {
                var itemDomain = item as FavoriteJsonDomain;
                return new Column(
                  children: [
                    ListTile(
                    title: Text(' ${itemDomain.dongName}'),
                    subtitle: Text('${itemDomain.address}'),
                    ),
                  ],
                );
              },
              /**
               * 제안 검색어중 하나 클릭
               * desc: 클릭한 제안 검색어를 저장한다.
               * 중복이면 중복 알림후 return
               * */
              onSuggestionSelected: (item) {
                item as FavoriteJsonDomain;
                bool flag = true;

                // 기존 등록 리스트의 중복체크
                favoriteArray.forEach((element) {
                 if(element.dongName == item.dongName){
                   showDialog(context: context, builder:
                       (BuildContext context) {
                         return AlertNormal(title: '중복된 장소입니다.', contents: '기존에 저장된 장소와 중복입니다.');
                       }
                   );
                   flag = false;
                 }
                });

                item as FavoriteJsonDomain;
                flag ? _saveFavoriteLocationData(item) : "";


              },
              /**
               * no items found! 표시방지
               * */
              hideOnEmpty : true,
              hideOnLoading: true,
            ),


          ),
         ),




         /**
          * 현위치
          * */
         Padding(
             padding: const EdgeInsets.only(left: 10),
             child: new Row(
               children: [
                  new GestureDetector(
                  onTap: (){
                    /**
                     * 현위치 클릭
                     * 1. 로딩화면 띄움
                     * 2. api접속
                     * 3. lat lng 주소 가져옴
                     * 4. 팝업 리스트 띄움
                     * */
                  print("현위치 클릭");
                    if(locationPermission){
                      _getPosition();
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext
                      context) => WeatherScreen(idx: -2, action: "click")));
                    }else{
                      showDialog(context: context, builder:
                          (BuildContext context) {
                        return AlertImage(title: "권한이 없습니다.", contents:  "위치권한이 없습니다. 설정 -> 위치권한을 활성화 시켜 주십시오.", switchStr: "location");
                      }
                      );
                    }

                  },
                  child: new Container(
                    child: new Row(
                    children: [
                      Icon(Icons.gps_fixed),
                      new Container(
                      child: Text(' 현위치', style: TextStyle(fontSize: 20)),
                      )
                    ]
                  ),
                  )
                  )
               ],
             )
         ),
         /**
          * 알람 리스트
          * */
           Expanded(
             child:ListView.separated(
               padding: const EdgeInsets.all(8),
               itemCount: favoriteArray.length,
               itemBuilder: _getItemUI,
               separatorBuilder: (BuildContext context, int index) => const Divider(),
             ),
           )

       ],

     )
    );
  }

  Widget _getItemUI(BuildContext context, int index) {

    print('favoriteArray[index].weatherConditions ${favoriteArray[index].weatherConditions}');

    return new Column(
          children: <Widget>[
            new ListTile(
              /**
               * 날씨 사진 영역
               * 사이즈 110
               * desc: 날씨상태 사진과 온도 표시
               * */
              leading: new Container(
                width: 140,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround, //
                  children: [
                    Image.asset(
                        Util.kmaNowImgAddress(favoriteArray[index].weatherConditions.toString()),
                    width: 60.0,
                    ),
                    new Center(
                      child: Container(width: 80, height: 20,child:  new Text('${favoriteArray[index].celsius} °C', style: TextStyle(fontSize: 20, ),textAlign: TextAlign.center,),),
                    )
                  ],
                ),
              ),
              /**[`
               * 기능 - 아이콘 영역
               * desc: 누르면 관심지역 삭제
               * */
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /**
                   * 아이템 삭제
                   * */
                  IconButton(onPressed:() async{
                    Fluttertoast.showToast(
                        msg: "삭제되었습니다.",
                        gravity: ToastGravity.BOTTOM,
                        toastLength: Toast.LENGTH_SHORT
                    );
                    setState( () => _removeItem(index) );
                  }
                      , icon: Icon(Icons.close))
                ],
              ),
              /**
               * 주소
               * */
              title: new Text(
                favoriteArray[index].address ,
                style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              ),
              /**
               * 구름 및 확율
               * */
              subtitle: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text('${favoriteArray[index].weatherDescription}',
                        style: new TextStyle(
                            fontSize: 13.0, fontWeight: FontWeight.normal)),
                    new Text('비 오는양: ${favoriteArray[index].rainfallAmount}',
                        style: new TextStyle(
                            fontSize: 11.0, fontWeight: FontWeight.normal)),

                  ]
              ),
              /***
               * 기능 - 아이템 클릭
               * desc: 클릭하면 위치의 날씨 정보 보기 이동
               */
              onTap: () {
                print('press ${index}');
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext
                context) => HomePage(index: index,action:"clickFavorite")
                ));


              },

            )
          ],
        );
  }


}


