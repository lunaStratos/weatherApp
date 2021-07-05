import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rainvow_mobile/Screen/AlertWidget/LoadingWidget.dart';
import 'package:rainvow_mobile/Util/ApiCall.dart';
import 'package:rainvow_mobile/Util/Dependencys.dart';

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

    if(flag){
      
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

    
      return new Container(
        decoration: BoxDecoration(
          color: Dependencys.SunRiseBackGroundColor,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10.0),
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
          ),
        ),
        child: new Column(
          children: [
            new Padding(padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: new Row(
                children: [
                  Text('일출일몰', style: TextStyle(fontSize: 20),textAlign: TextAlign.left,),
                ],
              ),
            ),

            SizedBox(
              height: 20,
            ),

            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /**
                 * 동적 시간 표시
                 * */
                Text('${sunriseDate.month}월 ${sunriseDate.day}일', style: TextStyle(fontSize: 16),textAlign: TextAlign.left,),
                new Column(
                  children: [
                    Container(
                      width: 250,
                      child: new Column(

                        children: [

                          /**
                           * 배경 사진 위에 태양이 올라가야 하기 때문에 Stack으로 표시
                           * */
                          new Stack(

                            children: [
                              /**
                               * 180도 이미지 표시
                               * */
                              Image.asset("assets/images/sun_back.png"),

                              /**
                               * 태양 표시
                               * */
                              Positioned(
                                top: -20,
                                right: 0,
                                width: 250,
                                child: sunNowDegree != 0 ? (new RotationTransition(
                                    /**
                                     * 태양 각도 === sunNowDegree
                                     * */
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