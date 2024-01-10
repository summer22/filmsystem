import 'package:get/get.dart';

class SignUpController extends GetxController {

  String name = "";
  String pwd = "";
  String rePwd = "";
  String mobile = "";
  String avatar = "";

  void clear() {
    name = "";
    pwd = "";
    rePwd = "";
    mobile = "";
    avatar = "";
  }
}
