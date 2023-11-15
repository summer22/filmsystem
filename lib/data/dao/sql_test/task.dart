/// *
/// * author: summer
/// * Date: 2021/5/25
/// * Describtion: 
/// *

class Task {
  late final String? name;
  late final int? id;

  Task({this.name,this.id});

  Task.fromJson(Map<String, dynamic> json) {
     name = json['name'];
     id = json['id'];
  }
}