import 'package:flutter/cupertino.dart';

/**
 * 단기 그래프 domain
 * */
class WeatherGraphData {
  WeatherGraphData(this.timeStr, this.temperature, this.segmentColor);
  final String timeStr;
  final int temperature;
  final Color segmentColor;
}