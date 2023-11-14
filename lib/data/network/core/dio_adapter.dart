import 'package:dio/dio.dart';
import 'package:connectivity/connectivity.dart';
import 'package:filmsystem/data/network/core/api_Interceptors.dart';
import 'package:filmsystem/utils/constant.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'api_error.dart';
import 'api_adapter.dart';
import 'base_request.dart';
import 'api_string.dart';

/// @ClassName DioAdapter
/// @Description dio适配器
/// @Author liuwang
/// @Date 2021/11/26 3:42 下午
/// @Version 1.0.1

///Dio适配器
class DioAdapter extends ApiAdapter {
  ///同一个CancelToken可以用于多个请求，当一个CancelToken取消时，
  ///所有使用该CancelToken的请求都会被取消，一个页面对应一个CancelToken。
  var _cancelTokens = Map<String, CancelToken>();

  final box = GetStorage();

  ///超时时间
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  static final DioAdapter _instance = DioAdapter._internal();

  DioAdapter._internal();

  factory DioAdapter() {
    return _instance;
  }

  ///全局属性：连接超时时间、响应超时时间、请求头
  _getOptions(BaseRequest request) async {
    request.header['Language'] = box.read(i18code) ?? "zh_CN";
    request.header['Content-Type'] = "application/json; charset=utf-8";
    if(box.read(token) != null){
      request.header['Authorization'] = box.read(token);
    }
    var options = BaseOptions(headers: request.header);
    options.method = request.httpMethod == HttpMethod.get ? 'GET' : 'POST';
    options.connectTimeout = connectTimeout;
    options.receiveTimeout = receiveTimeout;
    options.baseUrl = request.host();
    return options;
  }

  @override
  Future<ApiResponse<T>> send<T>(BaseRequest request) async {
    var error, response;

    var baseOptions = await _getOptions(request);
    var params = request.params;

    //检查网络是否连接
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      EasyLoading.showToast(networkException, toastPosition: EasyLoadingToastPosition.center);
      throw Exception(networkException);
    }

    Dio dio = Dio(baseOptions);
    dio.interceptors.add(ApiInterceptors.interceptors(request));

    try {
      CancelToken? cancelToken;
      if (request.path.isNotEmpty) {
        var tag = request.path;
        if (_cancelTokens[tag] == null) {
          cancelToken = CancelToken();
          _cancelTokens[tag] = cancelToken;
        } else {
          cancelToken = _cancelTokens[tag];
        }
      }
      if (request.httpMethod == HttpMethod.get) {
        response = await dio.get(request.path,
            queryParameters: params, cancelToken: cancelToken);
      } else if (request.httpMethod == HttpMethod.post) {
        response = await dio.post(request.path,
            data: params, cancelToken: cancelToken);
      } else {
        throw Exception('暂时不支持${request.httpMethod.toString()}请求方式');
      }
    } on DioError catch (e) {
      error = e;
      response = e.response;
    }
    if (error != null) {
      ///抛出DjNetError
      throw ApiError(response?.statusCode ?? -1, error.toString(),
          data: buildRes(response, request) ?? "");
    }
    return buildRes(response, request);
  }

  ///构建NetResponse
  buildRes(Response response, BaseRequest request) {
    return ApiResponse(
        request: request,
        data: response.data,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
        extra: response);
  }

  ///上传文件
  @override
  Future<ApiResponse<T>> upload<T>(BaseRequest request) async {
    var error, response;
    var baseOptions = await _getOptions(request);
    var params = request.params;

    //检查网络是否连接
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      EasyLoading.showToast(networkException, toastPosition: EasyLoadingToastPosition.center);
      throw Exception(networkException);
    }

    Dio dio = Dio(baseOptions);
    dio.interceptors.add(ApiInterceptors.interceptors(request));

    try {
      CancelToken? cancelToken;
      if (request.path.isNotEmpty) {
        var tag = request.path;
        if (_cancelTokens[tag] == null) {
          cancelToken = CancelToken();
          _cancelTokens[tag] = cancelToken;
        } else {
          cancelToken = _cancelTokens[tag];
        }
      }

      var map = {
        'imageFile': await MultipartFile.fromFile(request.filePath ?? '',
            filename: request.fileName ?? ''),
        'mimeType': 'image/jpg',
        ...params
      };
      var formData = FormData.fromMap(map);
      response = await dio.post(request.path,
          data: formData, cancelToken: cancelToken);
    } on DioError catch (e) {
      error = e;
      response = e.response;
    }
    if (error != null) {
      ///抛出DjNetError
      throw ApiError(response?.statusCode ?? -1, error.toString(),
          data: buildRes(response, request));
    }
    return buildRes(response, request);
  }

  ///取消特定网络请求
  @override
  void cancel(String tag) {
    if (_cancelTokens.containsKey(tag)) {
      if (!_cancelTokens[tag]!.isCancelled) {
        _cancelTokens[tag]!.cancel();
      }
      _cancelTokens.remove(tag);
    }
  }

  ///取消全部网络请求
  @override
  void cancelAll() {
    _cancelTokens.forEach((key, value) {
      if (!value.isCancelled) {
        value.cancel();
        _cancelTokens.remove(key);
      }
    });
  }
}
