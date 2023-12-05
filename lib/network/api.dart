import 'package:filmsystem/utils/log.dart';
import 'core/dio_adapter.dart';
import './core/api_error.dart';
import 'core/api_adapter.dart';
import 'core/base_request.dart';

/// @ClassName Api
/// @Description 请求工具类
/// @Author liuwang
/// @Date 2021/11/26 3:42 下午
/// @Version 1.0.1

///1.支持网络库插拔设计，且不干扰业务层
///2.基于配置请求请求，简洁易用
///3.Adapter设计，扩展性强
///4.统一异常和返回处理

class Api {
  static final Api _instance = Api._internal();

  Api._internal();

  factory Api() {
    return _instance;
  }

  ///get || post
  Future fire(BaseRequest request) async {
    ApiResponse? response;
    try {
      response = await _send(request);
    } on ApiError catch (e) {
      response?.data = e.data;
      log(e.message);
    } catch (e, stack) {
      log(e.toString(), trace: stack);
    }
    var error;
    var statusCode = response?.statusCode ?? -1;
    switch (statusCode) {
      case 200:
        return response;
      default:
        error = ApiError(statusCode, response.toString(), data: response);
        break;
    }
    throw error;
  }

  ///上传文件 必须post
  Future upload(BaseRequest request) async {
    ApiResponse? response;
    try {
      response = await _upload(request);
    } on ApiError catch (e) {
      response?.data = e.data;
      log(e.message);
    } catch (e, stack) {
      log(e.toString(), trace: stack);
    }
    var error;
    var statusCode = response?.statusCode ?? -1;
    switch (statusCode) {
      case 200:
        return response;
      default:
        error = ApiError(statusCode, response.toString(), data: response);
        break;
    }
    throw error;
  }

  Future<ApiResponse<T>> _send<T>(BaseRequest request) async {
    ApiAdapter adapter = DioAdapter();
    return await adapter.send(request);
  }

  Future<ApiResponse<T>> _upload<T>(
      BaseRequest request) async {
    ApiAdapter adapter = DioAdapter();
    return await adapter.upload(request);
  }

  ///取消特定token网路请求
  void cancel(String tag) {
    ApiAdapter adapter = DioAdapter();
    adapter.cancel(tag);
  }

  ///取消全部网络请求
  void cancelAll() {
    ApiAdapter adapter = DioAdapter();
    adapter.cancelAll();
  }
}
