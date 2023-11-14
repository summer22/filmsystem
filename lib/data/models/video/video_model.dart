class VideoModel {

  List<VideoItemModel?>? data = [];
  String? message;
  int? code;
  int? count;

  VideoModel({this.code, this.message, this.data});

  VideoModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data?.add(VideoItemModel.fromJson(v));
      });
    }
    message = json['message'];
    code = json['code'];
    count = json['count'];
  }
}

class VideoItemModel {
  int? id;
  String? headNo;
  int? dramaNumber;
  String? dramaUrl;
  String? dramaUrl1;
  String? dramaUrl2;
  String? dramaTitle;
  String? intro;
  String? filmUrl;
  int? duration;
  String? createDate;
  String? createUserName;
  String? updateDate;
  String? updateUserName;
  int? isDel;

  VideoItemModel(
      this.id,
      this.headNo,
      this.dramaNumber,
      this.dramaUrl,
      this.dramaUrl1,
      this.dramaUrl2,
      this.dramaTitle,
      this.intro,
      this.filmUrl,
      this.duration,
      this.createDate,
      this.createUserName,
      this.updateDate,
      this.updateUserName,
      this.isDel);

  VideoItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    headNo = json['headNo'];
    dramaNumber = json['dramaNumber'];
    dramaUrl = json['dramaUrl'];
    dramaUrl1 = json['dramaUrl1'];
    dramaUrl2 = json['dramaUrl2'];
    dramaTitle = json['dramaTitle'];
    intro = json['intro'];
    filmUrl = json['filmUrl'];
    duration = json['duration'];
    createDate = json['createDate'];
    createUserName = json['createUserName'];
    updateDate = json['updateDate'];
    updateUserName = json['updateUserName'];
    isDel = json['isDel'];
  }
}

