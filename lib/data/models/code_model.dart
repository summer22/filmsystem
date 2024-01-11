class CodeModel {
  int? code;
  String? message;
  CodeDataModel? data;

  CodeModel({this.code, this.message, this.data});

  CodeModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = CodeDataModel.fromJson(json['data']);
    }
  }
}

class CodeDataModel {
  String? token;

  CodeDataModel({this.token});

  CodeDataModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }

}
