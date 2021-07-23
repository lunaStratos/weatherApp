import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rainvow_mobile/Domain/FavoriteDomain.dart';
import 'package:rainvow_mobile/Screen/AlarmModifyScreen.dart';
import 'package:rainvow_mobile/Screen/AlertWidget/AlertImage.dart';
import 'package:rainvow_mobile/Screen/AlertWidget/AlertNormal.dart';
import 'package:rainvow_mobile/Util/ApiCall.dart';
import 'package:rainvow_mobile/Util/Dependencys.dart';
import 'package:rainvow_mobile/Util/Util.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/**
 * 알람설정
 * desc: 설정된 알람관리
 * 저장소이름: alarmPermission, alarmList
 * */
class AlarmScreen extends StatefulWidget {

  @override
  _AlarmScreenScreen createState() => _AlarmScreenScreen();

}
class _AlarmScreenScreen extends State<AlarmScreen> {

  late SharedPreferences prefs;

    bool locationPermission = false;
    bool alarmFlag = false;
    List<FavoriteDomain> alarmList = [];
    String fcmToken = "";

    @override
  void initState() {
    super.initState();
    _loadPermission();
    _loadFavoriteLocationData();

    }

    /**
     * 삭제 시퀸스
     * 로컬에서 삭제후 FCM 삭제
     * */
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
     * 알람 받기
     * */
    void _loadPermission() async{
      prefs = await SharedPreferences.getInstance();
      bool getAlarmPermission = prefs.getBool("alarmPermission") ?? false;
      setState(() {
        alarmFlag = getAlarmPermission;
      });
    }

    /**
   * 알림지역 불러오기
   * */
    _loadFavoriteLocationData() async{
      prefs = await SharedPreferences.getInstance();

      final getList = prefs.getStringList('favoriteLocation') ?? [];
      final getLocationPermission = prefs.getBool('locationPermission') ?? false;
      final getFcmToken = prefs.getString("fcmToken")??"";
      setState(() {
        alarmList = getList.map((item) => FavoriteDomain.fromJson(jsonDecode(item))).toList();
        locationPermission = getLocationPermission;
        fcmToken = getFcmToken;
      });

    }

    /**
     * 알람 켜기,끄기
     * */
    void _alarmToggle(bool flag) async{
      setState(() {
        alarmFlag = flag;
      });

      //저장소에 상태 저장
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("alarmPermission", flag);

      if(flag){
        ToastWiget("알람이 켜졌습니다.");
        await sendFcm();
      }else{
        ToastWiget("알람이 꺼졌습니다.");
        await sendAllDeleteFcm();
      }

    }

    /**
     * FCM토큰과 알람 보내기
     * desc: FCM 리스트 전체 삭제후 모두 저장보내기
     * */
    Future <void> sendFcm() async{
      String timezone = DateTime.now().timeZoneName;

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
            "timezone": timezone,
            "utcAlarmTime" : "",
            "useYn": "N"
          }
      ));

      for(int i = 0 ; i < alarmList.length ; i++){

        if(alarmList[i].use){

          var alarmtime = alarmList[i].alarmTime.toString().split(":");
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
                "useYn": "Y"
              }
          );
          await ApiCall.sendFCMToken(param);
        }

      }
      print('send Fcm all');
    }

  /**
   * 알람정지시 사용 - FCM 리스트 전체 삭제
   * */
  Future <void> sendAllDeleteFcm() async{

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
          "time": "",
        }
    ));

  }
    /**
     * 토스트 위젯
     * */
    Future <void> ToastWiget(contents) async{
      Fluttertoast.showToast(
      msg: "${contents}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0
      );
    }

  /**
   * 알람 아이템당 켜고 끄기
   * */
    _alarmToggleItem(bool toggle, index) async{

      if(alarmFlag == false){
        showDialog(context: context, builder:
            (BuildContext context) {
          return AlertImage(title: "알림받기 권한", contents: "알림받기 권한 없습니다. 알림받기를 활성화 시켜 주십시오.", switchStr: "alarmPermission");
        });
        return;
      }
      prefs = await SharedPreferences.getInstance();
      alarmList[index].use = toggle;

      setState(() {
        alarmList = alarmList;
      });

      List<String> strList = alarmList.map((item) => jsonEncode(item)).toList();
      await prefs.setStringList('favoriteLocation', strList );
      int hour = int.parse(alarmList[index].alarmTime.split(":")[0]);
      int minute = int.parse(alarmList[index].alarmTime.split(":")[1]);
      String rect_id = alarmList[index].rect_id;
      String longitude = alarmList[index].longitude;
      String latitude = alarmList[index].latitude;

      await sendFcm();

    }

  /**
   * 알람 시각 설정
   * */
  _setAlarmTime(hour, minute, index)async{
    prefs = await SharedPreferences.getInstance();
    alarmList[index].alarmTime = '${hour}:${minute}';

    setState(() {
      alarmList = alarmList;
    });

    List<String> strList = alarmList.map((item) => jsonEncode(item)).toList();
    await prefs.setStringList('favoriteLocation', strList );
    sendFcm();
  }





  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
            title: Text('알람 설정'),
            centerTitle: true,
        ),
        body: buildSettingsList(context),
      );
    }

    /**
     *
     * */
    Widget buildSettingsList(context) {

      return new Column(
        children: [
          // new Container(
          //   child: Padding(
          //       padding: const EdgeInsets.only(bottom: 4, top: 4, left: 9, right: 9),
          //       child: InkWell(
          //         child: new Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: <Widget>[
          //             new Container(
          //               child: Text(
          //                 '일일 알람 설정',
          //                 textAlign: TextAlign.left,
          //                 style: TextStyle(fontSize: 20,),
          //               ),
          //             ),
          //             new Container(
          //
          //             ),
          //
          //             new Container(
          //               child: Image.asset(
          //                 'assets/images/gear_menu.png',
          //                 height: 50,
          //                 width: 50,
          //                 alignment: Alignment.centerRight,
          //               ),
          //             ),
          //           ],
          //         ),
          //         onTap: () =>{
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => AlarmModifyScreen()),
          //           )
          //         },
          //       )
          //   ),
          //   color: Dependencys.AppBackGroundColor,
          // ),

          Container(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('알림 받기', style: TextStyle(fontSize: 18),),
                        Text('매일 지정한 시각에 선택한 위치의 기상정보를 받아볼 수 있습니다.', maxLines: 2,
                          overflow: TextOverflow.ellipsis,)
                      ],
                    ),
                  ),
                  Switch(
                    value: alarmFlag,
                    onChanged: (value) {
                      _alarmToggle(value);
                    },
                    activeTrackColor: Colors.lightBlueAccent,
                    activeColor: Colors.blue,
                  ),
                ],

              ),
            )
          ),
          Expanded(
            child: alarmList.isEmpty ? Center(child: Text('현재 저장된 지역이 없습니다.', style: TextStyle(color:Colors.black12),)) : ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: alarmList.length,
              itemBuilder: _getItemUI,
              separatorBuilder: (BuildContext context, int index) => const Divider(),

            ),
          )
        ],
      );
    }
    
    /**
     * 알람설정 리스트 만드는 기능
     * */
    List<SettingsTile> generateAlarmToggleList()  {
      List<SettingsTile> toggleList = [];

      for (var index = 0; index < alarmList.length; index++) {

        final address = alarmList[index].address;     // 주소
        final alarmTime = alarmList[index].alarmTime; // 알람시간
        var use = alarmList[index].use;               // 개별 사용여부

        toggleList.add(
            SettingsTile.switchTile(
              leading: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child: Icon(Icons.alarm),
                    onTap: () =>
                        /**
                         * 알람 시간 설정
                         * 취소시 동작 없ㅇ음.
                         * */
                        DatePicker.showTimePicker(context,
                          showTitleActions: true,
                          showSecondsColumn: false,
                          onChanged: (date) {},

                          onConfirm: (date) {

                            final hour = Util.trans2Digit(date.hour);
                            final minute = Util.trans2Digit(date.minute);

                            _setAlarmTime(hour, minute, index);

                          },
                          currentTime: DateTime.now(), locale: LocaleType.ko    // 한국어
                        )
                    ,
                  )
                ],
              ),
              title: address,
              titleTextStyle: TextStyle(fontSize: 15, color: (alarmFlag ? Colors.black: Colors.black38)
              ),
              subtitle: '${alarmTime} >',
              subtitleTextStyle: TextStyle(
                  color: (alarmFlag ? Colors.black: Colors.black38),
                  fontSize: 20
              ),
              switchValue: use,
              /**
               * 알람설정 - 개별 토글
               * */
              onToggle: (bool toggle) {
                print("onToggle switch ${toggle}");
                  _alarmToggleItem(toggle, index);

              },



            )
        );

      }
      return toggleList;
    }


  /**
   * 알람설정 리스트 만드는 기능 - 이거 사용중
   * */
  Widget _getItemUI(BuildContext context, int index)  {

    final address = alarmList[index].address;
    final alarmTime = alarmList[index].alarmTime;
    var use = alarmList[index].use;


    return new Column(
            children: [
              new ListTile(
                /**
                 * 삭제 아이콘
                 * */
                leading: InkWell(
                  child: SizedBox(
                      child: Icon(Icons.delete),
                    width: 50,
                    height: 50,
                  ),
                  onTap: () {
                    print('delete $index');
                    _deleteAlarmItem(index);
                  },
                ),
                /**
                 * 주소 텍스트
                 * */
                title: Text("${address}"),
                /**
                 * 알람 시간 텍스트
                 * */
                subtitle: Text('${alarmTime}'),
                /**
                 * on off 여부
                 * */
                trailing: Switch(
                  value: use,
                  onChanged: (value) {
                    _alarmToggleItem(value, index);
                  },
                  activeTrackColor: Dependencys.SwitchColor,
                  activeColor: Colors.blue,
                ),
                onTap: () =>
                /**
                 * 알람 시간 설정
                 * 취소시 동작 없ㅇ음
                 * */
                DatePicker.showTimePicker(context,
                    showTitleActions: true,
                    showSecondsColumn: false,
                    onChanged: (date) {},

                    onConfirm: (date) {
                      final hour = ((date.hour).toString().length == 1) ? '${"0"}${date.hour}' : '${date.hour}' ;
                      final minute =  ((date.minute).toString().length == 1) ? '${"0"}${date.minute}' : '${date.minute}' ;

                      _setAlarmTime(hour, minute, index);

                    },
                    currentTime: DateTime.now(), locale: LocaleType.ko    // 한국어
                ),

              ),

            ]
        );

  }


}
