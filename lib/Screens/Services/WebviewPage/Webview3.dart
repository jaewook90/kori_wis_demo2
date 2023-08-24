import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Widgets/appBarAction.dart';
import 'package:kori_wis_demo/Widgets/appBarStatus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebviewPage3 extends StatefulWidget {
  const WebviewPage3({Key? key}) : super(key: key);

  @override
  State<WebviewPage3> createState() => _WebviewPage3State();
}

class _WebviewPage3State extends State<WebviewPage3> {
  late final WebViewController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    late final PlatformWebViewControllerCreationParams params;

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''

              Page resource error:

                code: ${error.errorCode}

                description: ${error.description}

                errorType: ${error.errorType}

                isForMainFrame: ${error.isForMainFrame}

          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint('allowing navigation to ${request.url}');

            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(
          'http://43.200.215.116/connector/client/material/?sid=1&cid=3'));

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);

      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(true);
    }

    _controller = controller;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: const [
          SizedBox(
            width: 1080,
            height: 108,
            child: Stack(
              children: [
                AppBarStatus(),
                AppBarAction(homeButton: true,)
              ],
            ),
          )
        ],
        toolbarHeight: 110,
        iconTheme: const IconThemeData(size: 70, color: Color(0xfffefeff)),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SizedBox(
              width: 1080,
              height: 1920,
              child: WebViewWidget(controller: _controller)),
        ],
      ),
    );
  }
}
