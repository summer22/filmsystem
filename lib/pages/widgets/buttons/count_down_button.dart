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
  static const TextStyle defaultDisableTextStyle = TextStyle(fontSize: 14);
  static const TextStyle defaultTextStyle = TextStyle(fontSize: 15);

  const CountDownButton({
    Key? key,
    required this.onStart,
    this.onFinish,
    this.text = '',
    this.countDownText = '',
    this.countDownSecond = 60,
    this.textStyle = defaultTextStyle,
    this.disableTextStyle = defaultDisableTextStyle,
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

  @override
  _CountDownButtonState createState() => _CountDownButtonState();
}

class _CountDownButtonState extends State<CountDownButton> {
  Timer? _timer;
  int _countdownTime = 0;

  @override
  Widget build(BuildContext context) {
    return Button(
      radius: 10,
      backgroundColor: Colors.white24,
      textColor:  _countdownTime > 0 ? Colors.white70 : Colors.white,
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
        (Timer timer) => {
              setState(() {
                if (_countdownTime < 1) {
                  _timer!.cancel();
                } else {
                  _countdownTime = _countdownTime - 1;
                }
              })
            });
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
