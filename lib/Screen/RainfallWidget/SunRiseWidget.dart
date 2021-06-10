

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rainvow_mobile/Screen/AlertWidget/LoadingWidget.dart';
import 'package:rainvow_mobile/Util/ApiCall.dart';

/**
 * 강우지도 - 7.일춞일몰
 * */
class SunRiseWidget extends StatefulWidget {

  String longitude = "128";
  String latitude = "37";
  SunRiseWidget({required this.longitude, required this.latitude});

  @override
  _SunRiseWidget createState() => _SunRiseWidget(this.longitude, this.latitude);

}

class _SunRiseWidget extends State<SunRiseWidget>{

  Map<String, dynamic> getDataList = {};
  String longitude = "128";
  String latitude = "37";
  _SunRiseWidget(this.longitude, this.latitude);
  bool flag = false;
  /**
   * Api 불러오기
   * */
  Future <String> _getApi() async{
    final resultArray = await ApiCall.getNowSunSet(longitude, latitude);
    getDataList = resultArray as Map<String, dynamic>;
    return "ok";
  }

  @override
  void initState() {
    _getApi().then((value){
      setState(() {
        flag = true;
      });
    }); // 데이터 불러오기
  }


  @override
  Widget build(BuildContext context) {

    final sunriseDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(getDataList['sunrise']);
    final sunsetDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(getDataList['sunset']);
    final now = DateTime.now();

    int sunNow = (now.hour * 60 + now.minute);

    int sunriseNum = sunriseDate.hour * 60 + sunriseDate.minute;
    int sunsetNum = sunsetDate.hour * 60 + sunsetDate.minute;

    int sunAllDegree = sunsetNum - sunriseNum;

    int sunNowDegree = ((360 * ( (sunNow - sunriseNum) / sunAllDegree))/2).round();

    // 현재시각이 아닌경우 0도로 변환
    (sunNow  < sunriseNum || sunNow > sunsetNum) ? sunNowDegree = 0 : "";

    if(flag){
      return new Container(
        decoration: BoxDecoration(
          color: Colors.white38,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10.0),
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
          ),
        ),
        child: new Column(
          children: [
            new Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: new Row(
                children: [
                  Text('일출일몰', style: TextStyle(fontSize: 20),textAlign: TextAlign.left,),
                ],
              ),
            ),

            Text('일출 : ${sunriseDate.year}년 ${sunriseDate.month}월 ${sunriseDate.day}일 ${sunriseDate.hour}시 ${sunriseDate.minute}분'),
            Text('일몰 : ${sunsetDate.year}년 ${sunsetDate.month}월 ${sunsetDate.day}일 ${sunsetDate.hour}시 ${sunsetDate.minute}분'),
            Text('sunNowDegree ${sunNowDegree}'),
            Text('sunAllDegree ${sunAllDegree}'),
            Text('sunNow ${sunNow}'),
            Text('sunriseNum ${sunriseNum}'),
            Text('sunsetNum ${sunsetNum}'),


            SizedBox(
              height: 20,
            ),

            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('${sunriseDate.month}월 ${sunriseDate.day}일', style: TextStyle(fontSize: 16),textAlign: TextAlign.left,),
                new Column(
                  children: [
                    Container(
                      width: 250,
                      child: new Column(

                        children: [
                          new Stack(

                            children: [
                              Image.asset("assets/images/sun_back.png"),
                              Positioned(
                                top: -10,
                                right: 0,
                                width: 250,
                                child: sunNowDegree != 0 ? (new RotationTransition(
                                    turns: new AlwaysStoppedAnimation(sunNowDegree/ 360),
                                    child: Image.asset('assets/images/sun_degree.png', height: 280)
                                )
                                ) : Container()
                              ),
                            ],
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${sunriseDate.hour}시 ${sunriseDate.minute}분'),
                              Text('${sunsetDate.hour}시 ${sunsetDate.minute}분'),
                            ],
                          )
                        ],
                      )

                    ),
                  ],
                )

              ],
            )

          ],
        ),
      );
    }else{
      return LoadingWidget();
    }

  }

}