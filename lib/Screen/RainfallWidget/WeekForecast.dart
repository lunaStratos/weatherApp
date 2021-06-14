import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainvow_mobile/Screen/AlertWidget/LoadingWidget.dart';
import 'package:rainvow_mobile/Util/ApiCall.dart';
import 'package:rainvow_mobile/Util/Util.dart';

/**
 * 강우지도 - 4.중기날씨
 * APi : 중기날씨예보(날씨상태), 중기날씨예보온도(온도)
 * */
class WeekForecast extends StatefulWidget{

  String rect_id = "4102000004265";

  WeekForecast({required this.rect_id});
  @override
  _WeekForecastState createState() => _WeekForecastState(this.rect_id);

}

class _WeekForecastState extends State<WeekForecast>{
  String rect_id = "4102000004265";
  bool flag = false;
  _WeekForecastState(this.rect_id);

  List<dynamic> getMidtermList = [];
  List<dynamic> getMidtermTempList = [];

  @override
  void initState() {
    super.initState();
    _getKmaWeekWeatherApi().then((value){
      _getKmaWeekTempWeatherApi().then((value2){
        setState(() {
          flag = true;
        });
      });
    });

  }

  /**
   * 현재날씨 API 불러오기
   * */
  Future<String> _getKmaWeekWeatherApi() async {
    final resultArray = await ApiCall.getKmaMidTermForecast(rect_id);
    print('resultObj ${resultArray}');
    getMidtermList = resultArray;

    return "ok";
  }

  /**
   * 현재날씨 API 불러오기
   * */
  Future<String> _getKmaWeekTempWeatherApi() async {
    final resultArray = await ApiCall.getKmaMidTermForecastTemperate(rect_id);
    print('resultObj _getKmaWeekTempWeatherApi ${resultArray}');
    getMidtermTempList = resultArray;

    return "ok";
  }

  @override
  Widget build(BuildContext context) {

    print('getMidterm getMidtermList.length ${getMidtermList.length}');
    print('getMidterm getMidtermTempList.length ${getMidtermTempList.length}');
    print('getMidterm getMidtermList ${getMidtermList}');
    print('getMidterm getMidtermTempList ${getMidtermTempList}');
    print('getMidterm flag ${flag}');

    if(flag){
      if(getMidtermTempList.isNotEmpty && getMidtermList.isNotEmpty){
        return new Container(
          // height: weekForecastHeightSize,
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
                  horizontalMargin: 30,
                  columnSpacing: 40,    // 컬럼사이즈
                  columns: [
                    DataColumn(label: Text('')),
                    DataColumn(label: Text('오전')),
                    DataColumn(label: Text('오후')),
                    DataColumn(label: Text('눈/비\n확률')),
                  ],
                  rows: _DataRowList(context)

              ),

              Material(
                  child: InkWell(
                    onTap: () {
                      print('adjust');
                    },
                    child: Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child:Icon(Icons.adjust),
                      ),),
                  )
              )

            ],
          ),
        );
      }else{
        return LoadingWidget();
      }

    }else{
      return LoadingWidget();

    }


  }

  /**
   * for문 날짜 표현
   * */
  List<DataRow> _DataRowList(BuildContext context){
    List <DataRow> arr = [];
    DateTime date = new DateTime.now();

    for(int i = 0 ; i< getMidtermTempList.length; i++){
      print(getMidtermList[i]["rainfallRateAm"]);

      int startindex = i+3; // 3 부터 시작

      double percentageDouble = ( int.parse('${getMidtermList[i]["rainfallRateAm"]}') + int.parse('${getMidtermList[i]["rainfallRatePm"]}')  ) /2 ;
      int percentage = (percentageDouble.round());
      var datetemp = date.add(Duration(days: startindex));
      var xScreen = DataRow(cells: [
        DataCell(Text('${datetemp.month}.${datetemp.day} \n ${Util.dayStr(datetemp.weekday)}')),
        DataCell(new Row(
          children: [
            Image.asset('${Util.weekImageAddress(getMidtermList[i]["weatherDescAm"])}', width: 30, height: 30 ,),
            Text('${getMidtermTempList[i]["temperatureMin"]}°C'),
          ],
        )
        ),
        DataCell(new Row(
          children: [
            Image.asset('${Util.weekImageAddress(getMidtermList[i]["weatherDescPm"])}', width: 30, height: 30 ,),
            Text('${getMidtermTempList[i]["temperatureMax"]}°C'),
          ],
        ) // 오후
        ),
        DataCell(
            Text('${percentage}%')
        ),
      ]);
      arr.add(xScreen);
    }
    return arr;
  }
  
}