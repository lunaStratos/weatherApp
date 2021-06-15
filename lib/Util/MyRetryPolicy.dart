import 'package:http_interceptor/http_interceptor.dart';
import 'package:rainvow_mobile/Util/Dependencys.dart';

/**
 * http intercepter retry 모듈
 * 10번
 * */
class MyRetryPolicy extends RetryPolicy {

    @override
    int maxRetryAttempts = Dependencys.httpRetry;

    @override
    Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
        print(response.statusCode);
        if (response.statusCode == 500) {
          print("Perform your token refresh here in 500");
          return true;
        }
        return false;
    }



}