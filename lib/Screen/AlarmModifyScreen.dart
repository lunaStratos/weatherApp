import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainvow_mobile/Domain/FavoriteDomain.dart';
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

  @override
  void initState() {
    super.initState();
    _loadFavoriteLocationData();
  }

  _loadFavoriteLocationData() async{

    prefs = await SharedPreferences.getInstance();
    final getList = prefs.getStringList('favoriteLocation') ?? [];
    print(getList[0]);

    setState(() {
      alarmList = getList.map((item) => FavoriteDomain.fromJson(jsonDecode(item))).toList();
    });
  }

  _deleteAlarmItem(int index)async{
    alarmList.removeAt(index);
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
                  color: Colors.white60,
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