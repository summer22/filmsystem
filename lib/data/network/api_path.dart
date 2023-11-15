/// @ClassName ApiPath
/// @Description 接口路径
/// @Author liuwang
/// @Date 2021/11/26 3:42 下午
/// @Version 1.0.1

class ApiPath {
  static const String newsList = "api/notification/list"; //消息列表
  static const String homeList = "api/video/list?class=0&type="; //首页数据列表
  static const String searchList = "api/video/search"; //搜索
  static const String favoriteList = "api/collection/my"; //收藏
  static const String subjectList = "api/video/list"; //专题
  static const String detail = "api/video/detailsByNo"; //详情
  static const String video = "api/video/dramaList"; //视频
  static const String insert = "api/collection/insert"; //点击按钮 - 收藏
  static const String delete = "api/collection/delete"; //点击按钮 - 取消收藏
  static const String likes = "api/video/likes"; //点击按钮 - 点赞和取消点赞
  static const String login = "api/auth/login"; //登录
  static const String userInfo = "api/user/info"; //个人信息
  static const String code = "api/auth/code"; //获取验证码
  static const String forget = "api/user/userForget"; //修改密码
  static const String help = "api/question/list"; //帮助中心
  static const String helpQuery = "api/question/query"; //帮助中心搜索
  static const String avatarList = "api/auth/avatarList"; //头像列表
}




