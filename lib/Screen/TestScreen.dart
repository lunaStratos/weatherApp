import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rainvow_mobile/Domain/WeatherGraphData.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


/**
 * 테스트 모듈
 * desc: 테스트 모듈, prod시 사용하지 말것
 * */

/**
 * 메모장
 * https://blog.logrocket.com/flutter-push-notifications-with-firebase-cloud-messaging/
 * https://console.firebase.google.com/u/1/project/studioxrainvow/notification/compose
 * */


class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        title: 'Notify',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        debugShowCheckedModeBanner: false,
        home: TestScreen2(),
      ),
    );
  }
}


class TestScreen2 extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<TestScreen2> {

  List<WeatherGraphData> datas = [
    WeatherGraphData('06시', 35, Colors.red),
    WeatherGraphData('07시', 28, Colors.green),
    WeatherGraphData('08시', 34, Colors.blue),
    WeatherGraphData('09시', 32, Colors.pink),
    WeatherGraphData('10시', 40, Colors.black),
    WeatherGraphData('11시', 40, Colors.black),
    WeatherGraphData('12시', 40, Colors.black),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
              height: 100,
                child: SfCartesianChart(

                    /**
                     * X축 ←→ max-min
                     * */
                    primaryXAxis: CategoryAxis(
                      majorGridLines: MajorGridLines(width: 0),
                      axisLine: AxisLine(width: 0),
                      isVisible: false
                    ),
                    /**
                     * Y축 ↑↓ max-min
                     * */
                    primaryYAxis: CategoryAxis(
                      minimum: 20,
                      maximum: 50,
                      majorGridLines: MajorGridLines(width: 0),
                      axisLine: AxisLine(width: 0),
                      isVisible: false
                    ),

                    series: <ChartSeries>[
                      LineSeries<WeatherGraphData, String>(
                          /**
                           * 툴팁 언제나 보이기
                           * */
                          dataLabelSettings: DataLabelSettings(isVisible : true),
                          /**
                           * 데이터 영역
                           * */
                          dataSource: datas,
                          pointColorMapper: (WeatherGraphData item, _) => item.segmentColor,
                          xValueMapper: (WeatherGraphData item, _) => item.timeStr,
                          yValueMapper: (WeatherGraphData item, _) => item.temperature,

                      )
                    ]
                )
            )


        )
    );
  }


}
