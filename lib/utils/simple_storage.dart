import 'package:filmsystem/data/models/info/userinfo_model.dart';
import 'package:filmsystem/utils/constant.dart';
import 'package:get_storage/get_storage.dart';

class SimpleStorage {
  static final SimpleStorage _instance = SimpleStorage._internal();
  static GetStorage? box;

  factory SimpleStorage() {
    return _instance;
  }

  SimpleStorage._internal();

  static Future<void> init() async {
    await GetStorage.init();
    box = GetStorage();
  }

  // 存储数据
  static Future<void> write(String key, dynamic value) async {
    await box?.write(key, value);
  }

  // 获取数据
  static dynamic read(String key) {
    return box?.read(key);
  }

  // 移除数据
  static Future<void> remove(String key) async {
    await box?.remove(key);
  }

  // 登出
  static Future<void> removeUserInfo() async {
    await box?.remove(userInfo);
    await box?.remove(token);
  }

  // 获取用户信息
  static UserInfoDataModel readUserInfo() {
    dynamic value = box?.read(userInfo);
    if(value == null) {
      return UserInfoDataModel();
    }
    return UserInfoDataModel.fromJson(value);
  }

  // 清空所有数据
  static Future<void> clearAll() async {
    await box?.erase();
  }
}