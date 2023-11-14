/// @ClassName ApiError
/// @Description 请求异常类
/// @Author liuwang
/// @Date 2021/11/26 3:42 下午
/// @Version 1.0.1

class ApiError implements Exception {
  final int code;
  final String message;
  final dynamic data;

  ApiError(this.code, this.message, {this.data});
}
