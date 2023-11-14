import 'package:flutter/material.dart';

/// @ClassName log
/// @Description 封装的日志输出方法
/// @Author liuwang
/// @Date 2021/11/26 3:42 下午
/// @Version 1.0.1

///true: 生产环境； false: 开发环境
const isProd = bool.fromEnvironment('dart.vm.product');

log(Object message, {StackTrace? trace}) {
  if (!isProd) {
    //开发环境
    if (trace != null) {
      CustomTrace programInfo = CustomTrace(trace: trace);
      debugPrint(
          "所在文件: ${programInfo.fileName}, 所在行: ${programInfo.lineNumber}, 打印信息:" +
              message.toString());
    } else {
      debugPrint(message.toString());
    }
  }
}

class CustomTrace {
  late StackTrace trace;
  late String fileName;
  late int lineNumber;
  late int columnNumber;

  CustomTrace({required this.trace}) {
    _parseTrace();
  }

  _parseTrace() {
    var traceString = trace.toString().split("\n")[0];
    var indexOfFileName = traceString.indexOf(RegExp(r'[A-Za-z_]+.dart'));
    var fileInfo = traceString.substring(indexOfFileName);
    var listOfInfos = fileInfo.split(":");
    fileName = listOfInfos[0];
    lineNumber = int.parse(listOfInfos[1]);
    var columnStr = listOfInfos[2];
    columnStr = columnStr.replaceFirst(")", "");
    columnNumber = int.parse(columnStr);
  }
}
