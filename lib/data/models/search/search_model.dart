class SearchModel {

  List<SearchItemModel?>? data = [];
  String? message;
  int? code;
  int? count;

  SearchModel({this.code, this.message, this.data});

  SearchModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data?.add(SearchItemModel.fromJson(v));
      });
    }
    message = json['message'];
    code = json['code'];
    count = json['count'];
  }
}

class SearchItemModel {
  int? id;
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
  String? filmResource;
  String? filmUrl;
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
  String? createDate;
  String? createUserName;
  String? updateDate;
  String? updateUserName;
  int? isDel;
  bool? isCollect;
  int? isLike;
  String? mate;


  SearchItemModel(this.id, this.headNo, this.videoName, this.maturity,
      this.duration, this.clarity, this.videoTag, this.videoType,
      this.videoClass, this.videoDate, this.setsNumber, this.filmResource,
      this.filmUrl, this.posterUrl, this.posterUrl1, this.posterUrl2,
      this.intro, this.director, this.cast, this.screenWriter, this.grade,
      this.isHot, this.likeCount, this.createDate, this.createUserName,
      this.updateDate, this.updateUserName, this.isDel, this.isCollect,
      this.isLike, this.mate);

  SearchItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
    filmResource = json['filmResource'];
    filmUrl = json['filmUrl'];
    posterUrl = json['posterUrl'];
    posterUrl1 = json['posterUrl1'];
    posterUrl2 = json['posterUrl2'];
    intro = json['intro'];
    director = json['director'];
    cast = json['cast'];
    screenWriter = json['screenWriter'];
    updateUserName = json['updateUserName'];
    isDel = json['isDel'];
    grade = json['grade'];
    isHot = json['isHot'];
    likeCount = json['likeCount'];
    isCollect = json['isCollect'];
    isLike = json['isLike'];
    mate = json['mate'];
    createDate = json['createDate'];
    updateDate = json['updateDate'];
  }
}

