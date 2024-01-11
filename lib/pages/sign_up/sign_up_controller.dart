import 'package:filmsystem/data/models/sign_in/hobby_list_model.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {

  String name = "";
  String pwd = "";
  String rePwd = "";
  String mobile = "";
  String avatar = "";
  List<HobbyModel> selectedHobbyModel = [];

  void clear() {
    name = "";
    pwd = "";
    rePwd = "";
    mobile = "";
    avatar = "";
    selectedHobbyModel = [];
  }
}
