import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class MenuBookModalFinal extends StatefulWidget {
  const MenuBookModalFinal({Key? key}) : super(key: key);

  @override
  State<MenuBookModalFinal> createState() => _MenuBookModalFinalState();
}

class _MenuBookModalFinalState extends State<MenuBookModalFinal> {
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
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 90),
      child: Dialog(
          backgroundColor: Colors.transparent,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide()),
          child: Stack(children: [
            Positioned(
                right: 10,
                top: 40,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.cancel_outlined,
                      color: Colors.white,
                    ),
                  iconSize: 60,
                )),
            Container(
                margin: EdgeInsets.only(top: 150, bottom: 300),
                child: WebViewWidget(controller: _controller)),
          ])),
    );
  }
}
