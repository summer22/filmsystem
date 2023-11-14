class HomeModel {
  HomeDataModel? data;
  String? message;
  int? code;
  int? count;

  HomeModel({this.code, this.message, this.data});

  HomeModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = HomeDataModel.fromJson(json['data']);
    }
    message = json['message'];
    code = json['code'];
    count = json['count'];
  }
}

class HomeDataModel {
  List<HomeRowModel?>? row = [];

  HomeDataModel({this.row});

  HomeDataModel.fromJson(Map<String, dynamic> json) {
    if (json['row'] != null) {
      json['row'].forEach((v) {
        row?.add(HomeRowModel.fromJson(v));
      });
    }
  }
}

class HomeRowModel {
  String? title;
  int? showDel;
  int? classValue;
  int? count;
  List<HomeRowItemModel?>? list = [];

  HomeRowModel(this.title, this.showDel, this.count, this.list);

  HomeRowModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    showDel = json['showDel'];
    count = json['count'];
    classValue = json['class'];

    if (json['list'] != null) {
      json['list'].forEach((v) {
        list?.add(HomeRowItemModel.fromJson(v));
      });
    }
  }
}


class HomeRowItemModel {
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
  String? posterUrl;
  String? posterUrl1;
  String? posterUrl2;
  String? title;
  String? grade;
  int? isHot;
  int? likeCount;
  bool? isCollect;
  int? isLike;
  String? mate;

  HomeRowItemModel(this.headNo, this.videoName, this.maturity, this.duration,
      this.clarity, this.videoTag, this.videoType, this.videoClass,
      this.videoDate, this.setsNumber, this.filmUrl, this.posterUrl,
      this.posterUrl1, this.posterUrl2, this.title, this.grade, this.isHot,
      this.likeCount, this.isCollect, this.isLike, this.mate);

  HomeRowItemModel.fromJson(Map<String, dynamic> json) {
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
    posterUrl = json['posterUrl'];
    posterUrl1 = json['posterUrl1'];
    posterUrl2 = json['posterUrl2'];
    title = json['title'];
    grade = json['grade'];
    isHot = json['isHot'];
    likeCount = json['likeCount'];
    isCollect = json['isCollect'];
    isLike = json['isLike'];
    mate = json['mate'];
  }
}
