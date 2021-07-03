import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainvow_mobile/Domain/WeatherGraphData.dart';
import 'package:rainvow_mobile/Screen/AlertWidget/LoadingWidget.dart';
import 'package:rainvow_mobile/Util/ApiCall.dart';
import 'package:rainvow_mobile/Util/Util.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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


  final List<int> showIndexes = [0,1,2,3,4,5,6];
  List<LineChartBarData> tooltipsOnBar = [];
  List <dynamic> getData1HourList = [];
  List <dynamic> getData3HourList = [];
  List<WeatherGraphData> temperatureGraphList = [];
  List<int> maxmin = [];

  double widthSize = 60.0;
  double heightSize = 45.0;
  double heightWindSize = 55.0;


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

    if(getData3HourList.isNotEmpty){
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: new Container(
          width: 430,
          height: 240,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10.0),
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0),
            ),
          ),
          child: Padding(padding: EdgeInsets.symmetric(vertical: 10),child: new Column(
            children:  _buildDataRow2(context)

            /**
                [DataTable(
                horizontalMargin: 10,
                columnSpacing: 30,    // 컬럼사이즈
                dataRowHeight: 60,
                columns: _buildColumn(context),
                headingRowHeight: 0, //컬럼 숨기기

                rows: _buildDataRow(context)
                ),
                _buildTemperatureGraph(context)]
             */
            ,
          ),)
        ),
      );
    }else{
      return LoadingWidget();
    }

  }

  /**
   * 행 정보 표시 - 시간, 날씨, 습도, 온도, 풍향풍속
   * */
  List<Widget> _buildDataRow2(BuildContext context){
    final now = DateTime.now();


    int nowMonth = getData3HourList.isNotEmpty ? int.parse(getData3HourList[0]["targetDate"].toString().substring(4,6))  : now.month;
    int nowDay = getData3HourList.isNotEmpty ? int.parse(getData3HourList[0]["targetDate"].toString().substring(6,8)) : now.day;

    /**
     * 3개의 DataRow 생성해야 함.
     * cell < DataRow
     */
    List <Widget> arr = [];
    List <Widget> timeAndWeatherList = [];
    List <Widget> humidityList = [];
    List <Widget> temperatureList = [];
    List <Widget> windList = [];


    for(int k = -1 ; k < getData3HourList.length ; k++){

      if(k == -1){
        timeAndWeatherList.add(
              SizedBox(
                  width: widthSize , height: heightSize, child: Center(
                  child: Text('${nowMonth}.${nowDay}일', style: TextStyle(fontSize: 16)),
                  )
              )
        );
        humidityList.add(
            SizedBox(
              width: widthSize,height: heightSize,child: Center( child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ Text('습도', style: TextStyle(fontSize: 16))
            ]
        ))));
        windList.add(SizedBox(
          width: widthSize,height: heightWindSize, child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('풍향', style: TextStyle(fontSize: 14)),
            Text('풍속', style: TextStyle(fontSize: 14))
          ],
        ))));
        temperatureList.add(
            SizedBox(
            width: widthSize,height: heightSize,child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('온도', style: TextStyle(fontSize: 16),)
          ],
        ))));

      }else{

        /**
         * 시간과 날씨 이미지
         * */
        String weatherType = getData3HourList[k]["weatherType"];
        String rainfallType = getData3HourList[k]["rainfallType"];

        var timeAndWeatherCell =
        SizedBox(
            width: widthSize,child: Center(child:  Column(
              children: [
                Text('${ (getData3HourList[k]["targetTime"]).toString().substring(0,2) }시'),
                Image.asset('${Util.kmaForecastImg(weatherType, rainfallType)}', width: 30, height: 30 ,),
              ]
            )));
        timeAndWeatherList.add(timeAndWeatherCell);

        /**
         * 습도
         * */
        var humidityCell = SizedBox(
          width: widthSize,child: Center(child: Text('${getData3HourList[k]["humidity"]} %')));
        humidityList.add(humidityCell);

        /**
         * 바람 세기와 각도
         * */
        var windCell =
        SizedBox(
            width: widthSize,child: Center(child:  Column(
              children: [
                Text('${getData3HourList[k]["windStrength"]}m/s', style: TextStyle(fontSize: 12),),

                new RotationTransition(
                  turns: new AlwaysStoppedAnimation( getData3HourList[k]["windDirection"] / 360),
                  child: Image.asset('assets/images/windforce.png', width: 30, height: 30 ,),
                )
              ],
            )));
        windList.add(windCell);

        /**
         * 온도
         * */

        var temperatureCell = SizedBox(
            width: widthSize,child: Center(child: Text('${getData3HourList[k]["temperature"]}도')));
        maxmin.add(int.parse(getData3HourList[k]["temperature"].toString()));
        temperatureGraphList.add(WeatherGraphData('${ (getData3HourList[k]["targetTime"]).toString().substring(0,2) }시', int.parse(getData3HourList[k]["temperature"].toString()), Colors.black38));
        temperatureList.add(temperatureCell);

      }
      maxmin.sort(); //←작은수, →큰수

      }


    arr.add(Row(children: timeAndWeatherList));
    arr.add(Row(children: humidityList));
    arr.add(_buildTemperatureGraph(context));
    //arr.add(Row(children: temperatureList));
    arr.add(Row(children: windList));
    return arr;
  }

  /**
   * 행 정보 표시 - 시간, 날씨, 습도, 온도, 풍향풍속
   * */
  List<DataRow> _buildDataRow(BuildContext context){
    final now = DateTime.now();
    int nowMonth = getData3HourList.isNotEmpty ? int.parse(getData3HourList[0]["targetDate"].toString().substring(4,6))  : now.month;
    int nowDay = getData3HourList.isNotEmpty ? int.parse(getData3HourList[0]["targetDate"].toString().substring(6,8)) : now.day;

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

    for(int k = 0 ; k < getData3HourList.length ; k++){


      /**
       * 시간과 날씨 이미지
       * */
      String weatherType = getData3HourList[k]["weatherType"];
      String rainfallType = getData3HourList[k]["rainfallType"];

      var timeAndWeatherCell = DataCell(
          new Column(
              children: [
                Text('${ (getData3HourList[k]["targetTime"]).toString().substring(0,2) }시'),
                Image.asset('${Util.kmaForecastImg(weatherType, rainfallType)}', width: 30, height: 30 ,),
              ],
          ) // 오전

      );
      timeAndWeatherList.add(timeAndWeatherCell);

      /**
       * 습도
       * */
      var humidityCell = DataCell(Text('${getData3HourList[k]["humidity"]} %'));
      humidityList.add(humidityCell);

      /**
       * 바람 세기와 각도
       * */
      var windCell = DataCell(
            new Column(
                children: [
                    Text('${getData3HourList[k]["windStrength"]}m/s', style: TextStyle(fontSize: 12),),

                    new RotationTransition(
                    turns: new AlwaysStoppedAnimation( getData3HourList[k]["windDirection"] / 360),
                    child: Image.asset('assets/images/windforce.png', width: 30, height: 30 ,),
                    )
              ],
        ) // 오전
      );
      windList.add(windCell);

      /**
       * 온도
       * */

      var temperatureCell = DataCell(Text('${getData3HourList[k]["temperature"]}도'));
      maxmin.add(int.parse(getData3HourList[k]["temperature"].toString()));
      temperatureGraphList.add(WeatherGraphData('${ (getData3HourList[k]["targetTime"]).toString().substring(0,2) }시', int.parse(getData3HourList[k]["temperature"].toString()), Colors.black38));
      temperatureList.add(temperatureCell);

    }
    maxmin.sort(); //←작은수, →큰수

    arr.add(DataRow(cells: timeAndWeatherList));
    arr.add(DataRow(cells: humidityList));
    arr.add(DataRow(cells: temperatureList));
    arr.add(DataRow(cells: windList));
    return arr;
  }

  List<DataColumn> _buildColumn(BuildContext context) {
      List <DataColumn> arr = [];

      for(int i = 0 ; i < getData3HourList.length+1 ; i++){
        arr.add(DataColumn(label: Text('')));
      }

      if(getData3HourList.length == 0){
        arr.add(DataColumn(label: Text('')));
      }

      return arr;
  }

  /**
   * 온도 그래프
   * */
  Widget _buildTemperatureGraph(BuildContext context) {

    return Container(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                  SizedBox(
                  width: widthSize,height: heightSize,child: Center( child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ Text('온도', style: TextStyle(fontSize: 16))
                  ]))),

                    Container(
                      width: getData3HourList.length * widthSize,
                      child: SfCartesianChart(
                          plotAreaBorderWidth: 0,
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
                              minimum: maxmin[0]-5.0,
                              maximum: maxmin[maxmin.length-1]+0.0,
                              majorGridLines: MajorGridLines(width: 0),
                              axisLine: AxisLine(width: 0),
                              isVisible: false
                          ),

                          series: <ChartSeries>[
                            LineSeries<WeatherGraphData, String>(
                              /**
                               * 툴팁 언제나 보이기
                               * */
                              width: 1,

                              dataLabelSettings: DataLabelSettings(
                                isVisible : true,
                                labelAlignment: ChartDataLabelAlignment.bottom
                              ),
                              /**
                               * 데이터 영역
                               * */
                              dataSource: temperatureGraphList,
                              pointColorMapper: (WeatherGraphData item, _) => item.segmentColor,
                              xValueMapper: (WeatherGraphData item, _) => item.timeStr,
                              yValueMapper: (WeatherGraphData item, _) => item.temperature,
                              markerSettings: MarkerSettings(
                                  isVisible: true
                              )
                            )
                          ]
                      ),
                    )
                  ],
                )
            );

  }




}