import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:rainvow_mobile/Domain/Kma3TimeDomain.dart';
import 'package:rainvow_mobile/Domain/RainvowKma1TimeDomain.dart';
import 'package:rainvow_mobile/Util/Dependencys.dart';

/**
 * 레인보우 - 기상청 그래프 빌드
 * 건드릴려면 메인 개발자에게 말하고 건드릴것
 * */
class GraphBuild extends StatelessWidget{

  List <Kma3TimeDomain> getKmaWeatherList = [];
  List <dynamic> getRainvowList = [];
  List <Kma3TimeDomain> getKmaWeatherMakeList = [];
  List <RainvowKma1TimeDomain> getRainvowKmaList = [];

  double tempTemperature = 28;
  double maxY = 0;

  GraphBuild({required this.getKmaWeatherList, required this.getRainvowList, required this.getRainvowKmaList});


  @override
  Widget build(BuildContext context) {

    print('getRainvowList=> ${getRainvowList}');
    print('getKmaWeatherList=> ${getKmaWeatherList}');
    print('getRainvowKmaList=> ${getRainvowKmaList}');


    //자르기
    getKmaWeatherList = (getKmaWeatherList.length != 0 ? getKmaWeatherList.sublist(0,4) : getKmaWeatherList);

    /**
     * 그래프 max 값 얻는 부분
     * */
    // for(int i = 0 ; i < getRainvowList.length ; i++){
    //   tempTemperature > maxY ? maxY = tempTemperature : maxY; //임시
    //   // int.parsegetRainvowList([i]['rainfall_rate']) > maxY ? maxY = int.parse(getRainvowList[i]['rainfall_rate']): "";
    // }

    for(int i = 0 ; i < getRainvowKmaList.length ; i++){
      double rainvowMm = (getRainvowKmaList[i].rainfallAmountRainvow);
      double kmaMm = (getRainvowKmaList[i].rainfallAmountKma);

      rainvowMm > maxY ? maxY = rainvowMm : 0.0;
      kmaMm > maxY ? maxY = kmaMm : 0.0;
    }

    // for(int i = 0 ; i < getKmaWeatherList.length ; i++){
    //   double.parse(getKmaWeatherList[i].temperature) > maxY ? maxY = double.parse(getKmaWeatherList[i].temperature): "" ;
    // }

    return AspectRatio(
      aspectRatio: 2.5,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          gradient: LinearGradient(
            colors: [
              Dependencys.GraphBackGroundColor, // 바닥색
              Dependencys.GraphBackGroundColor, // 천장 색
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
                return LineTooltipItem(
                  '${desc} ${barSpot.y}mm',
                  TextStyle(
                      fontSize: 15,
                      color: (idx == 1) ? Colors.cyan : Colors.amber
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

            // if(getRainvowList.isNotEmpty){
            //   return getRainvowList[value.toInt()]['forecast_target_time'].substring(8, 10) + "시";
            // }else{
            //   switch(value.toInt()){
            //     case 0:
            //       return "12시";
            //     case 1:
            //       return "13시";
            //     case 2:
            //       return "14시";
            //     case 3:
            //       return "15시";
            //     case 4:
            //       return "16시";
            //     case 5:
            //       return "17시";
            //   }
            // }

            if(getRainvowKmaList.isNotEmpty){
              return getRainvowKmaList[value.toInt()].target_time.substring(0, 2) + "시";
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
      // minX: 0,
      // maxX: (getRainvowList.length !=0 ? getRainvowList.length - 1 : getRainvowList.length) +0.0,
      // maxY: (maxY+5.0),
      // minY: 0,
      // lineBarsData: linesBarData(),

      minX: 0,
      maxX: (getRainvowKmaList.length !=0 ? getRainvowKmaList.length - 1 : getRainvowKmaList.length) +0.0,
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
    print('getRainvowKmaList / ${getRainvowKmaList}');

    List <Kma3TimeDomain> getKmaWeatherTempList = [];
    /**
     * 레인보우 리스트를 기준으로 만든다.
     * */
    // int beforeIndex = 0;
    // for(int i = 0 ; i< getRainvowList.length ; i++){
    //
    //   String forecast_target_time = getRainvowList[i]['forecast_target_time']; //yyyyMMddHHmmSS
    //   String target_time = forecast_target_time.substring(8, 12);
    //   num rainfall_rate = getRainvowList[i]['rainfall_rate'];
    //   double rainfall_amount = getRainvowList[i]['rainfall_amount'];
    //
    //   double idx = (i == 0 ? 0.0 : i+0.0);
    //   lineRainvowList.add(FlSpot(idx, tempTemperature - i));
    //
    //   bool isReal = false;
    //   // addOn
    //   if(getKmaWeatherList.isNotEmpty){
    //     for(int j = 0 ; j< getKmaWeatherList.length ; j++){
    //       print("count : ${target_time }  ${getKmaWeatherList[j].target_time } ${ target_time  == getKmaWeatherList[j].target_time }" );
    //
    //       if(target_time.toString() == getKmaWeatherList[j].target_time.toString()){
    //         isReal = true;
    //         break;
    //       }
    //
    //     }
    //     print('isreal ${isReal} ${beforeIndex}');
    //     if(isReal){
    //       getKmaWeatherTempList.add(getKmaWeatherList[beforeIndex]);
    //       beforeIndex++;
    //     }else{
    //       getKmaWeatherTempList.add(getKmaWeatherList[beforeIndex]);
    //     }
    //
    //   }
    //
    // }
    //
    // for(int i = 0 ; i< getKmaWeatherTempList.length ; i++){
    //   print('getKmaWeatherTempList ${getKmaWeatherTempList[i].target_time} ${getKmaWeatherTempList[i].temperature} ${i}');
    //
    //   String target_time = getKmaWeatherTempList[i].target_time; //HHmm
    //   String rainfall_amount = getKmaWeatherTempList[i].rainfall_mm;
    //   String rainfall_rate = getKmaWeatherTempList[i].rainfall_rate;
    //   String temperature = getKmaWeatherTempList[i].temperature;
    //
    //   double idx = (i == 0 ? 0.0 : i+0.0);
    //
    //   lineKmaWeatherList.add(FlSpot(idx, double.parse(temperature)));
    // }

    /**
     * 데이터 분리
     * lineRainvowList : 레인보우
     * lineKmaWeatherList: 기상청
     * double로 입력해야 함.
     * */
    for(int i = 0 ; i < getRainvowKmaList.length; i++){
      double rainvowValue = double.parse(getRainvowKmaList[i].rainfallAmountRainvow.toStringAsFixed(1));
      double kmaValue = double.parse(getRainvowKmaList[i].rainfallAmountKma.toStringAsFixed(1));

      double idx = (i == 0 ? 0.0 : i+0.0);
      lineRainvowList.add(FlSpot(idx+0.0, rainvowValue));
      lineKmaWeatherList.add(FlSpot(idx+0.0, kmaValue));
    }

    return [
      /**
       * Rainvow 데이터 표시
       * */
      LineChartBarData(
        spots: lineRainvowList,
        isCurved: true,
        colors: const [
          Dependencys.GraphRainvowLineColor
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
      /**
       * KMA 기상청 데이터 표시
       * */
      LineChartBarData(
        spots: lineKmaWeatherList,
        isCurved: true,
        colors: const [
          Dependencys.GraphKmaLineColor
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
