
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * 커스텀 로딩
 * */
class LoadingWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 20,
        width: 20,
        margin: EdgeInsets.all(5),
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor : AlwaysStoppedAnimation(Colors.white),
        ),
      ),
    );
  }


}