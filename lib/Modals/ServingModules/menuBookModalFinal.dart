import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class MenuBookScreen extends StatefulWidget {
  const MenuBookScreen({Key? key}) : super(key: key);

  @override
  State<MenuBookScreen> createState() => _MenuBookScreenState();
}

class _MenuBookScreenState extends State<MenuBookScreen> {
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
      ..loadRequest(
          Uri.parse('http://192.168.0.111/connector/client/material/?sid=1'));
    // ..loadRequest(Uri.parse('http://172.30.1.35/'));

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);

      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(true);
    }

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: [
          Container(
            width: 1080,
            child: Stack(
              children: [Positioned(
                left: 20,
                top: 10,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: FilledButton.styleFrom(
                      fixedSize: const Size(90, 90),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      backgroundColor: Colors.transparent),
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              'assets/icons/appBar/appBar_Backward.png',
                            ),
                            fit: BoxFit.fill)),
                  ),
                ),
              ),]
            ),
          ),
        ],
        toolbarHeight: 110,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        padding: const EdgeInsets.only(top: 90),
        child: Stack(children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            width: 1080,
              height: 1920,
              child: WebViewWidget(controller: _controller)),
        ]),
      ),
    );
  }
}
