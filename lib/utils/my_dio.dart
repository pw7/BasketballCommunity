import 'package:dio/dio.dart';

class MyDio {
  static Dio dio;

  static Dio createDio() {
    if (dio == null) {
      var options = BaseOptions(
        baseUrl: "http://172.17.150.225:8080/",
        contentType: Headers.formUrlEncodedContentType,
      );
      dio = new Dio(options);
    }
    return dio;
  }
}
