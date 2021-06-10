

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainvow_mobile/Domain/Kma3TimeDomain.dart';
import 'package:rainvow_mobile/Screen/AlertWidget/LoadingWidget.dart';
import 'package:rainvow_mobile/Screen/RainfallWidget/GraphBuild.dart';
import 'package:rainvow_mobile/Util/ApiCall.dart';

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
    _getKmaWeather3TimeApi().then((value){
      _getRainvowInfoForecast().then((value){

        setState(() {
          flag = true;
        });
      });
    });

  }


  List <Kma3TimeDomain> getKmaWeatherList = [];
  List <dynamic> getRainvowList = [];
  List <Kma3TimeDomain> getKmaWeatherMakeList = [];


  /**
   * KMA 기상청 API
   * */
  Future <void>  _getKmaWeather3TimeApi() async {
    final resultArray = await ApiCall.getWeatherForecast(rect_id);
    print('resultArray  => ${resultArray}' );
    getKmaWeatherList = resultArray.map((item){
      print('item rainfall_type ${item['rainfall_type'].runtimeType}');

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

  @override
  Widget build(BuildContext context) {
    print('getKmaWeatherList ${getKmaWeatherList}');
    print('getRainvowList ${getRainvowList}');


    if(flag){
      return new Container(
        width: 400,
        height: 280,
        decoration: BoxDecoration(
          color: Color(0xff90c8d5),
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
                children: [
                  Text('강수예보', style: TextStyle(fontSize: 20),textAlign: TextAlign.left,),
                ],
              ),
            ),
            /**
             * =================== [그래프영역] ===================
             * */
            GraphBuild(getKmaWeatherList: getKmaWeatherList, getRainvowList:getRainvowList),

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