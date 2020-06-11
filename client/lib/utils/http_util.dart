import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'toast_util.dart';
import '../routers/routers.dart';

var dio;

class HttpUtil {
  static HttpUtil get instance => _getInstance();

  static HttpUtil _httpUtil;

  static HttpUtil _getInstance() {
    if (_httpUtil == null) {
      _httpUtil = HttpUtil();
    }
    return _httpUtil;
  }

  HttpUtil() {
    BaseOptions options = BaseOptions(
        connectTimeout: 5000,
        receiveTimeout: 5000,
        contentType: 'application/x-www-form-urlencoded');
    dio = new Dio(options);
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options) async {
          print("========================请求数据===================");
          print("url=${options.uri.toString()}");
          print("params=${options.data}");

          // dio.lock();
          //  await SharedPreferencesUtils.getToken().then((token) {
          //     options.headers[Strings.TOKEN] = token;
          //   });
          // dio.unlock();
          return options;
        },
        onResponse: (Response response) {
          print("========================请求数据===================");
          print("code=${response.statusCode}");
          print("response=${response.data}");
          print("errcode=${response.data['errcode']}");
          if (response.data['errcode'].toString() == "10006" ||
              response.data['errcode'].toString() == "2") {
            Future.delayed(Duration(seconds: 1), () {
              Routes.navigatorKey.currentState.pushNamedAndRemoveUntil(
                  "/", ModalRoute.withName(Routes.root));
            });
          }
        },
        onError: (DioError error) async {
          print("========================请求错误===================");
          print("message =${error.response}");
          print(error.response == null);
          if (error.response == null) {
            print('null');
            ToastUtil.showToast('网络连接超时');
          } else if (error.response.statusCode == 404) {
            ToastUtil.showToast('服务器错误');
          } else if (json
                  .decode(error.response.toString())['errcode']
                  .toString() ==
              "2") {
            ToastUtil.showToast(
                json.decode(error.response.toString())['errmsg']);
            final prefs = await SharedPreferences.getInstance();
            await prefs.clear();
            await Future.delayed(Duration(seconds: 1), () {
              Routes.navigatorKey.currentState.pushNamedAndRemoveUntil(
                  "/", ModalRoute.withName(Routes.root));
            });
          } else {
            ToastUtil.showToast(
                json.decode(error.response.toString())['errmsg']);
          }
        },
      ),
    );
  }

  get(String url, {Map<String, dynamic> parameters, Options options}) async {
    Response response;
    if (parameters != null && options != null) {
      response =
          await dio.get(url, queryParameters: parameters, options: options);
    } else if (parameters != null && options == null) {
      response = await dio.get(url, queryParameters: parameters);
    } else if (parameters == null && options != null) {
      response = await dio.get(url, options: options);
    } else {
      response = await dio.get(url);
    }
    return response.data;
  }

  post(String url, {Map<String, dynamic> parameters, Options options}) async {
    Response response;
    if (parameters != null && options != null) {
      response = await dio.post(url, data: parameters, options: options);
    } else if (parameters != null && options == null) {
      response = await dio.post(url, data: parameters);
    } else if (parameters == null && options != null) {
      response = await dio.post(url, options: options);
    } else {
      response = await dio.post(url);
    }
    return response.data;
  }
}
