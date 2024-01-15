import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart' show rootBundle;

class WebViewScreen extends StatefulWidget {
  String? url;

  WebViewScreen({super.key, this.url});

  @override
  WebViewScreenState createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen> {
  final GlobalKey webViewKey = GlobalKey();
  Dio dio = Dio();
  final CancelToken _cancelToken = CancelToken();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        transparentBackground: true,
        applicationNameForUserAgent: "moblie-nbflix"
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
          allowsInlineMediaPlayback: true,
          limitsNavigationsToAppBoundDomains:
              true // adds Service Worker API on iOS 14.0+
          ));

  late PullToRefreshController pullToRefreshController;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    _cancelToken.cancel("页面销毁，取消请求");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Column(children: <Widget>[
        Expanded(
          child: Stack(
            children: [
              InAppWebView(
                key: webViewKey,
                initialUrlRequest:
                // URLRequest(url: Uri.parse("http://localhost:4000")),
                // URLRequest(url: Uri.parse("https://www.nbflix.com")),
                URLRequest(url: Uri.parse(widget.url ?? "")),
                initialOptions: options,
                pullToRefreshController: pullToRefreshController,
                onWebViewCreated: (controller) {
                  webViewController = controller;
                  controller.addJavaScriptHandler(
                      handlerName: 'xmlHttpRequest',
                      callback: (args) async {
                        // debugPrint("xmlHttpRequest:");
                        // debugPrint(args[0]);
                        try {
                          var response = await dio.get(
                            args[0] ?? "",
                            options: Options(
                              followRedirects: true,
                              responseType: ResponseType.json,
                            ), cancelToken: _cancelToken
                          );
                          // debugPrint('Response data: $response');
                          var xmlHttpRequestResponse = {
                            'status': response.statusCode,
                            'statusText': response.statusMessage,
                            'response': response.data,
                          };
                          return {'response': xmlHttpRequestResponse};
                        } catch (error) {
                          debugPrint('Error: $error');
                        }
                      });

                  controller.addJavaScriptHandler(
                      handlerName: 'arraybufferRequest',
                      callback: (args) async {
                        // debugPrint("arraybufferRequest:");
                        // debugPrint(args[0]);
                        try {
                          var response = await dio.get(
                            args[0] ?? "",
                            options: Options(
                              headers: args[1] as Map<String, dynamic>,
                              followRedirects: true,
                              responseType: ResponseType.bytes,
                            ), cancelToken: _cancelToken
                          );
                          // debugPrint('Response data: $response');
                          var xmlHttpRequestResponse = {
                            'status': response.statusCode,
                            'statusText': response.statusMessage,
                            'response': response.data,
                          };
                          return {'response': xmlHttpRequestResponse};
                        } catch (error) {
                          debugPrint('Error: $error');
                        }
                      });

                  controller.addJavaScriptHandler(
                      handlerName: 'nativeBack',
                      callback: (args) async {
                        // debugPrint('Error:');
                        Get.back();
                      });
                },
                androidOnPermissionRequest:
                    (controller, origin, resources) async {
                  return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT);
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var uri = navigationAction.request.url!;
                  if (![
                    "http",
                    "https",
                    "file",
                    "chrome",
                    "data",
                    "javascript",
                    "about"
                  ].contains(uri.scheme)) {
                    if (await canLaunchUrl(uri)) {
                      // Launch the App
                      await launchUrl(
                        uri,
                      );
                      // and cancel the request
                      return NavigationActionPolicy.CANCEL;
                    }
                  }

                  return NavigationActionPolicy.ALLOW;
                },
                onLoadStart: (controller, url) async {
                  String jsContent =
                      await rootBundle.loadString('assets/user.js');
                  controller.evaluateJavascript(source: jsContent);
                  // }
                },
                onLoadStop: (controller, url) async {
                  pullToRefreshController.endRefreshing();
                  // setState(() {
                  //   this.url = url.toString();
                  // });
                  // if(url?.path.toString() == "detail"){
                  //   String jsContent = await rootBundle.loadString('assets/user.js');
                  //   controller.evaluateJavascript(source: jsContent);
                  // }
                },
                onLoadError: (controller, url, code, message) {
                  pullToRefreshController.endRefreshing();
                },
                onReceivedServerTrustAuthRequest:
                    (InAppWebViewController controller,
                        URLAuthenticationChallenge challenge) async {
                  return ServerTrustAuthResponse(
                      action: ServerTrustAuthResponseAction.PROCEED);
                },
                onProgressChanged: (controller, progress) {
                  if (progress == 100) {
                    pullToRefreshController.endRefreshing();
                  }
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
                onUpdateVisitedHistory: (controller, url, androidIsReload) {
                  // setState(() {
                  //   this.url = url.toString();
                  // });
                },
                onConsoleMessage: (controller, consoleMessage) {
                  print(consoleMessage);
                },
              ),
              progress < 1.0
                  ? LinearProgressIndicator(
                      value: progress, backgroundColor: Colors.black)
                  : Container(),
            ],
          ),
        ),
        // ButtonBar(
        //   alignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     ElevatedButton(
        //       child: const Icon(Icons.arrow_back),
        //       onPressed: () {
        //         webViewController?.canGoBack().then((value) => {
        //               if (value) {webViewController?.goBack()} else {Get.back()}
        //             });
        //       },
        //     ),
        //     ElevatedButton(
        //       child: const Icon(Icons.arrow_forward),
        //       onPressed: () {
        //         webViewController?.goForward();
        //       },
        //     ),
        //     ElevatedButton(
        //       child: const Icon(Icons.refresh),
        //       onPressed: () {
        //         webViewController?.reload();
        //       },
        //     ),
        //   ],
        // ),
      ])),
    );
  }
}
