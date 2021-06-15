
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:rainvow_mobile/Screen/RainfallWidget/WeatherMap.dart';
/**
 * 테스트 모듈
 * desc: 테스트 모듈, prod시 사용하지 말것
 * */
class TestScreen extends StatefulWidget{

  @override
  _TestScreen createState() => _TestScreen();
}

class _TestScreen extends State<TestScreen> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return WeatherMap(longitude: "127", latitude:"38");
  }

}