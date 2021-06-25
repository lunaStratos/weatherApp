import 'package:http_interceptor/http_interceptor.dart';
import 'package:rainvow_mobile/Util/Dependencys.dart';

/**
 * http intercepter retry 모듈
 * 10번 재시도
 * */
class MyRetryPolicy extends RetryPolicy {

    @override
    int maxRetryAttempts = Dependencys.httpRetry; //10번

    @override
    Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
        print(response.statusCode);
        if (response.statusCode == 500) {
          return true;
        }
        return false;
    }



}