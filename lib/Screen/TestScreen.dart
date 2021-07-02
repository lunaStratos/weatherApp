import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    series: <ChartSeries>[
                      LineSeries<SalesData, String>(
                          dataLabelSettings: DataLabelSettings(isVisible : true),
                          dataSource: [
                            SalesData('Jan', 35, Colors.red),
                            SalesData('Feb', 28, Colors.green),
                            SalesData('Mar', 34, Colors.blue),
                            SalesData('Apr', 32, Colors.pink),
                            SalesData('May', 40, Colors.black)
                          ],
                          // Bind the color for all the data points from the data source
                          pointColorMapper: (SalesData sales, _) =>
                          sales.segmentColor,
                          xValueMapper: (SalesData sales, _) => sales.year,
                          yValueMapper: (SalesData sales, _) => sales.sales
                      )
                    ]
                )
            )
        )
    );
  }


}

class SalesData {
  SalesData(this.year, this.sales, this.segmentColor);
  final String year;
  final double sales;
  final Color segmentColor;
}