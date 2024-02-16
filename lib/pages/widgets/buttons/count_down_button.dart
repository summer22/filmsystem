import 'dart:async';
import 'package:flutter/material.dart';
import 'button.dart';

/// *
/// * author: summer
/// * Date: 2021/6/21
/// * Describtion: 倒计时按钮
/// *

/// 使用方式如下
// CountDownButton(
//   onStart: (VoidCallback callback){
//     callback();
//   },
// ),

class CountDownButton extends StatefulWidget {

  const CountDownButton({
    Key? key,
    required this.onStart,
    this.onFinish,
    this.text = '',
    this.countDownText = '',
    this.textColor = Colors.white,
    this.disableTextColor = Colors.white70,
    this.countDownSecond = 60,
    this.backgroundColor = Colors.white24,
    this.radius = 10,
    this.textStyle = const TextStyle(fontSize: 15),
    this.disableTextStyle = const TextStyle(fontSize: 14),
  }) : super(key: key);

  /// 倒计时结束回调事件
  final VoidCallback? onFinish;

  /// 倒计时开始回调事件
  final ValueChanged<VoidCallback> onStart;

  /// 默认显示文本
  final String? text;

  /// 倒计时显示文本
  final String? countDownText;

  /// 文本样式
  final TextStyle textStyle;

  /// 文本样式
  final TextStyle disableTextStyle;

  /// 倒计时时长 单位：秒
  final int countDownSecond;

  ///背景色
  final Color backgroundColor;

  ///文本色
  final Color textColor;

  ///文本色
  final Color disableTextColor;

  ///radius
  final double radius;

  @override
  _CountDownButtonState createState() => _CountDownButtonState();
}

class _CountDownButtonState extends State<CountDownButton> {
  Timer? _timer;
  int _countdownTime = 0;

  @override
  Widget build(BuildContext context) {
    return Button(
      radius: widget.radius,
      backgroundColor: widget.backgroundColor,
      textColor: _countdownTime > 0 ? widget.disableTextColor : widget.textColor,
      text: _countdownTime > 0
          ? '$_countdownTime${widget.countDownText}'
          : widget.text,
      click: _countdownTime > 0
          ? null
          : () {
              widget.onStart(() {
                if (_countdownTime <= 0) {
                  startCountdownTimer();
                }
              });
            },
      textStyle:
          _countdownTime > 0 ? widget.disableTextStyle : widget.textStyle,
    );
  }

  void startCountdownTimer() {
    _countdownTime = widget.countDownSecond;
    _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) => setState(() {
                if (_countdownTime < 1) {
                  _timer!.cancel();
                } else {
                  _countdownTime = _countdownTime - 1;
                }
              })
            );
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    super.dispose();
  }
}
