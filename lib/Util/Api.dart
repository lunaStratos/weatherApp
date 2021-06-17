import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:rainvow_mobile/Util/LoggingInterceptor.dart';
import 'package:rainvow_mobile/Util/MyRetryPolicy.dart';


/**
 * 각종 Util 모음
 * */
class Api {

  /**
   * RETRY 모듈
   * */
  static http.Client client = HttpClientWithInterceptor.build(interceptors: [LoggingInterceptor()], retryPolicy: MyRetryPolicy(),);

  /**
   * GET api call
   * */
  static Future<List<dynamic>> callapi(String address) async {
    bool loadRemoteDatatSucceed = false;

    var data1;
    try {
      //response = await http.get(Uri.parse(address));//필요 api 호출
      final response = await client.get(Uri.parse(address));
      // final response = await retry(
      //       () => http.get(Uri.parse(address)).timeout(Duration(seconds: 5)),
      //   maxAttempts: 8,
      //   maxDelay: Duration(seconds: 3),
      //   retryIf: (e) => e is TimeoutException,
      // );


      if (response.statusCode == 200) {
        loadRemoteDatatSucceed = true;
      }

      // print('response ${response.statusCode} ${loadRemoteDatatSucceed}');
      // print('response ${address} ${response.body} ');

      data1 = utf8.decode(response.bodyBytes);

    } catch (e) {
      print(e);
    }

    return json.decode(data1);
  }

  /**
   * GET api call
   * */
  static Future<dynamic> callapiObject(String address) async {

    var data1;//api 호출을 통해 받은 정보를 json으로 바꾼 결과를 저장한다.
    try {
      final response = await client.get(Uri.parse(address));
      data1 = utf8.decode(response.bodyBytes);
    } catch (e) {
      print(e);
    }

    return json.decode(data1);
  }

  /**
   * POST api call
   * */
  static Future<dynamic> sendPost(String address, jsonObject) async {
    var x = await http.post(
      Uri.parse(address),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonObject
      ,
    );

    print("post result : ${x.body}");
    return x;
  }


}
