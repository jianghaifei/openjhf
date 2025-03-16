import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/utils/color_util.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RSWebViewPage extends StatefulWidget {
  const RSWebViewPage({super.key});

  @override
  State<RSWebViewPage> createState() => _RSWebViewPageState();
}

class _RSWebViewPageState extends State<RSWebViewPage> {
  WebViewController _controller = WebViewController();
  String? _pageTitle;
  double _progressValue = 0.0;

  late String loadUrl;
  String? title;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var args = Get.arguments;

    if (args != null && args is Map<String, dynamic>) {
      if (args.containsKey("url")) {
        loadUrl = args["url"];
      }
      if (args.containsKey("title")) {
        title = args["title"];
      }

      if (loadUrl.isNotEmpty) {
        _controller = myWebViewController(loadUrl);
      } else {
        EasyLoading.showError('url is null');

        Get.back();
      }
    } else {
      EasyLoading.showError('url is null');
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? (_pageTitle ?? '')),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_progressValue > 0.0 && _progressValue < 1.0)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                value: _progressValue,
                valueColor: AlwaysStoppedAnimation(RSColorUtil.hexToColor("#5C57E6")),
                backgroundColor: RSColorUtil.hexToColor("#E1E1E1"),
              ),
            ),
        ],
      ),
    );
  }

  WebViewController myWebViewController(String? url) {
    debugPrint("WebView url ---- $url");
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFF9FAFB))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int? progress) {
            if (progress != null) {
              setState(() {
                _progressValue = progress / 100;
              });
              debugPrint("WebView Progress ----$progress -- ${progress / 100}");
            }
          },
          onPageStarted: (String url) {
            debugPrint("WebView onPageStarted ---- $url");
          },
          onPageFinished: (String url) async {
            // 读取页面标题
            var title = await _controller.getTitle();
            debugPrint("WebView onPageFinished ---- $title");

            setState(() {
              _pageTitle = title;
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("WebView error ---- $error");
            // NavigatorHelper.of(context).pop();
            setState(() {
              _pageTitle = 'error';
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint("WebView request ---- $request");
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url ?? ''));
  }
}
