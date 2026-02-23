// ignore_for_file: camel_case_types

import 'package:dio/dio.dart';

class diohelper {
  static Dio? dio;
  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.weatherapi.com/v1/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response?> getdata({
    required String url,
    Map<String, dynamic>? query,
    String lang = 'en',
  }) async {
    dio!.options.headers = {
      'accept': 'application/json'
    };
    return await dio!.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'accept': 'text/plain',
    };
    return dio!.post(url, data: data);
  }

  static Future<Response> putData({
    required String url,
    Map<String, dynamic>? query,
    required var data,
    String lang = 'en',
    String? token,
  }) async {
    dio!.options.headers = {
      'accept': 'text/plain',
      'Authorization': 'Bearer $token',
    };
    return dio!.put(url, queryParameters: query, data: data);
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    dio!.options.headers = {
      'Authorization': 'Bearer $token',
    };
    return dio!.delete(url);
  }
}
