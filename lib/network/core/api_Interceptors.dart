import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:filmsystem/data/models/base_model.dart';
import 'package:filmsystem/network/core/api_string.dart';
import 'package:filmsystem/network/core/base_request.dart';
import 'package:filmsystem/utils/log.dart';

/// @ClassName ApiInterceptors
/// @Description 全局通信拦截器
/// @Author summer
/// @Date 2021/11/26 3:42 下午
/// @Version 1.0.1

class ApiInterceptors {
  static interceptors(BaseRequest request) {
    return InterceptorsWrapper(onRequest: (options, handler) {
      if (request.isShowLoading) {
        EasyLoading.show(status: request.loadingMsg);
      }
      log('请求地址:' + options.baseUrl + options.path);
      log('请求头信息:' + options.headers.toString());
      if (request.httpMethod == HttpMethod.get) {
        log('请求参数:' + options.queryParameters.toString());
      } else {
        log('请求参数:' + request.params.toString());
      }
      // Do something before request is sent
      return handler.next(options); //continue
      // 如果你想完成请求并返回一些自定义数据，你可以resolve一个Response对象 `handler.resolve(response)`。
      // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义response.
      // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象,如`handler.reject(error)`，
      // 这样请求将被中止并触发异常，上层catchError会被调用。
    }, onResponse: (res, handler) async {
      // Do something with response data
      if (request.isShowLoading) {
        EasyLoading.dismiss();
      }
      var statusCode = res.statusCode ?? -1;
      if (statusCode == 200) {
        log(res.data);
        BaseModel baseModel = BaseModel.fromJson(res.data);
        if (baseModel.code != code_success && request.isIntercept) {
          if (baseModel.message?.isNotEmpty ?? false) {
            EasyLoading.showToast(baseModel.message ?? '',
                toastPosition: EasyLoadingToastPosition.bottom);
            return handler.reject(
                DioError(response: res, requestOptions: res.requestOptions));
          }
        }
      }
      return handler.next(res); // continue
      // 如果你想终止请求并触发一个错误,你可以 reject 一个`DioError`对象,如`handler.reject(error)`，
      // 这样请求将被中止并触发异常，上层catchError会被调用。
    }, onError: (DioError e, handler) {
      if (request.isShowLoading) {
        EasyLoading.dismiss();
      }
      // Do something with response error
      return handler.next(e); //continue
      // 如果你想完成请求并返回一些自定义数据，可以resolve 一个`Response`,如`handler.resolve(response)`。
      // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义response.
    });
  }
}
