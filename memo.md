# 작업중 메모

https://pub.dev/packages/flutter_local_notifications
https://github.com/samarthagarwal/FlutterScreens

ㅡ 어제한일
앱 개발 설정 구성
ㅡ오늘할일
앱 개발 설정 구성 및 로직구현, 저장소 구현

https://soulpark.wordpress.com/2013/01/15/ios-local-notifications/
https://developer.android.com/training/notify-user/build-notification?hl=ko
https://idlecomputer.tistory.com/326


# 자주쓰는 로직

/**
     * 토스트
     * warning: 에뮬레이터 확인불가
     * */
    Fluttertoast.showToast(
        msg: "This is Center Short Toast ${counter}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
    
    
    
    (text){
                    print('Text submit: $text');
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => _saveFavoriteLocationData(),
                    );
                  },
                  