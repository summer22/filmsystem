import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart' show rootBundle;

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  WebViewScreenState createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen> {
  final GlobalKey webViewKey = GlobalKey();
  Dio dio = Dio();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        transparentBackground: true,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
          limitsNavigationsToAppBoundDomains: true // adds Service Worker API on iOS 14.0+
      ));

  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;

  void serviceWorker() async {
    if (Platform.isAndroid) {
      await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);

      var swAvailable = await AndroidWebViewFeature.isFeatureSupported(AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
      var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

      if (swAvailable && swInterceptAvailable) {
        AndroidServiceWorkerController serviceWorkerController = AndroidServiceWorkerController.instance();

        serviceWorkerController.serviceWorkerClient = AndroidServiceWorkerClient(
          shouldInterceptRequest: (request) async {
            print(request);
            return null;
          },
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    serviceWorker();
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
                    URLRequest(url: Uri.parse("https://www.nbflix.com")),
                initialOptions: options,
                pullToRefreshController: pullToRefreshController,
                onWebViewCreated: (controller) {
                  webViewController = controller;
                  controller.addJavaScriptHandler(
                      handlerName: 'handlerFoo',
                      callback: (args) {
                        // return data to the JavaScript side!
                        debugPrint("handlerFoo:");
                        debugPrint(args[0]);
                        return {'bar': 'bar_value', 'baz': 'baz_value'};
                      });

                  controller.addJavaScriptHandler(
                      handlerName: 'xmlHttpRequest',
                      callback: (args) async {
                        debugPrint("xmlHttpRequest:");
                        debugPrint(args[0]);
                        var xmlHttpRequestResponse = {
                          'status': 200,
                          'statusText': "成功了",
                          'response': "",
                        };
                        return {'response': xmlHttpRequestResponse};
                        // try {
                        //   var response = await dio.get(
                        //     args[0] ?? "",
                        //     options: Options(
                        //       responseType: ResponseType.json,
                        //     ),
                        //   );
                        //   debugPrint('Response data: $response');
                        //   var xmlHttpRequestResponse = {
                        //     'status': response.statusCode,
                        //     'statusText': response.statusMessage,
                        //     'response': response.data,
                        //   };
                        //   return {'response': xmlHttpRequestResponse};
                        // } catch (error) {
                        //   debugPrint('Error: $error');
                        // }
                      });

                  controller.addJavaScriptHandler(
                      handlerName: 'arraybufferRequest',
                      callback: (args) async {
                        debugPrint("arraybufferRequest:");
                        debugPrint(args[0]);
                        try {
                          var response = await dio.get(
                            args[0] ?? "",
                            options: Options(
                              headers: args[1] as Map<String, dynamic>,
                              responseType: ResponseType.bytes,
                            ),
                          );
                          debugPrint('Response data: $response');
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
                      handlerName: 'handlerFooWithArgs',
                      callback: (args) {
                        debugPrint("handlerFooWithArgs:");
                        debugPrint(args.toString());
                        // it will print: [1, true, [bar, 5], {foo: baz}, {bar: bar_value, baz: baz_value}]
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

                  if (![ "http", "https", "file", "chrome",
                    "data", "javascript", "about"].contains(uri.scheme)) {
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
                  // String jsContent = await rootBundle.loadString('assets/user.js');
                  // controller.evaluateJavascript(source: jsContent);
                },
                onLoadStop: (controller, url) async {
                  pullToRefreshController.endRefreshing();
                  setState(() {
                    this.url = url.toString();
                  });
                  String jsContent = await rootBundle.loadString('assets/user.js');
                  controller.evaluateJavascript(source: jsContent);
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
                  setState(() {
                    this.url = url.toString();
                  });
                },
                onConsoleMessage: (controller, consoleMessage) {
                  print(consoleMessage);
                },
              ),
              progress < 1.0
                  ? LinearProgressIndicator(value: progress, backgroundColor: Colors.black)
                  : Container(),
            ],
          ),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Icon(Icons.arrow_back),
              onPressed: () {
                webViewController?.canGoBack().then((value) => {
                      if (value) {webViewController?.goBack()} else {Get.back()}
                    });
              },
            ),
            ElevatedButton(
              child: const Icon(Icons.arrow_forward),
              onPressed: () {
                webViewController?.goForward();
              },
            ),
            ElevatedButton(
              child: const Icon(Icons.refresh),
              onPressed: () {
                webViewController?.reload();
              },
            ),
          ],
        ),
      ])),
    );
  }
}
