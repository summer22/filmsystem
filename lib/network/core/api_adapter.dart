import 'dart:convert';
import 'base_request.dart';

/// @ClassName ApiAdapter
/// @Description 网络请求适配器
/// @Author liuwang
/// @Date 2021/11/26 3:42 下午
/// @Version 1.0.1

///上传成功
typedef SuccessCallback<NetResponse> = void Function(ApiResponse);

///上传进度
typedef UploadProgressCallback = void Function(int sent, int total);

///网络请求抽象类
abstract class ApiAdapter {
  Future<ApiResponse<T>> send<T>(BaseRequest request);

  Future<ApiResponse<T>> upload<T>(BaseRequest request);

  void cancel(String tag);

  void cancelAll();
}

/// 统一网络层返回格式
class ApiResponse<T> {
  ApiResponse({
    this.request,
    this.data,
    this.statusCode,
    this.statusMessage,
    this.extra,
  });

  /// Response body. may have been transformed, please refer to [ResponseType].
  T? data;

  /// The corresponding request info.
  BaseRequest? request;

  /// Http status code.
  int? statusCode;

  /// Returns the reason phrase associated with the status code.
  /// The reason phrase must be set before the body is written
  /// to. Setting the reason phrase after writing to the body.
  String? statusMessage;

  /// Custom field that you can retrieve it later in `then`.
  dynamic extra;

  /// We are more concerned about `data` field.
  @override
  String toString() {
    if (data is Map) {
      return json.encode(data);
    }
    return data.toString();
  }
}
