class DownloadInfoModel {
  int? id;
  int? statue; //下载状态  1-完成，2-未完成
  String? filePath;
  int? totalBytes;
  int? receivedBytes;
  String? email;
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
  String? updateDate;

  DownloadInfoModel({
      this.id,
      this.statue,
      this.filePath,
      this.totalBytes,
      this.receivedBytes,
      this.email,
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
      this.updateDate});

  DownloadInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    statue = json['statue'];
    filePath = json['filePath'];
    totalBytes = json['totalBytes'];
    receivedBytes = json['receivedBytes'];
    email = json['email'];
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
    updateDate = json['updateDate'];
  }
}