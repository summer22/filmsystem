class BaseModel<T> {
  int? code;
  String? message;
  T? data;

  BaseModel({this.code, this.message, this.data});

  BaseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'];
  }
}
