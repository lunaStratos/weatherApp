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

  double heightResized = 250.0;
  var iconArrow = Icons.arrow_circle_down;
  bool openFlag = false;    // 열기 true, 닫기 false
  int arrayLength = 0;


  List<dynamic> getMidtermList = [];
  List<dynamic> getMidtermTempList = [];

  _WeekForecastState(this.rect_id);


  @override
  void initState() {
    super.initState();
    _getKmaWeekWeatherApi().then((value1){
      setState(() {
        flag = true;
      });
    });

  }

  /**
   * 현재날씨 API 불러오기
   * */
  Future<String> _getKmaWeekWeatherApi() async {
    final resultArray = await ApiCall.getKmaMidTermForecast(rect_id);
    print('resultObj _getKmaWeekWeatherApi ${resultArray}');
    final resultArray2 = await ApiCall.getKmaMidTermForecastTemperature(rect_id);
    print('resultObj _getKmaWeekTempWeatherApi ${resultArray}');

      getMidtermTempList = resultArray2;
      getMidtermList = resultArray;

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
          height: heightResized,
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
                    onTap: () => _onOpenClose(context),
                    child: Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child:Icon(iconArrow),
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

    openFlag ? arrayLength = getMidtermTempList.length : arrayLength = 3;


    for(int i = 0 ; i < arrayLength; i++){
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

  /**
   * 컨테이너 확장 축소 모델
   * */
  _onOpenClose(BuildContext context) {

    if(openFlag){
      //닫기 눌렀을때
      setState(() {
        heightResized = 250.0;
        iconArrow = Icons.arrow_circle_down;
        openFlag = false;
      });
    }else{
      //열기 눌렀을 때
      setState(() {
        heightResized = 580.0;
        iconArrow = Icons.arrow_circle_up;
        openFlag = true;
      });
    }

  }
  
}