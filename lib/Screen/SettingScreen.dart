import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainvow_mobile/Screen/AlarmScreen.dart';
import 'package:rainvow_mobile/Screen/ContactScreen.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

/**
 * 설정 화면
 * desc: 설정(현위치, 권한설정, 문의)
 * */
class SettingScreen extends StatefulWidget {

  @override
  _SettingScreenScreen createState() => _SettingScreenScreen();

}

class _SettingScreenScreen extends State<SettingScreen>{

  bool locationFlag = false;
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    _loadPermission();
  }


  /**
   * 권한설정 읽기
   * */
  void _loadPermission() async{
    prefs = await SharedPreferences.getInstance();

    bool getPermissionBool = await prefs.getBool("locationPermission") ?? false;
    var statusPsermission = await Permission.location.status;

    if(getPermissionBool){
      if (statusPsermission.isDenied) {
        setState(() {
          locationFlag = false;
          prefs.setBool("locationPermission", false);
        });
      }
      if(statusPsermission.isGranted){
        setState(() {
          locationFlag = true;
          prefs.setBool("locationPermission", true);
        });
      }
    }else{
      setState(() {
        locationFlag = false;
        prefs.setBool("locationPermission", false);
      });
    }

  }
  
  /**
   * 위치권한 취소 토글
   * */
  void _togglePermission(insertFlag) async{
    if(insertFlag){
      await Permission.location.request();
    }
    setState(() {
      locationFlag = insertFlag;
    });
    prefs = await SharedPreferences.getInstance();
    prefs.setBool("locationPermission", insertFlag);
  }


  @override
  Widget build(BuildContext context) {

    const titlePadding = EdgeInsets.symmetric(vertical: 5, horizontal: 10);

    const version = "1.0";
    const lastVersion = "1.0";

    launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url, forceWebView: true);
      } else {
        throw 'Could not launch $url';
      }
    }

    return SettingsList(
      sections: [

        SettingsSection(
          title: '현위치',
          titleTextStyle: TextStyle( fontSize: 22),
          titlePadding: titlePadding ,
          tiles: [
            SettingsTile(
              title: '일일 알람설정',
              titleTextStyle: TextStyle(fontSize: 18),
              subtitle: '매일 지정한 시각에 선택한 위치의\n 기상정보를 받아올 수 있습니다',
              subtitleTextStyle: TextStyle(
                  fontSize: 10.0
              ),
              subtitleMaxLines: 2,
              leading: Icon(Icons.alarm),
              /**
               * 일일 알람설정으로 이동
               * */
              onPressed: (BuildContext context) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) =>  AlarmScreen(),
                ));

              },
            ),
          ],

        ),

        SettingsSection(
          title: '권한설정',
          titleTextStyle: TextStyle( fontSize: 22),
          titlePadding: titlePadding,
          tiles: [

            SettingsTile.switchTile(
              title: '위치권한',
              titleTextStyle: TextStyle(fontSize: 18),
              leading: Icon(Icons.gps_fixed),
              subtitle: '위치 권한을 허용하면 현위치의 기상정보를 확인할 수 있습니다.',
              subtitleMaxLines: 2,
              switchValue: locationFlag,
              /**
               * 위치권한 활성화 TOGGLE
               * */
              onToggle: (bool flag) {
                _togglePermission(flag);

              },
            ),
          ],
        ),
        SettingsSection(
          title: '문의',
          titleTextStyle: TextStyle( fontSize: 22),
          titlePadding: titlePadding,
          tiles: [
            SettingsTile(
              title: '문의하기',
              titleTextStyle: TextStyle(fontSize: 18),
              leading: Icon(Icons.language),
              onPressed: (BuildContext context) {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext
                context) => ContactScreen()));
              },

            ),
          ],
        ),

        CustomSection(
          child: Column(
            children: [
              InkWell(
                child: new Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 22, bottom: 8),
                      // child: Image.asset(
                      //   'assets/settings.png',
                      //   height: 50,
                      //   width: 50,
                      //   color: Color(0xFF777777),
                      // ),
                    ),
                    Text(
                      '앱 버전 ${version} ',
                      style: TextStyle(color: Color(0xFF777777)),
                    ),
                  ],
                ),
                /**
                 * 버전 팝업
                 * */
                onTap: () =>{
                  showDialog(
                    context: context,
                  builder: (BuildContext context) => _buildCard(context),
                  )
                },
              ),

            ],
          ),
        ),
      ],
    );

  }



  Widget _buildCard(BuildContext context) => new Container(

    child: new Center(
      child: new Container(
          decoration: BoxDecoration(
            color: Colors.cyan[50],
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
            ),
          ),
        height: 350.0,
        width: 300.0,
        // color: Colors.cyan[50], => decoration.color에 색상 지정시 여기 색상은 사용불가 함 
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/weather.png', height: 100,), // 로고 이미지
            Text('현재 버전 : ${'1.0'}', style: TextStyle(fontSize: 13, color: Colors.blue),),
            Text('최신 버전: ${'1.0'}', style: TextStyle(fontSize: 13, color: Colors.black),),
            /**
             * 확인버튼
             * */
            Container(
              margin: EdgeInsets.all(20),
              height: 35.0,
              width: 150.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Color.fromRGBO(0, 160, 227, 1))),
                onPressed: () {
                  Navigator.pop(context,true);
                },
                padding: EdgeInsets.all(5.0),
                color: Color.fromRGBO(0, 160, 227, 1),
                textColor: Colors.white,
                child: Text("확인",
                    style: TextStyle(fontSize: 15)),
              ),
            ),

          ],
        ),
      ),
    ),
  );



}