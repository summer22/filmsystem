class AvatarListModel {

  List<AvatarItemModel?>? data = [];
  String? message;
  int? code;
  int? count;

  AvatarListModel({this.code, this.message, this.data});

  AvatarListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data?.add(AvatarItemModel.fromJson(v));
      });
    }
    message = json['message'];
    code = json['code'];
    count = json['count'];
  }
}

class AvatarItemModel {
  String? url;

  AvatarItemModel(this.url);

  AvatarItemModel.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }
}

