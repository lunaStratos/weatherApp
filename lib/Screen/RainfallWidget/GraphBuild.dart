
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:rainvow_mobile/Domain/Kma3TimeDomain.dart';

class GraphBuild extends StatelessWidget{

  List <Kma3TimeDomain> getKmaWeatherList = [];
  List <dynamic> getRainvowList = [];
  List <Kma3TimeDomain> getKmaWeatherMakeList = [];

  double tempTemperature = 28;

  GraphBuild({required this.getKmaWeatherList, required this.getRainvowList});
  double maxY = 0;

  @override
  Widget build(BuildContext context) {

    print('getRainvowList=> ${getRainvowList}');
    print('getKmaWeatherList=> ${getKmaWeatherList}');


    //자르기
    getKmaWeatherList = (getKmaWeatherList.length != 0 ? getKmaWeatherList.sublist(0,4) : getKmaWeatherList);



    for(int i = 0 ; i < getRainvowList.length ; i++){
      tempTemperature > maxY ? maxY = tempTemperature : maxY;
      // int.parse(getRainvowList[i]['rainfall_rate']) > maxY ? maxY = int.parse(getRainvowList[i]['rainfall_rate']): "";
    }
    for(int i = 0 ; i < getKmaWeatherList.length ; i++){
      double.parse(getKmaWeatherList[i].temperature) > maxY ? maxY = double.parse(getKmaWeatherList[i].temperature): "" ;
    }

    print('maxY ${maxY}');

    return AspectRatio(
      aspectRatio: 2.5,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          gradient: LinearGradient(
            colors: [
              Color(0xffa3f0ff), // 바닥색
              Color(0xffe9fffc), // 천장 색
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
                  height: 10,
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                    child: LineChart(
                      _weatherDataList(),
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

    LineChartData _weatherDataList() {
    return LineChartData(

      lineTouchData: LineTouchData(
        /**
         * 툴팁 설정 및 표시
         * */
        touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
            fitInsideHorizontally: true,

            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              int idx = 0 ;
              return touchedBarSpots.map((barSpot) {
                idx++;
                String desc = "레인보우: ";
                switch(idx){
                  case 0:
                    desc = "레인보우: ";
                    break;
                  case 1:
                    desc = "기상청: ";
                    break;
                }
                print('barSpot ${barSpot}');
                return LineTooltipItem(

                  '${desc} ${barSpot.x} 시: ${barSpot.y}',
                  TextStyle(
                      fontSize: 15,
                      color: (idx == 1) ? Colors.blueGrey : Colors.amber
                  ),
                );
              }).toList();
            }

        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: false,
      ),
      /**
       * X축 →
       * */
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            // print('leftTitles ${value.toInt()}');
            // print('getRainvowList ${getRainvowList}');
            if(getRainvowList.isNotEmpty){
              return getRainvowList[value.toInt()]['forecast_target_time'].substring(8, 10) + "시";
            }else{
              switch(value.toInt()){
                case 0:
                  return "12시";
                case 1:
                  return "13시";
                case 2:
                  return "14시";
                case 3:
                  return "15시";
                case 4:
                  return "16시";
                case 5:
                  return "17시";
              }
            }

            return "12시";
          },
        ),
        /**
         * Y축 ↑
         * */
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            //print('leftTitles2 $value');
            switch (value.toInt()) {
              case 0:
                return '0';
              case 10:
                return '10';
              case 20:
                return '20';
              case 30:
                return '30';
              case 40:
                return '40';
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
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: Color(0xff4e4965),
              width: 2,
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
      /**
       * Double사용
       * maxX → : 0부터 시작함 0일때는 0으로, 0이 아닐때는  length-1로
       * maxY ↑ : 0부터 시작
       * */
      minX: 0,
      maxX: (getRainvowList.length !=0 ? getRainvowList.length - 1 : getRainvowList.length) +0.0,
      maxY: (maxY+5.0),
      minY: 0,
      lineBarsData: linesBarData(),
    );
  }

  List<LineChartBarData> linesBarData() {

    // 레인보우 데이터
    List<FlSpot> lineRainvowList = [];
    // 기상청 데이터
    List<FlSpot> lineKmaWeatherList = [];

    print('getKmaWeatherList /  ${getKmaWeatherList}');
    print('getRainvowList / ${getRainvowList}');

    List <Kma3TimeDomain> getKmaWeatherTempList = [];
    /**
     * 레인보우 리스트를 기준으로 만든다.
     * */
    int beforeIndex = 0;
    for(int i = 0 ; i< getRainvowList.length ; i++){

      String forecast_target_time = getRainvowList[i]['forecast_target_time']; //yyyyMMddHHmmSS
      String target_time = forecast_target_time.substring(8, 12);
      num rainfall_rate = getRainvowList[i]['rainfall_rate'];
      double rainfall_amount = getRainvowList[i]['rainfall_amount'];

      double idx = (i == 0 ? 0.0 : i+0.0);
      lineRainvowList.add(FlSpot(idx, tempTemperature - i));

      bool isReal = false;
      // addOn
      if(getKmaWeatherList.isNotEmpty){
        for(int j = 0 ; j< getKmaWeatherList.length ; j++){
          print("count : ${target_time }  ${getKmaWeatherList[j].target_time } ${ target_time  == getKmaWeatherList[j].target_time }" );

          if(target_time.toString() == getKmaWeatherList[j].target_time.toString()){
            isReal = true;
            break;
          }

        }
        print('isreal ${isReal} ${beforeIndex}');
        if(isReal){
          getKmaWeatherTempList.add(getKmaWeatherList[beforeIndex]);
          beforeIndex++;
        }else{
          getKmaWeatherTempList.add(getKmaWeatherList[beforeIndex]);
        }

      }

    }

    for(int i = 0 ; i< getKmaWeatherTempList.length ; i++){
      print('getKmaWeatherTempList ${getKmaWeatherTempList[i].target_time} ${getKmaWeatherTempList[i].temperature} ${i}');

      String target_time = getKmaWeatherTempList[i].target_time; //HHmm
      String rainfall_amount = getKmaWeatherTempList[i].rainfall_mm;
      String rainfall_rate = getKmaWeatherTempList[i].rainfall_rate;
      String temperature = getKmaWeatherTempList[i].temperature;

      double idx = (i == 0 ? 0.0 : i+0.0);

      lineKmaWeatherList.add(FlSpot(idx, double.parse(temperature)));
    }


    return [
      LineChartBarData(
        spots: lineRainvowList,
        isCurved: true,
        colors: const [
          Color(0x99aa4cfc),
        ],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
        ),
        belowBarData: BarAreaData(show: true, colors: [
          const Color(0x33aa4cfc),
        ]),
      ),
      LineChartBarData(
        spots: lineKmaWeatherList,
        isCurved: true,
        colors: const [
          Color(0x4427b6fc),
        ],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
        ),
        belowBarData: BarAreaData(show: true, colors: [
          const Color(0x33e0bdff),
        ]),
      ),
    ];
  }


}
