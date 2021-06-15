import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:rainvow_mobile/Domain/FavoriteDomain.dart';
import 'package:rainvow_mobile/Screen/AlarmModifyScreen.dart';
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

  // late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  late SharedPreferences prefs;

    bool locationPermission = false;
    bool alarmFlag = false;
    List<FavoriteDomain> alarmList = [];


    @override
  void initState() {
    super.initState();
    _loadPermission();
    _loadFavoriteLocationData();

  //   _configureLocalTimeZone();
  //
  //   /**
  //    * ANDROID SETTING
  //    * */
  //   final AndroidInitializationSettings initializationSettingsAndroid =
  //   AndroidInitializationSettings('@mipmap/ic_launcher');
  //
  //   /**
  //    * IOS SETTING
  //    * */
  //   final IOSInitializationSettings initializationSettingsIOS =
  //   IOSInitializationSettings(
  //     requestSoundPermission: false,
  //     requestBadgePermission: false,
  //     requestAlertPermission: false,
  //   );
  //
  //   /**
  //    * SETTING INSERT
  //    * */
  //   final InitializationSettings initializationSettings =
  //   InitializationSettings(
  //       android: initializationSettingsAndroid,
  //       iOS: initializationSettingsIOS,
  //       macOS: null);
  //
  //   /**
  //    * ANDROID SETTING
  //    * */
  //   _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //   _flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification:selectNotification );
  //
  // }
  //
  // Future<void> _configureLocalTimeZone() async {
  //   tz.initializeTimeZones();
  //   final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  //   tz.setLocalLocation(tz.getLocation(timeZoneName!));
  // }
  //
  //
  // Future selectNotification(payload) async {
  //   print('payload ${payload}');
  //   String xx = await _loadWeather(payload.toString().split(",")[0], payload.toString().split(",")[1]);
  //
  //   WeatherScreen(x: xx,);
  // }
  //
  //
  //
  // Future<String> _loadWeather(longitude, latitude) async{
  //
  //   final resultObj = await ApiCall.getNowKmaWeather(longitude, latitude);
  //   final getDomain = KmaNowDomain.fromJson(resultObj);
  //   print('resultObj Now ${longitude} ${latitude} ${resultObj}  ');
  //
  //     return getDomain.weather_conditions_keyword;
  // }
  //
  //
  //
  // Future _showNotification(hour, minute, rect_id, longitude, latitude) async{
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //       'channel_ID', 'channel name', 'channel description',
  //       importance: Importance.max,
  //       playSound: true,
  //       showProgress: true,
  //       priority: Priority.high,
  //       ticker: 'test ticker');
  //
  //   var iOSChannelSpecifics = IOSNotificationDetails();
  //   var platformChannelSpecifics = NotificationDetails(
  //       android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
  //
  //   // 알람
  //   await _flutterLocalNotificationsPlugin.zonedSchedule(
  //       0,
  //       await _loadWeather(longitude, latitude),
  //       'daily scheduled notification body',
  //       _nextInstanceOfRepeat(hour, minute),
  //       const NotificationDetails(
  //         android: AndroidNotificationDetails(
  //             'daily notification channel id',
  //             'daily notification channel name',
  //             'daily notification description'),
  //       ),
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  //       matchDateTimeComponents: DateTimeComponents.time,
  //       payload: "${longitude},${latitude}");
  //
    }
  //
  // tz.TZDateTime _nextInstanceOfRepeat(hour, minute) {
  //   final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  //   tz.TZDateTime scheduledDate =
  //   tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
  //   if (scheduledDate.isBefore(now)) {
  //     scheduledDate = scheduledDate.add(const Duration(days: 1));
  //   }
  //   return scheduledDate;
  // }

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

      setState(() {
        alarmList = getList.map((item) => FavoriteDomain.fromJson(jsonDecode(item))).toList();
        locationPermission = getLocationPermission;
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
      }else{
        ToastWiget("알람이 꺼졌습니다.");
      }

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


      // if (toggle){
      //   //알람켜짐
      //   _showNotification(hour, minute, rect_id, longitude, latitude);
      //   ToastWiget("매일 ${hour}시 ${minute}분 날씨알람이 켜졌습니다.");
      //
      // }else{
      //   //알람꺼짐
      //   ToastWiget("매일 ${hour}시 ${minute}분 날씨알람이 꺼졌습니다.");
      // }


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

    Widget buildSettingsList(context) {

      return SettingsList(

        sections: [
          CustomSection(
            child: Column(
              children: [
                new Container(
                  color: Colors.white60,
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 4, top: 4, left: 9, right: 9),
                      child: InkWell(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Container(
                              child: Text(
                                '일일 알람 설정',
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
                        onTap: () =>{
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                              builder: (context) => AlarmModifyScreen()),
                            )
                        },
                      )

                  ),
                )
              ],
            ),
          ),
          SettingsSection(

            tiles: [
              SettingsTile.switchTile(
                title: '알림 받기',
                titleTextStyle: TextStyle(fontSize: 18),
                subtitle: '매일 지정한 시각에 선택한 위치의 기상정보를 받아볼 수 있습니다.',
                subtitleMaxLines: 2,
                switchValue: alarmFlag,
                //스위치
                onToggle: (bool value) {
                  _alarmToggle(value);
                },
              ),
            ],
          ),
          CustomSection(
            child: Column(
              children: [

              ],
            ),
          ),
          SettingsSection(
            title: '알람설정',
            titleTextStyle: TextStyle(fontSize: 19),
            titlePadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            tiles: generateAlarmToggleList()
            ,
          ),

        ],
      );
    }
    
    /**
     * 알람설정 리스트 만드는 기능
     * */
    List<SettingsTile> generateAlarmToggleList()  {
      List<SettingsTile> toggleList = [];

      for (var index = 0; index < alarmList.length; index++) {
        final address = alarmList[index].address;
        final alarmTime = alarmList[index].alarmTime;
        var use = alarmList[index].use;

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
                        onChanged: (date) {},

                        onConfirm: (date) {
                          final hour = ((date.hour).toString().length == 1) ? '${"0"}${date.hour}' : '${date.hour}' ;
                          final minute =  ((date.minute).toString().length == 1) ? '${"0"}${date.minute}' : '${date.minute}' ;
                          print( ' ${index} ===> ${hour}  ${minute}');
                          _setAlarmTime(hour, minute,index);

                        },
                        currentTime: DateTime.now(), locale: LocaleType.ko    // 한국어
                    )

                    //     showDialog(context: context, builder:
                    //     (BuildContext context) {
                    //   return _buildAlert(context);
                    // }
                    // )
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
                _alarmToggleItem(toggle, index);

              },



            )
        );

      }
      return toggleList;
    }



}
