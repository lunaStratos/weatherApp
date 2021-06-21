import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainvow_mobile/Util/Util.dart';


/**
 * image animated
 * for mainWeather
 * */
class AnimatedImage extends StatefulWidget {

  String weatherConditions = "0";
  AnimatedImage({required this.weatherConditions});

  @override
  _AnimatedImageState createState() => _AnimatedImageState(weatherConditions: weatherConditions);
}

class _AnimatedImageState extends State<AnimatedImage>
    with SingleTickerProviderStateMixin {

  String weatherConditions = "0";
  _AnimatedImageState({required this.weatherConditions});
  double opacityDouble = 0.0;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    /**
     * 영상 시간
     * */
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  late final Animation<Offset> _animation = Tween<Offset>(
    begin: Offset.zero,
    end: Offset(0, -0.11), // ■ X→, Y↑
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(milliseconds: 200), () {
      print("Yeah, this line is printed after 1 seconds");
      setState(() {
        opacityDouble = 1.0;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image.asset('assets/images/clouds.png'),
        Container(
          margin: EdgeInsets.only(left: 20, top: 100, right: 20, bottom: 50),
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 5), // changes position of shadow
              ),
            ],
          ),
        ),
        SlideTransition(
          position: _animation,
          child: AnimatedOpacity(opacity: opacityDouble ,duration: Duration(seconds: 1),child: Image.asset('${Util.kmaNowImgAddress(weatherConditions)}'),),
        ),
      ],
    );
  }
}