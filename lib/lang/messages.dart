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
          'help_search_hint': "您需要什么帮助",
          'search_result_tip': "查找与以下内容相关的影片：",
          'sign_in': "立即登录",
          'login': "登录",
          'account': "账户",
          'help': "帮助中心",
          'logout': "退出登录",
          'remember': "记住账号",
          'forget_pwd': "忘记密码",
          'pwd': "密码",
          'pwd_again': "再次输入密码",
          'code': "验证码",
          'code_hint': "请输入有效验证码",
          'send_code': "发送验证码",
          'count_down': "秒后发送",
          'email': "电子邮件",
          'email_hint': "请输入有效的电子邮件",
          'pwd_hint': "请的密码必须包含 4 到 20 个字符",
          'change_pwd': "确认修改",
        },
        'en_US': {
          'home': 'Home',
          'show': 'TV Shows',
          'movie': 'Movies',
          'hot': 'New & Popular',
          'favorite': 'My Collection',
          'news': "News",
          'empty': "empty~",
          'cancel': "cancel",
          'help_search_hint': "What can i do for you",
          'search_hint': "title、characters、genre",
          'search_result_tip': "Find videos related to the following：",
          'sign_in': "Sign in",
          'login': "Sign in",
          'account': "Account",
          'help': "Help Message",
          'logout': "Sign out",
          'remember': "Remember me",
          'forget_pwd': "Forget Password",
          'pwd': "Password",
          'pwd_again': "Reconfirm password",
          'code': "Code",
          'code_hint': "Please enter a valid code",
          'send_code': "send",
          'count_down': "seconds",
          'email': "Email",
          'email_hint': "Please enter a valid email",
          'pwd_hint': "Your password must contain between 4 and 20 characters",
          'change_pwd': "Confirm Modification",
        }
      };
}
