import 'package:http_interceptor/http_interceptor.dart';


class MyRetryPolicy extends RetryPolicy {

    @override
    int maxRetryAttempts = 10;

    @override
    Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
        print(response.statusCode);
        if (response.statusCode == 500) {
          print("Perform your token refresh here in 401");
          return true;
        }
        return false;
    }



}