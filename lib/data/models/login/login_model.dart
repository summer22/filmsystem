class LoginModel {
  int? code;
  String? message;
  LoginDataModel? data;

  LoginModel({this.code, this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = LoginDataModel.fromJson(json['data']);
    }
  }
}

class LoginDataModel {
  String? token;

  LoginDataModel({this.token});

  LoginDataModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }

}

