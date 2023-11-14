import 'package:flutter/material.dart';
import 'package:filmsystem/app/app_theme.dart';

import 'button.dart';

/// *
/// * author: liuwang
/// * Date: 2021/5/31
/// * Describtion: 一级按钮，基于基础按钮定制的widget
/// *

class MainButton extends StatelessWidget {
  static const Color defalutOverlayColor = Color(0xFF001884);

  MainButton({
    Key? key,
    this.click,
    this.text,
    this.backgroundColor = AppTheme.purpleColor,
    this.textColor = Colors.white,
    this.textStyle,
    this.disabledColor = Colors.white,
    this.overlayColor = defalutOverlayColor,
    this.radius,
  }) : super(key: key);

  /// 点击方法 （click 为 null 时即为 disabled 状态）
  final void Function()? click;

  /// 文本
  final String? text;

  /// text color
  final Color? textColor;

  /// 文本样式
  final TextStyle? textStyle;

  /// disabled color
  final Color? disabledColor;

  /// 常态背景色
  final Color? backgroundColor;

  /// 水波纹颜色
  final Color? overlayColor;

  /// 圆角值
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Button(
      click: click,
      text: text,
      textColor: textColor,
      textStyle: textStyle,
      disabledColor: disabledColor,
      backgroundColor: backgroundColor,
      overlayColor: overlayColor,
      radius: radius,
      elevation: 0,
    );
  }
}
