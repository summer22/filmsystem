class UserInfoModel {
  int? code;
  String? message;
  UserInfoDataModel? data;

  UserInfoModel({this.code, this.message, this.data});

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = UserInfoDataModel.fromJson(json['data']);
    }
  }
}

class UserInfoDataModel {
  int? id;
  String? userNo;
  String? username;
  String? password;
  String? realName;
  String? avatar;
  String? mobile;
  String? email;
  String? createDate;
  String? updateDate;
  int? isDel;

  UserInfoDataModel(
      this.id,
      this.userNo,
      this.username,
      this.password,
      this.realName,
      this.avatar,
      this.mobile,
      this.email,
      this.createDate,
      this.updateDate,
      this.isDel);

  UserInfoDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userNo = json['userNo'];
    username = json['username'];
    password = json['password'];
    realName = json['realName'];
    avatar = json['avatar'];
    mobile = json['mobile'];
    email = json['email'];
    createDate = json['createDate'];
    updateDate = json['updateDate'];
    isDel = json['isDel'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userNo': userNo,
        'username': username,
        'password': password,
        'realName': realName,
        'avatar': avatar,
        'mobile': mobile,
        'email': email,
        'createDate': createDate,
        'updateDate': updateDate,
        'isDel': isDel,
      };
}
