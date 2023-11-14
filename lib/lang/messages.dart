import 'package:get/get.dart';

class Messages extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
        'zh_CN': {
          'home': "主页",
          'show': "节目",
          'movie': "电影",
          'hot': "新鲜热播",
          'favorite': "我的收藏",
          'news': "消息",
          'empty': "空空如也~",
          'cancel': "取消",
          'search_hint': "片名、人员、类型",
          'search_result_tip': "查找与以下内容相关的影片：",
          'favorite': "我的收藏",
        },
        'en_US': {
          'home': 'Home',
          'show': 'TV Shows',
          'movie': 'Movies',
          'hot': 'New & Popular',
          'favorite': 'My Collection',
          'news': "news",
          'empty': "empty~",
          'cancel': "cancel",
          'search_hint': "title、characters、genre",
          'search_result_tip': "Find videos related to the following：",
          'favorite': "My Collection",

        }
      };
}
