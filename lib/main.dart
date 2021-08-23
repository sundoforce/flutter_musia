import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'pushManager.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(home: Home()));

var TOKEN = "";
var checkToken = true;
const MAIN_URL = 'https://muzia.net';

void setToken(String token) {
  TOKEN = token;
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  late WebViewController webViewctrl;

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    // PushManager().registerToken();
    // PushManager().listenFirebaseMessaging();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: MAIN_URL,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            webViewctrl = webViewController;
            _controller.complete(webViewController);
          },
          onProgress: (int progress) {
            print("WebView is loading (progress : $progress%)");
          },
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              print('blocking navigation to $request}');
              return NavigationDecision.prevent;
            }
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
            if (checkToken && url.startsWith(MAIN_URL + "/home/home.do")) {
              print('TOKEN >>> : $TOKEN');
              // checkToken = false;
              webViewctrl.evaluateJavascript('nativeAppDataReturn("$TOKEN")');
            }
          },
          gestureNavigationEnabled: true,
        );
      }),
      // floatingActionButton: favoriteButton(),
    );
  }
}
