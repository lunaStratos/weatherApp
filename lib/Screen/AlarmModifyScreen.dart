import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainvow_mobile/Domain/FavoriteDomain.dart';
import 'package:rainvow_mobile/Util/ApiCall.dart';
import 'package:rainvow_mobile/Util/Dependencys.dart';
import 'package:rainvow_mobile/Util/Util.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';


/**
 * 알람 수정 화면
 * desc: 알람목록을 지우는 화면
 * 저장소이름: favoriteLocation
 * */
class AlarmModifyScreen extends StatefulWidget {

  @override
  _AlarmModifyScreen createState() => _AlarmModifyScreen();

}

class _AlarmModifyScreen extends State<AlarmModifyScreen> {
  late SharedPreferences prefs;
  List <FavoriteDomain> alarmList = [];
  String fcmToken = "";

  @override
  void initState() {
    super.initState();
    _loadFavoriteLocationData();
  }

  _loadFavoriteLocationData() async{

    prefs = await SharedPreferences.getInstance();
    final getList = prefs.getStringList('favoriteLocation') ?? [];
    final getFcmToken = prefs.getString("fcmToken") ?? "";
    print(getList[0]);

    setState(() {
      alarmList = getList.map((item) => FavoriteDomain.fromJson(jsonDecode(item))).toList();
      fcmToken = getFcmToken;
    });
  }

  _deleteAlarmItem(int index)async{
    alarmList.removeAt(index);
    setState(() {
      alarmList = alarmList;
    });

    List<String> strList = alarmList.map((item) => jsonEncode(item)).toList();
    await sendFcm();
    await prefs.setStringList('favoriteLocation', strList );


  }

  /**
   * FCM토큰과 알람 보내기
   * desc: 삭제 -> 전체 보내기
   * */
  Future <void> sendFcm() async{

    await ApiCall.sendDeleteFcmToken(jsonEncode(
        {
          "rectId": "",
          "kmaPointId":"",
          "longitude": "",
          "latitude":"",
          "kmaX": "",
          "kmaY": "",
          "address": "",
          "fcmToken": fcmToken,
          "localAlarmTime": "",
          "timezone": "",
          "utcAlarmTime" : "",
          "useYn": "Y",
        }
    ));


    for(int i = 0 ; i < alarmList.length ; i++){

      var timezone = DateTime.now().timeZoneName;

      if(alarmList[i].use){
        String alarmtime = alarmList[i].alarmTime..toString().split(":");
        String utcTime = Util.utcTime(int.parse(alarmtime[0]),int.parse(alarmtime[1]));
        var param = jsonEncode(
            {
              "rectId": alarmList[i].rect_id,
              "kmaPointId": alarmList[i].kma_point_id,
              "longitude": alarmList[i].longitude,
              "latitude": alarmList[i].latitude,
              "kmaX": alarmList[i].kmaX,
              "kmaY": alarmList[i].kmaY,
              "address": alarmList[i].dongName,
              "fcmToken": fcmToken,
              "localAlarmTime": alarmList[i].alarmTime,
              "timezone": timezone,
              "utcAlarmTime" : utcTime,
              "useYn": "Y",

            }
        );

        await ApiCall.sendFCMToken(param);
      }

    }
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
            title: Text('알람 설정'),
            centerTitle: true,
        ),
        body: buildSettingsList(),
      );
    }

    Widget buildSettingsList() {
      return SettingsList(
        sections: [
          CustomSection(
            child: Column(
              children: [
                new Container(
                  color: Dependencys.AppBackGroundColor,
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 4, top: 4, left: 9, right: 9),
                      child: InkWell(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Container(
                              child: Text(
                                '일일 알람 편집',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 20,),
                              ),
                            ),
                            new Container(

                            ),

                            new Container(
                              child: Image.asset(
                                'assets/images/gear_menu.png',
                                height: 50,
                                width: 50,
                                alignment: Alignment.centerRight,
                              ),
                            ),
                          ],
                        ),

                      )

                  ),
                )
              ],
            ),
          ),
          SettingsSection(

            tiles: generateAlarmToggleList()
          ),


        ],
      );
    }


  /**
   * 알람설정 리스트 만드는 기능
   * */
  List<SettingsTile> generateAlarmToggleList()  {
    List<SettingsTile> ass = [];

    for (var index = 0; index < alarmList.length; index += 1) {
      final address = alarmList[index].address;
      final alarmTime = alarmList[index].alarmTime;
      var use = alarmList[index].use;
      print('use ${alarmList[index].use}');
      ass.add(
        SettingsTile(
          title: address,
          titleTextStyle: TextStyle(fontSize: 18),
          leading: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              /**
               * 삭제 아이콘
               * */
              IconButton(onPressed: () =>{
                _deleteAlarmItem(index)
              }, icon: Icon(Icons.delete))
            ],
          ),
          onPressed: (BuildContext context) {
          },
        ),
      );
    }
    return ass;
  }


}