import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

/// @ClassName BaseRequest
/// @Description 封装的request
/// @Author liuwang
/// @Date 2021/11/26 3:42 下午
/// @Version 1.0.1

enum HttpMethod { get, post }

enum EnvironmentType { dev, pre, product } //环境

///基础请求
class BaseRequest {
  EnvironmentType envType = EnvironmentType.dev;

  ///请求头
  Map<String, String> header = {};

  ///请求参数
  Map<String, dynamic> params = {};

  ///文件path
  String? filePath;

  ///文件名
  String? fileName;

  ///上传文件
  FormData data = FormData.fromMap({});

  ///是否请求异常拦截CustomToast, 默认拦截
  bool isIntercept = true;

  ///请求是否显示loading狂
  bool isShowLoading = true;

  ///加载laading文字
  String loadingMsg = '加载中...';


  ///域名
  String host() {
    switch (envType) {
      case EnvironmentType.dev:
        return 'https://192.168.2.200/';
      case EnvironmentType.pre:
        return 'https://p-api.castcards.com/';
      case EnvironmentType.product:
        return 'https://api.castcards.com/';
      default:
        return 'https://api.castcards.com/';
    }
  }

  String h5Host() {
    switch (envType) {
      case EnvironmentType.dev:
        return 'https://t-h5.castcards.com/';
      case EnvironmentType.pre:
        return 'https://p-h5.castcards.com/';
      case EnvironmentType.product:
        return 'https://h5.castcards.com/';
      default:
        return 'https://h5.castcards.com/';
    }
  }

  ///请求方式
  HttpMethod httpMethod = HttpMethod.get;

  ///请求路径 /path
  String path = '';

  ///单个字段添加参数 param
  BaseRequest add(String k, dynamic v) {
    params[k] = v;
    return this;
  }

  ///单个字段添加到header
  BaseRequest addHeader(String k, String v) {
    header[k] = v;
    return this;
  }

  ///直接map复制 参数
  addParamsMap(Map<String, dynamic> v) {
    params = v;
  }

  ///直接map复制 参数
  addHeaderMap(Map<String, String> v) {
    header = v;
  }

  ///直接map复制 参数v
  addDataMap(Map<String, Object> v) {
    data = FormData.fromMap(v);
  }

  //添加请求头公共参数
  Future<String> addUserAgent() async {
    //userAgent
    return "";
  }
}
