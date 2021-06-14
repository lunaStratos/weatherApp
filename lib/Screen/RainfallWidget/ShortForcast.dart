import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  List <dynamic> getdataList = [];

  @override
  void initState() {
    super.initState();
    _getKmaNowWeatherApi();
  }

  /**
   * 현재날씨 API 불러오기
   * */
  Future <void> _getKmaNowWeatherApi() async {
    final resultArray = await ApiCall.getWeatherUltraForecast(rect_id);
    setState(() {
      getdataList = resultArray;
    });

  }

  @override
  Widget build(BuildContext context) {

    buildGraphDangiList();
    print('getdataList2 => ${getdataList}');

    if(getdataList.isNotEmpty){
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

    /**
     * 3개의 DataRow 생성해야 함.
     * cell < DataRow
     */
    List <DataRow> arr = [];
    List <DataCell> timeAndWeatherList = [];
    List <DataCell> humidityList = [];
    List <DataCell> temperatureList = [];
    List <DataCell> windList = [];

    for(int k = 0 ; k < getdataList.length ; k++){

      var timeAndWeatherCell = DataCell(
          new Column(
              children: [
                Text('${ (getdataList[k]["targetTime"]).toString().substring(0,2) }시'),
                Image.asset('${Util.kmaForecastImg(getdataList[k]["weatherType"], getdataList[k]["rainfallType"])}', width: 30, height: 30 ,),
              ],
          ) // 오전

      );
      timeAndWeatherList.add(timeAndWeatherCell);

      var humidityCell = DataCell(Text('${getdataList[k]["humidity"]} %'));
      humidityList.add(humidityCell);

      /**
       * 바람 세기와 각도
       * */
      var windCell = DataCell(
            new Column(
                children: [
                    Text('${getdataList[k]["windStrength"]} m/s'),

                    new RotationTransition(
                    turns: new AlwaysStoppedAnimation( int.parse(getdataList[k]["windDirection"]) / 360),
                    child: Image.asset('assets/images/windforce.png', width: 30, height: 30 ,),
                    )
              ],
        ) // 오전
      );
      windList.add(windCell);

      var temperatureCell = DataCell(Text('${getdataList[k]["temperature"]}도'));
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

    for(int i = 0 ; i < getdataList.length ; i++){
      arr.add(DataColumn(label: Text('')));
    }

    if(getdataList.length == 0){
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
        print('index ${index} ');
        print('tooltipsOnBar ${tooltipsOnBar[0].spots}');
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