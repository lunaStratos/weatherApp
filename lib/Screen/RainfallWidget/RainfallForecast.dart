import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainvow_mobile/Domain/Kma3TimeDomain.dart';
import 'package:rainvow_mobile/Domain/RainvowKma1TimeDomain.dart';
import 'package:rainvow_mobile/Screen/AlertWidget/LoadingWidget.dart';
import 'package:rainvow_mobile/Screen/RainfallWidget/GraphBuild.dart';
import 'package:rainvow_mobile/Util/ApiCall.dart';
import 'package:rainvow_mobile/Util/Dependencys.dart';

/**
 * 강우지도 - 5. 강수예보그래프
 * */
class RainfallForecast extends StatefulWidget {

  String rect_id = "";
  RainfallForecast({required this.rect_id});

  @override
  _RainfallState createState() => _RainfallState(rect_id: this.rect_id);

}

class _RainfallState extends State<RainfallForecast>{

  String rect_id = "4102000004265";

  _RainfallState({required this.rect_id});

  bool flag = false;


  @override
  void initState() {
    super.initState();
    // _getKmaWeather3TimeApi().then((value){
    //   _getRainvowInfoForecast().then((value){
    //
    //     setState(() {
    //       flag = true;
    //     });
    //   });
    // });

    _getRainvowKmaInfoForecast().then((value){
      setState(() {
        flag = true;
      });
    });


  }


  List <Kma3TimeDomain> getKmaWeatherList = [];
  List <dynamic> getRainvowList = [];
  List <Kma3TimeDomain> getKmaWeatherMakeList = [];
  List <RainvowKma1TimeDomain> getRainvowKmaList = [];


  /**
   * KMA 기상청 API - 동네예보(3시간)
   * */
  Future <void>  _getKmaWeather3TimeApi() async {
    final resultArray = await ApiCall.getWeatherForecast(rect_id);
    getKmaWeatherList = resultArray.map((item){

      return Kma3TimeDomain.fromJson(item);
    }).toList();

  }

  /**
   * 레인보우 API
   * */
  Future <void>  _getRainvowInfoForecast() async {
    final resultArray = await ApiCall.getRainvowInfoForecast(rect_id);
    getRainvowList = resultArray;
  }

  /**
   * 레인보우 API 통합본
   * */
  Future <void>  _getRainvowKmaInfoForecast() async {
    final resultArray = await ApiCall.getRainvowKmaInfoForecast(rect_id);
    getRainvowKmaList = resultArray.map((item) {
      return RainvowKma1TimeDomain.fromJson((item));
    }).toList();


  }

  @override
  Widget build(BuildContext context) {

    if(flag){
      return new Container(
        width: 400,
        height: 280,
        decoration: BoxDecoration(
          color: Dependencys.GraphBackGroundColor,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10.0),
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
          ),
        ),
        child: new Column(
          children: [
            new Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('강수예보', style: TextStyle(fontSize: 20),textAlign: TextAlign.left,),
                  /**
                   * 데이터 라인 색상 설명
                   * */
                  Row(
                   children: [
                     SizedBox(
                       width: 20.0,
                       height: 20.0,
                       child: const DecoratedBox(
                         decoration: const BoxDecoration(
                             color: Dependencys.GraphRainvowLineColor
                         ),
                       ),
                     ),
                     Text(' 레인보우'),
                     SizedBox(
                       width: 20.0,
                       height: 20.0,
                       child: const DecoratedBox(
                         decoration: const BoxDecoration(
                             color: Dependencys.GraphKmaLineColor
                         ),
                       ),
                     ),
                     Text(' 기상청')
                   ],
                  )
                ],
              ),
            ),
            /**
             * =================== [그래프영역] ===================
             * */
            GraphBuild(getKmaWeatherList: getKmaWeatherList, getRainvowList:getRainvowList, getRainvowKmaList: getRainvowKmaList,),
            /**
             * =================== [그래프영역] ===================
             * */
            const SizedBox(
              height: 15,
            ),

            Text('* 레인보우 데이터 측정 기준: 500m/ 10분전',
              style: TextStyle(color: Color(
                  0xff767676)),textAlign: TextAlign.left,
            ),
            Text('* 기상청 데이터 측정 기준: 00시 00분', style: TextStyle(color: Color(0xff767676)),),
          ],
        ),
      );
    }else{
      return LoadingWidget();
    }

  }

}