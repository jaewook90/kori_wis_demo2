import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebviewPage2 extends StatefulWidget {
  const WebviewPage2({Key? key}) : super(key: key);

  @override
  State<WebviewPage2> createState() => _WebviewPage2State();
}

class _WebviewPage2State extends State<WebviewPage2> {
  late final WebViewController _controller;
  late ServingModel _servingProvider;

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.mp3';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initAudio();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _initAudio();
    // });

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
          'http://192.168.0.111/connector/client/material/?sid=1&cid=2'));
    // ..loadRequest(Uri.parse('http://172.30.1.35/'));

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);

      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(true);
    }

    _controller = controller;
  }

  void _initAudio() {
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(1);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _effectPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    return Scaffold(
      body: Container(
        // padding: const EdgeInsets.only(top: 90),
        child: Stack(children: [
          Container(
            // margin: EdgeInsets.only(top: 50),
              width: 1080,
              height: 1920,
              child: WebViewWidget(controller: _controller)),
          Positioned(
              right: 50,
              top: 20,
              child: IconButton(
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _effectPlayer.play();
                    setState(() {
                      _servingProvider.mainInit = true;
                    });
                    navPage(
                      context: context,
                      page: const TraySelectionFinal(),
                    ).navPageToPage();
                  });
                },
                icon: const Icon(
                  Icons.close,
                ),
                iconSize: 60,
                color: const Color.fromRGBO(0, 0, 0, 0.4),
              ))
        ]),
      ),
    );
  }
}
