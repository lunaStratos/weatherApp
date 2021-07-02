import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rainvow_mobile/Screen/AlertWidget/LoadingWidget.dart';
import 'package:rainvow_mobile/Util/ApiCall.dart';
import 'package:rainvow_mobile/Util/Util.dart';

/**
 * 강우지도 - 3.단기예보
 * */
class ShortForecast extends StatefulWidget {

  String rect_id = "";
  ShortForecast({required this.rect_id});

  @override
  _ShortForecastState createState() => _ShortForecastState(rect_id: this.rect_id);

}
class _ShortForecastState extends State<ShortForecast> {

  String rect_id = "";
  _ShortForecastState({required this.rect_id});

  List <FlSpot> dataList = [
    FlSpot(0, -10),
    FlSpot(1, -6),
    FlSpot(2, 8),
    FlSpot(3, -2),
    FlSpot(4, 5),
    FlSpot(5, 10),
    FlSpot(6, 12),
  ];

  final List<int> showIndexes = [0,1,2,3,4,5,6];
  List<LineChartBarData> tooltipsOnBar = [];
  List <dynamic> getData1HourList = [];
  List <dynamic> getData3HourList = [];

  @override
  void initState() {
    super.initState();
    _getKmaNowWeatherApi1Hour();
    _getKmaNowWeatherApi3Hour();

  }

  /**
   * 현재날씨 API 불러오기 - 1시간
   * */
  Future <void> _getKmaNowWeatherApi1Hour() async {
    final resultArray = await ApiCall.getKmaWeather1Hour(rect_id);
    setState(() {
      getData1HourList = resultArray;
    });

  }

  /**
   * 현재날씨 API 불러오기간 - 3시간 
   * */
  Future <void> _getKmaNowWeatherApi3Hour() async {
    final resultArray = await ApiCall.getKmaWeather3Hour(rect_id);
    setState(() {
      getData3HourList = resultArray;
    });

  }

  @override
  Widget build(BuildContext context) {

    buildGraphDangiList();

    if(getData1HourList.isNotEmpty){
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: new Container(
          width: 420,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10.0),
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0),
            ),
          ),
          child: new Column(
            children: [
              DataTable(
                  horizontalMargin: 10,
                  columnSpacing: 30,    // 컬럼사이즈
                  dataRowHeight: 60,
                  columns: _buildColumn(context),
                  headingRowHeight: 0, //컬럼 숨기기

                  rows: _buildDataRow(context)
              ),

              // SingleChildScrollView(
              //   child: new Container(
              //     width: 1500,
              //     child: buildGraphDangiForecast(context),
              //   )
              // )

            ],
          ),
        ),
      );
    }else{
      return LoadingWidget();
    }

  }

  List<DataRow> _buildDataRow(BuildContext context){
    final now = DateTime.now();
    int nowMonth = getData1HourList.isNotEmpty ? int.parse(getData1HourList[0]["targetDate"].toString().substring(4,6))  : now.month;
    int nowDay = getData1HourList.isNotEmpty ? int.parse(getData1HourList[0]["targetDate"].toString().substring(6,8)) : now.day;

    /**
     * 3개의 DataRow 생성해야 함.
     * cell < DataRow
     */
    List <DataRow> arr = [];
    List <DataCell> timeAndWeatherList = [];
    List <DataCell> humidityList = [];
    List <DataCell> temperatureList = [];
    List <DataCell> windList = [];

    timeAndWeatherList.add(DataCell(
        new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${nowMonth}.${nowDay}일', style: TextStyle(fontSize: 16)),
          ],
        ) // 오전
      )
    );

    humidityList.add(
        DataCell(
            new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ Text('습도', style: TextStyle(fontSize: 16))
                 ]
           )
        )
    );

    windList.add(
        DataCell(new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('풍향', style: TextStyle(fontSize: 14)),
            Text('풍속', style: TextStyle(fontSize: 14))
          ],
        ))
    );

    temperatureList.add(DataCell(
      new Column(
         mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('온도', style: TextStyle(fontSize: 16),)
           ],
      ))
    );

    for(int k = 0 ; k < getData1HourList.length ; k++){

      /**
       * 시간과 날씨 이미지
       * */
      var timeAndWeatherCell = DataCell(
          new Column(
              children: [
                Text('${ (getData1HourList[k]["targetTime"]).toString().substring(0,2) }시'),
                Image.asset('${Util.kmaForecastImg(getData1HourList[k]["weatherType"], getData1HourList[k]["rainfallType"])}', width: 30, height: 30 ,),
              ],
          ) // 오전

      );
      timeAndWeatherList.add(timeAndWeatherCell);

      /**
       * 습도
       * */
      var humidityCell = DataCell(Text('${getData1HourList[k]["humidity"]} %'));
      humidityList.add(humidityCell);

      /**
       * 바람 세기와 각도
       * */
      var windCell = DataCell(
            new Column(
                children: [
                    Text('${getData1HourList[k]["windStrength"]} m/s'),

                    new RotationTransition(
                    turns: new AlwaysStoppedAnimation( int.parse(getData1HourList[k]["windDirection"]) / 360),
                    child: Image.asset('assets/images/windforce.png', width: 30, height: 30 ,),
                    )
              ],
        ) // 오전
      );
      windList.add(windCell);

      /**
       * 온도
       * */
      var temperatureCell = DataCell(Text('${getData1HourList[k]["temperature"]}도'));
      temperatureList.add(temperatureCell);

    }

    arr.add(DataRow(cells: timeAndWeatherList));
    arr.add(DataRow(cells: humidityList));
    arr.add(DataRow(cells: temperatureList));
    arr.add(DataRow(cells: windList));

    return arr;
  }

  List<DataColumn> _buildColumn(BuildContext context) {
    List <DataColumn> arr = [];

    for(int i = 0 ; i < getData1HourList.length+1 ; i++){
      arr.add(DataColumn(label: Text('')));
    }

    if(getData1HourList.length == 0){
      arr.add(DataColumn(label: Text('')));
    }

    return arr;
}



  Widget buildGraphDangiForecast(BuildContext context) {
    return AspectRatio(
      aspectRatio: 5,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Colors.transparent
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                const SizedBox(
                  height: 37,
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                    child: LineChart(
                      _weatherDangiDataList(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  LineChartData _weatherDangiDataList() {
    return LineChartData(

      showingTooltipIndicators: showIndexes.map((index) {

        return ShowingTooltipIndicators([
          LineBarSpot(
              tooltipsOnBar[0], tooltipsOnBar.indexOf(tooltipsOnBar[0]), tooltipsOnBar[0].spots[index]),
        ]
        );
      }).toList(),

      backgroundColor: Colors.transparent,
      lineTouchData: LineTouchData(
        /**
         * 툴팁 설정 및 표시
         * */
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: false,
      ),
      gridData: FlGridData(
        show: false,
        drawHorizontalLine: true,
        drawVerticalLine: false,
      ),
      /**
       * X축
       * */
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: false, //===================X축안보이기
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '13시';
              case 1:
                return '14시';
              case 2:
                return '15시';
              case 3:
                return '16시';
              case 4:
                return '17시';
              case 5:
                return '18시';
            }
            return '';
          },
        ),
        /**
         * Y축
         * */
        leftTitles: SideTitles(
          showTitles: false,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case -10:
                return '1';
              case -5:
                return '22';
              case 0:
                return '3m';
              case 5:
                return '5m';
              case 10:
                return '6m';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      /**
       * 바닥 선
       * */
      borderData: FlBorderData(
          show: false,
          border: const Border(
            bottom: BorderSide(
              color: Color(0xff4e4965),
              width: 1,
            ),
            left: BorderSide(
              color: Colors.transparent,
            ),
            right: BorderSide(
              color: Colors.transparent,
            ),
            top: BorderSide(
              color: Colors.transparent,
            ),
          )
      ),

      minX: 0,
      maxX: 6,
      maxY: 8,
      minY: -10,

      lineBarsData: tooltipsOnBar,
    );
  }


  /**
   * 그래프
   * */
  List<LineChartBarData> buildGraphDangiList(){

    final arr =  [
      LineChartBarData(
        showingIndicators: showIndexes ,

        spots: dataList,
        isCurved: true,
        colors: const [
          Color(0x99aa4cfc),
        ],
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
        ),
        belowBarData: BarAreaData(show: true, colors: [
          const Color(0x33aa4cfc),
        ]),
      )
    ];

    setState(() {
      tooltipsOnBar = arr;
    });

    return tooltipsOnBar;
  }

}