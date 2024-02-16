
///昵称校验 - 应为4至20个字符之间，只允许使用字母、数字、下划线或中文字符，不可使用特殊字符或空格。
bool isNicknameValid(String input) {
  RegExp regex = RegExp(r'^[\w\u4e00-\u9fa5]{4,20}$');
  return regex.hasMatch(input);
}

///手机号校验 - 11位，纯数字。
bool isValidPhoneNumber(String input) {
  RegExp regex = RegExp(r'^\d{11}$');
  return regex.hasMatch(input);
}

