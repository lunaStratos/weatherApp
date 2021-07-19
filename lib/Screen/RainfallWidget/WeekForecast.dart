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
    final resultArray2 = await ApiCall.getKmaMidTermForecastTemperature(rect_id);

      getMidtermTempList = resultArray2;
      getMidtermList = resultArray;

    return "ok";
  }


  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

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
                  dividerThickness: 0,

                  horizontalMargin: 30,
                  columnSpacing: 30,    // 컬럼사이즈
                  columns: [
                    DataColumn(label: Container(
                      alignment: Alignment.center,
                      width: width *.05 ,
                      child: Text(''),
                    )),
                    DataColumn(label: Container(
                      alignment: Alignment.center,
                      width: width *.1 ,
                      child: Text('오전'),
                    )),
                    DataColumn(label: Container(
                      alignment: Alignment.center,
                      width: width *.02 ,
                      child: Text(''),
                    )),
                    DataColumn(label: Container(
                      alignment: Alignment.center,
                      width: width *.1 ,
                      child: Text('오후'),
                    )),
                    DataColumn(label: Container(
                      alignment: Alignment.center,
                      width: width *.1 ,
                      child: Text('눈/비\n확률'),
                    )),
                  ],
                  /**
                   * 데이터 부분 
                   * */
                  rows: _DataRowList(context)

              ),

              /**
               * 접기 펼치기 버튼
               * */
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
   * 접으면 3개, 펼치면 7개
   * */
  List<DataRow> _DataRowList(BuildContext context){
    List <DataRow> arr = [];
    DateTime date = new DateTime.now();

    openFlag ? arrayLength = getMidtermTempList.length : arrayLength = 3;
    
    for(int i = 0 ; i < arrayLength; i++){

      int startindex = i+3; // 3 부터 시작

      double percentageDouble = ( int.parse('${getMidtermList[i]["rainfallRateAm"]}') + int.parse('${getMidtermList[i]["rainfallRatePm"]}')  ) /2 ;
      int percentage = (percentageDouble.round());
      var datetemp = date.add(Duration(days: startindex));
      var xScreen = DataRow(cells: [
        /**
         * 날짜
         * */
        DataCell(Text('${datetemp.month}.${datetemp.day} \n ${Util.dayStr(datetemp.weekday)}')),
        /**
         * 오전
         * */
        DataCell(new Row(
            children: [
              Image.asset('${Util.weekImageAddress(getMidtermList[i]["weatherDescAm"])}', width: 30, height: 30 ,),
              Text('${getMidtermTempList[i]["temperatureMin"]}°C'),
            ],
          )
        ),
        DataCell(
          new Row(
            children: [
              Container(
                width: 1,
                height: 25,
                color: Colors.grey[400],
              ),
            ],
          )
        ),
        /**
         * 오후
         * */
        DataCell(new Row(
          children: [
            Image.asset('${Util.weekImageAddress(getMidtermList[i]["weatherDescPm"])}', width: 30, height: 30 ,),
            Text('${getMidtermTempList[i]["temperatureMax"]}°C'),
          ],
        ) // 오후
        ),
        /**
         * 눈/비 확률
         * */
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
   * 접기 펼치기 대응
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
        heightResized = 420.0;
        iconArrow = Icons.arrow_circle_up;
        openFlag = true;
      });
    }

  }
  
}