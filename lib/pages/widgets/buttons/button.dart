/// *
/// * author: liuwang
/// * Date: 2021/5/31
/// * Describtion: 基础按钮, 灵活自定义
/// *

import 'dart:ui';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button(
      {Key? key,
      this.backgroundColor,
      this.click,
      this.text,
      this.textColor,
      this.textStyle,
      this.disabledColor,
      this.disabledTextColor,
      this.overlayColor,
      this.radius,
      this.borderColor,
      this.disabledBorderColor,
      this.borderWidth,
      this.shadowColor,
      this.elevation,
      this.child})
      : super(key: key);

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

  /// disabledText color
  final Color? disabledTextColor;

  /// 常态背景色
  final Color? backgroundColor;

  /// 水波纹颜色
  final Color? overlayColor;

  /// 圆角值
  final double? radius;

  /// 边框颜色
  final Color? borderColor;

  /// disabledBorder color
  final Color? disabledBorderColor;

  /// 边框宽度
  final double? borderWidth;

  ///  阴影颜色
  final Color? shadowColor;

  /// 阴影权重 (下部的影子，该值越大，影子越清楚，为0时，不会有影子)
  final double? elevation;

  /// child widget
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: child ??
          Text(
            text ?? '',
            textAlign: TextAlign.center,
          ),
      style: ButtonStyle(
        textStyle: textStyle != null
            ? MaterialStateProperty.resolveWith<TextStyle>((states) {
                return textStyle!; // Regular color
              })
            : null,
        foregroundColor: textColor != null
            ? MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.disabled)) {
                  if (disabledTextColor != null) {
                    return disabledTextColor!; // Disabled color
                  }
                }
                return textColor!;
              })
            : null,
        backgroundColor: backgroundColor != null
            ? MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.disabled)) {
                  if (disabledColor != null) {
                    return disabledColor!; // Disabled color
                  }
                }
                return backgroundColor!; // Regular color
              })
            : null,
        shape: MaterialStateProperty.resolveWith<OutlinedBorder>((states) {
          if (states.contains(MaterialState.disabled)) {
            if (disabledBorderColor != null) {
              return RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius ?? 0),
                  side: BorderSide(
                      color: disabledBorderColor ?? Colors.transparent,
                      width: borderWidth ?? 0)); // Disabled color
            }
          }
          return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius ?? 0),
              side: BorderSide(
                  color: borderColor ?? Colors.transparent,
                  width: borderWidth ?? 0)); // Regular color
        }),
        overlayColor: overlayColor != null
            ? MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  return overlayColor!;
                },
              )
            : null,
        shadowColor: shadowColor != null
            ? MaterialStateProperty.resolveWith<Color>((states) {
                return shadowColor!; // Regular color
              })
            : null,
        elevation: elevation != null
            ? MaterialStateProperty.resolveWith<double>((states) {
                return elevation ?? 0; // Regular color
              })
            : null,
      ),
      onPressed: click,
    );
  }
}
