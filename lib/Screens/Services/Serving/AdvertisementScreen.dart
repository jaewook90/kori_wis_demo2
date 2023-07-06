import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class ADScreen extends StatefulWidget {
  const ADScreen({Key? key}) : super(key: key);

  @override
  State<ADScreen> createState() => _ADScreenState();
}

class _ADScreenState extends State<ADScreen> with TickerProviderStateMixin {
  FirebaseFirestore robotDb = FirebaseFirestore.instance;

  // late final WebViewController _controller;
  late VideoPlayerController _controller;

  final String introVideo = 'assets/videos/KoriIntro_v1.1.0.mp4';

  @override
  void initState() {
    super.initState();
    // // 웹 플레이어
    // _controller = VideoPlayerController.networkUrl(
    //   Uri.parse(
    //       'https://files.exaconnector.com/apk/jw_test/test_file/KoriIntro_v1.1.0.mp4'),
    //   // closedCaptionFile: _loadCaptions(),
    //   videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    // );
    //
    // _controller.addListener(() {
    //   setState(() {});
    // });
    // _controller.setLooping(true);
    // _controller.initialize();
    //
    // 어셋 플레이어
    _controller = VideoPlayerController.asset(introVideo)
      ..initialize().then((_) {
        _controller.setLooping(false);
        // setLooping -> true 무한반복 false 1회 재생
        setState(() {});
      });

    if (Provider.of<ServingModel>(context, listen: false).servingState == 2) {
      const int newState = 0;
      final data = {"serviceState": newState};
      robotDb
          .collection("servingBot1")
          .doc("robotState")
          .set(data, SetOptions(merge: true));
    }


    // late final PlatformWebViewControllerCreationParams params;
    //
    // if (WebViewPlatform.instance is WebKitWebViewPlatform) {
    //   params = WebKitWebViewControllerCreationParams(
    //     allowsInlineMediaPlayback: true,
    //     mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
    //   );
    // } else {
    //   params = const PlatformWebViewControllerCreationParams();
    // }
    //
    // final WebViewController controller =
    // WebViewController.fromPlatformCreationParams(params);
    //
    // controller
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //   ..setBackgroundColor(const Color(0x00000000))
    //   ..setNavigationDelegate(
    //     NavigationDelegate(
    //       onProgress: (int progress) {
    //         debugPrint('WebView is loading (progress : $progress%)');
    //       },
    //       onPageStarted: (String url) {
    //         debugPrint('Page started loading: $url');
    //       },
    //       onPageFinished: (String url) {
    //         debugPrint('Page finished loading: $url');
    //       },
    //       onWebResourceError: (WebResourceError error) {
    //         debugPrint('''
    //
    //           Page resource error:
    //
    //             code: ${error.errorCode}
    //
    //             description: ${error.description}
    //
    //             errorType: ${error.errorType}
    //
    //             isForMainFrame: ${error.isForMainFrame}
    //
    //       ''');
    //       },
    //       onNavigationRequest: (NavigationRequest request) {
    //         debugPrint('allowing navigation to ${request.url}');
    //
    //         return NavigationDecision.navigate;
    //       },
    //     ),
    //   )
    //   ..addJavaScriptChannel(
    //     'Toaster',
    //     onMessageReceived: (JavaScriptMessage message) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(content: Text(message.message)),
    //       );
    //     },
    //   )
    //   ..loadRequest(Uri.parse('https://files.exaconnector.com/apk/jw_test/test_file/KoriIntro_v1.1.0.mp4'));
    // // ..loadRequest(Uri.parse('http://172.30.1.35/'));
    //
    // if (controller.platform is AndroidWebViewController) {
    //   AndroidWebViewController.enableDebugging(true);
    //
    //   (controller.platform as AndroidWebViewController)
    //       .setMediaPlaybackRequiresUserGesture(false);
    // }
    //
    // _controller = controller;

    _playVideo();
  }

  void _playVideo() async {
    await Future.delayed(const Duration(seconds: 1));
    _controller.play();
  }

  void getStarted_readData() async {
    // [START get_started_read_data]
    await robotDb.collection("servingBot1").get().then((event) {
      for (var doc in event.docs) {
        if (doc.id == "robotState") {
          print(doc.data()['serviceState']);
          setState(() {
            Provider.of<ServingModel>(context, listen: false).servingState =
                doc.data()['serviceState'];
          });
          if (doc.data()['serviceState'] == 3) {
            const int newState = 0;
            final data = {"serviceState": newState};
            robotDb
                .collection("servingBot1")
                .doc("robotState")
                .set(data, SetOptions(merge: true));
            Navigator.pop(context);
          }
        }
      }
    });
    Future.delayed(Duration(microseconds: 100));
    // [END get_started_read_data]
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  var deviceId1 = "";
  //
  // // 웹뷰 위젯
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       leading: ElevatedButton(
  //         onPressed: (){
  //           Navigator.pop(context);
  //         },
  //         child: Icon(Icons.add),
  //       ),
  //     ),
  //     body: Container(
  //       height: MediaQuery.of(context).size.height,
  //       width: MediaQuery.of(context).size.width,
  //       child: SafeArea(
  //         child: WebViewWidget(controller: _controller),
  //       ),
  //     ),
  //   );
  // }
  //

//  비디오 플레이어 유ㅣ젯
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double videoWidth = _controller.value.size.width;
    double videoHeight = _controller.value.size.height;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getStarted_readData();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            const int newState = 3;
            final data = {"serviceState": newState};
            robotDb
                .collection("servingBot1")
                .doc("robotState")
                .set(data, SetOptions(merge: true));
          });
        },
        child: Center(
          child: Scaffold(
            body: Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screenWidth,
                        height: screenHeight * 0.8,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: videoWidth,
                            height: videoHeight,
                            child: _controller.value.isInitialized
                                ? AspectRatio(
                                    aspectRatio: _controller.value.aspectRatio,
                                    child: Stack(children: [
                                      VideoPlayer(
                                        _controller,
                                      ),
                                      ClosedCaption(text: _controller.value.caption.text),
                                      VideoProgressIndicator(_controller, allowScrubbing: true),
                                    ]),
                                  )
                                : Container(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
