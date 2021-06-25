import 'package:flutter/cupertino.dart';
import 'package:http_interceptor/http_interceptor.dart';

/**
 * api 사용시 로그 인터셉터
 * */
class LoggingInterceptor implements InterceptorContract {

  /**
   * 요청 로그 
   * */
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    debugPrint('interceptRequest ${data}');
    return data;
  }
  
  /**
   * 응답 로그
   * */
  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    debugPrint('interceptResponse ${data}');

    return data;
  }

}