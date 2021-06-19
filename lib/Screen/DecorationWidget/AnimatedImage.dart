import 'package:flutter/cupertino.dart';
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
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image.asset('assets/images/clouds.png'),
        SlideTransition(
          position: _animation,
          child: Image.asset('${Util.kmaNowImgAddress(weatherConditions)}'),
        ),
      ],
    );
  }
}
