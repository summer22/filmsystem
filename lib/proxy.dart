import 'dart:io';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_proxy/shelf_proxy.dart';


final String target = 'https://192.168.2.200/'; // api地址
// final String imgTarget = 'https://192.168.2.200/'; // 图片地址

void configServer(HttpServer server) {
  // 这里设置请求策略，允许所有
  server.defaultResponseHeaders.add('Access-Control-Allow-Origin', '*');
  server.defaultResponseHeaders.add('Access-Control-Allow-Credentials', true);
  server.defaultResponseHeaders.add('Access-Control-Allow-Methods', '*');
  server.defaultResponseHeaders.add('Access-Control-Allow-Headers', '*');
  server.defaultResponseHeaders.add('Access-Control-Max-Age', '3600');
}

void main() async {
  var reqHandle = proxyHandler(target);
  // var imgHandle = proxyHandler(imgTarget);

  /// 绑定本地端口，4500，转发到真正的服务器中
  var server = await shelf_io.serve(reqHandle, 'localhost', 4500);
  // var imgServer = await shelf_io.serve(imgHandle, 'localhost', 4501);

  configServer(server);
  // configServer(imgServer);

  print('Api Serving at http://${server.address.host}:${server.port}');
  // print('Img Serving at http://${imgServer.address.host}:${imgServer.port}');
}
