class HobbyListModel {

  List<HobbyModel?>? data = [];
  String? message;
  int? code;
  int? count;

  HobbyListModel({this.code, this.message, this.data});

  HobbyListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data?.add(HobbyModel.fromJson(v));
      });
    }
    message = json['message'];
    code = json['code'];
    count = json['count'];
  }
}

class HobbyModel {
  String? headNo;
  String? posterUrl;
  String? videoName;

  HobbyModel(this.headNo,this.posterUrl,this.videoName);

  HobbyModel.fromJson(Map<String, dynamic> json) {
    headNo = json['headNo'];
    posterUrl = json['posterUrl'];
    videoName = json['videoName'];
  }
}
