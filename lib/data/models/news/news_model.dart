class NewsModel {

  List<NewsItemModel?>? data = [];
  String? message;
  int? code;
  int? count;

  NewsModel({this.code, this.message, this.data});

  NewsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data?.add(NewsItemModel.fromJson(v));
      });
    }
    message = json['message'];
    code = json['code'];
    count = json['count'];
  }
}

class NewsItemModel {
  int? id;
  String? cover;
  int? msgType;
  String? msgTitle;
  String? msgContent;
  String? createDate;
  String? updateDate;

  NewsItemModel(this.id, this.cover, this.msgType, this.msgTitle,
      this.msgContent, this.createDate, this.updateDate);

  NewsItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cover = json['cover'];
    msgType = json['msgType'];
    msgTitle = json['msgTitle'];
    msgContent = json['msgContent'];
    createDate = json['createDate'];
    updateDate = json['updateDate'];
  }
}

