import 'package:http_interceptor/http_interceptor.dart';

/**
 * api 사용시 로그 인터셉터
 * */
class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    print('interceptRequest ${data}');
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    print('interceptResponse ${data}');
    print('interceptResponse statusCode ${data.statusCode}');

    return data;
  }

}