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
          'pwd_hint': "你的密码必须包含 4 到 20 个字符",
          'pwd_empty_tip': "请输入密码",
          'pwd_diff_tip': "两次密码不一致",
          'mobile_hint': "请输入手机号",
          'name_hint': "请输入用户名",
          'change_pwd': "确认修改",
          'update_info_title': "修改用户信息",
          'update_info_current_avatar': "当前头像",
          'update_info_optional_avatar': "可选头像",
          'update_info_user_base_info': "用户基础信息",
          'update_info_mobile': "手机号",
          'update_info_real_name': "用户名",
          'update_info_email': "邮箱",
          'update_info_password': "密码",
          'update_info_sms_code': "验证码",
          'update_info_clear': "清除",
          'update_info_submit': "提交",
          'image_loading_error': " 加载失败",
          'update_info_hint': "不能为空",
          'download': "下载",
          'play_speed': "播放速度",
          'picture_in_picture': "画中画",
          'net_error': "哇哦，网络离家出走了~",
          'home_section_title': "浏览全部",
          'my_download': "我的下载",
          'delete_success': "删除成功",
          'delete': "删除",
          'sign_in_tip': "Netflix 的新用户?",
          'sign_in_btn_title': "立即注册",
          'step_one': "第1步(共4步)",
          'step_one_desc': "我们依照每个的喜好和语言偏好为您精心推荐影片，您家中的每个成员都能拥有自己的专属片单，还有儿童专区",
          'pwd_confirm': "确认密码",
          'pwd_confirm_tip': "请再次输入密码",
          'step_one_btn': "下一步",
          'step_two': "第2步(共4步)",
          'step_two_subtitle': "请选择一个您喜欢的头像",
          'step_two_desc1': "这有助于我们找到您会喜爱的节目与电影,",
          'step_two_desc2': "请选择一个您喜欢的头像",
          'step_two_btn_left': "上一步",
          'step_two_btn_right1': "请选择一个您喜欢的头像",
          'step_two_btn_right2': "下一步",
          'step_three': "第3步(共4步)",
          'step_three_subtitle': "请选择三部您喜欢的影片",
          'step_three_desc1': "这有助于我们找到您会喜爱的节目与电影,",
          'step_three_desc2': "请选择您喜欢的影片",
          'step_three_desc3': "选择",
          'step_three_desc4': "部影片以继续",
          'step_four': "第4步(共4步)",
          'step_four_desc': "我们依照每个的喜好和语言偏好为您精心推荐影片，您家中的每个成员都能拥有自己的专属片单，还有儿童专区",
          'step_four_right_btn': "完成",
          'play': "播放",
          'video_detail': "影片详情",
          'director': "导演",
          'cast': "主演",
          'tag': "标签",
          'story': "类型",
          'detail_total': "共",
          'detail_collect': "集",
          'detail_like': "更多类似",
          'detail_like_movie': "的影片",

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
          'send_code': "Send",
          'count_down': "seconds",
          'email': "Email",
          'email_hint': "Please enter a valid email",
          'pwd_hint': "Your password must contain between 4 and 20 characters",
          'pwd_empty_tip': "Please enter password",
          'pwd_diff_tip': "two passwords are inconsistent",
          'mobile_hint': "Please enter mobile number",
          'name_hint': "Please enter username",
          'change_pwd': "Confirm Modification",
          'update_info_title': "Edit Profile",
          'update_info_current_avatar': "current avatar",
          'update_info_optional_avatar': "optional avatar",
          'update_info_user_base_info': "user base infomation",
          'update_info_mobile': "mobile",
          'update_info_real_name': "realName",
          'update_info_email': "email",
          'update_info_password': "password",
          'update_info_sms_code': "smsCode",
          'update_info_clear': "clear",
          'update_info_submit': "submit",
          'image_loading_error': "FAILED",
          'update_info_hint': "cannot be empty",
          'download': "download",
          'play_speed': "play speed",
          'picture_in_picture': "pip",
          'net_error': "Network Exception",
          'home_section_title': "Browse all",
          'my_download': "My Download",
          'delete_success': "Delete Success",
          'delete': "delete",
          'sign_in_tip': "New to Netflix?",
          'sign_in_btn_title': "Sign up now",
          'step_one': "Step 1 (total of 4 steps)",
          'step_one_desc': "We tailor videos to your individual preferences and language preferences, and each member of your family can have their own list, as well as a children's section",
          'pwd_confirm': "confirm",
          'pwd_confirm_tip': "Please enter password again",
          'step_one_btn': "next step",
          'step_two': "Step 2 (total of 4 steps)",
          'step_two_subtitle': "Please choose a profile picture that you like",
          'step_two_desc1': "This helps us find shows and movies you'll love,",
          'step_two_desc2': "Please choose a profile picture that you like",
          'step_two_btn_left': "Last step",
          'step_two_btn_right1': "Please choose a profile picture that you like",
          'step_two_btn_right2': "next",
          'step_three': "Step 3 (total of 4 steps)",
          'step_three_subtitle': "Please select three movies that you like",
          'step_three_desc1': "This helps us find shows and movies you'll love,",
          'step_three_desc2': "Please select your favorite movie",
          'step_three_desc3': "Select ",
          'step_three_desc4': " a video to continue",
          'step_four': "Step 4 (total of 4 steps)",
          'step_four_desc': "We tailor videos to your individual preferences and language preferences, and each member of your family can have their own list, as well as a children's section",
          'step_four_right_btn': "completed",
          'play': "Play",
          'video_detail': "Video details",
          'director': "Director",
          'cast': "Cast",
          'tag': "Tag",
          'story': "Story",
          'detail_total': "total",
          'detail_collect': "collect",
          'detail_like': "More like",
          'detail_like_movie': "movices",
        }
      };
}
