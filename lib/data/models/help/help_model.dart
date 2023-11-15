class HelpModel {

  List<HelpItemModel?>? data = [];
  String? message;
  int? code;
  int? count;

  HelpModel({this.code, this.message, this.data});

  HelpModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data?.add(HelpItemModel.fromJson(v));
      });
    }
    message = json['message'];
    code = json['code'];
    count = json['count'];
  }
}

class HelpItemModel {
  int? id;
  String? question;
  String? answer;
  int? qty;
  String? createDate;
  String? updateDate;

  HelpItemModel(this.id, this.question, this.answer, this.qty, this.createDate,
      this.updateDate);

  HelpItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
    qty = json['qty'];
    createDate = json['createDate'];
    updateDate = json['updateDate'];
  }
}

