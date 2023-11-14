import 'package:filmsystem/data/models/search/search_model.dart';

class DetailModel {
  DetailDataModel? data;
  String? message;
  int? code;
  int? count;

  DetailModel({this.code, this.message, this.data});

  DetailModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = DetailDataModel.fromJson(json['data']);
    }
    message = json['message'];
    code = json['code'];
    count = json['count'];
  }
}

class DetailDataModel {
  String? headNo;
  String? videoName;
  String? maturity;
  String? duration;
  String? clarity;
  List<String?>? videoTag = [];
  String? videoType;
  String? videoClass;
  String? videoDate;
  int? setsNumber;
  String? filmUrl;
  String? filmResource;
  String? posterUrl;
  String? posterUrl1;
  String? posterUrl2;
  String? intro;
  String? director;
  String? cast;
  String? screenWriter;
  String? grade;
  int? isHot;
  int? likeCount;
  bool? isCollect;
  int? isLike;
  String? mate;
  List<DramaModel?>? dramaList = [];
  List<SearchItemModel?>? similarList = [];

  DetailDataModel(
      this.headNo,
      this.videoName,
      this.maturity,
      this.duration,
      this.clarity,
      this.videoTag,
      this.videoType,
      this.videoClass,
      this.videoDate,
      this.setsNumber,
      this.filmUrl,
      this.filmResource,
      this.posterUrl,
      this.posterUrl1,
      this.posterUrl2,
      this.intro,
      this.director,
      this.cast,
      this.screenWriter,
      this.grade,
      this.isHot,
      this.likeCount,
      this.isCollect,
      this.isLike,
      this.mate,
      this.dramaList,
      this.similarList);

  DetailDataModel.fromJson(Map<String, dynamic> json) {
    headNo = json['headNo'];
    videoName = json['videoName'];
    maturity = json['maturity'];
    duration = json['duration'];
    clarity = json['clarity'];
    if (json['videoTag'] != null) {
      json['videoTag'].forEach((v) {
        videoTag?.add(v);
      });
    }
    videoType = json['videoType'];
    videoClass = json['videoClass'];
    videoDate = json['videoDate'];
    setsNumber = json['setsNumber'];
    filmUrl = json['filmUrl'];
    filmResource = json['filmResource'];
    posterUrl = json['posterUrl'];
    posterUrl1 = json['posterUrl1'];
    posterUrl2 = json['posterUrl2'];
    intro = json['intro'];
    director = json['director'];
    cast = json['cast'];
    screenWriter = json['screenWriter'];
    grade = json['grade'];
    isHot = json['isHot'];
    likeCount = json['likeCount'];
    isCollect = json['isCollect'];
    isLike = json['isLike'];
    mate = json['mate'];

    if (json['dramaList'] != null) {
      json['dramaList'].forEach((v) {
        dramaList?.add(DramaModel.fromJson(v));
      });
    }

    if (json['similarList'] != null) {
      json['similarList'].forEach((v) {
        similarList?.add(SearchItemModel.fromJson(v));
      });
    }
  }
}

class DramaModel {
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

  DramaModel(
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

  DramaModel.fromJson(Map<String, dynamic> json) {
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
