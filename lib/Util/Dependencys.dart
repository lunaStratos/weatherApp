library my_prj.globals;

import 'package:flutter/material.dart';

/** 의존성 파일
 * desc: static한 내용 넣기
 * */
class Dependencys {

  static const int httpRetry = 10;                                                           // retry 횟수
  static const String appapiAddress = "http://rainvow.net/api/service/appapi";               //API address
  static const String testappapiAddress = "http://6571cc808359.ngrok.io/api/service/appapi"; //TEST API address
  static const AppBackGroundColor = Color(0xffe9ecee);      // 앱 배경색
  static const GraphBackGroundColor = Color(0xffebf6ff);    // 레인보우&기상청 그래프 배경색
  static const SunRiseBackGroundColor = Color(0xffebf6ff);  // 일출일몰 배경색
  static const SwitchColor = Color(0xff2790e);              // 스위치 on toggle 색상
  static const GraphRainvowLineColor = Color(0x99aa4cfc);
  static const GraphKmaLineColor = Color(0x4427b6fc);

}