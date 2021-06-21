
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:rainvow_mobile/Screen/RainfallWidget/WeatherMap.dart';
/**
 * 맵 모듈 -
 * */
class MapScreen extends StatefulWidget{

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return WeatherMap(latitude: "37.5665",longitude: "126.9780");
  }

}