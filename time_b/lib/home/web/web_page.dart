import 'package:flutter/material.dart';
import 'package:time_base/hep/heppppp.dart';
import 'package:time_base/hep/save/qt_str.dart';
import 'package:time_base/quiz_language/local_text.dart';
import 'package:time_base/quiz_language/quiz_translations.dart';
import 'package:time_base/time_base.dart';
import 'package:time_base/w/qt_image.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage>{

  late WebViewController webViewController;

  @override
  void initState() {
    super.initState();
    _initController();
    Future((){
      _loadUrl();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        const QtImage("hrerw0",w: double.infinity,h: double.infinity,),
        SafeArea(
          top: true,
          child: Column(
            children: [
              _titleWidget(),
              Expanded(
                child: WebViewWidget(controller: webViewController),
              )
            ],
          ),
        ),
      ],
    ),
  );

  _titleWidget()=>SizedBox(
    width: double.infinity,
    height: 50,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Stack(
          children: [
            Text(LocalText.playAndLearn.tr,
                style: TextStyle(
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 1.w
                      ..color = const Color(0xFF6F5E27),
                    fontSize: 24.sp,
                    height: 1.3,
                    fontFamily: "oirirj",
                    fontWeight: FontWeight.w500)),
            ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFFE798), Color(0xFFB8A460)]).createShader(bounds),
                child: Text(LocalText.playAndLearn.tr,
                    style: TextStyle(fontSize: 24.sp, height: 1.3, fontFamily: "oirirj", fontWeight: FontWeight.w500))),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back,color: Colors.white,),
          ),
        )
      ],
    ),
  );

  _initController(){
    webViewController=WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            var url = _checkToBrowser(request.url);
            if(url.isNotEmpty){
              TimeBase.instance.showUrlByBrowser(url: url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
  }

  _loadUrl()async{
    var url="https://s.gamifyspace.com/tml?pid=12997&appk=zbTtTBL6b1ULBVd6c0YgBB0dPilslt9k&did=${await FlutterTbaInfo.instance.getGaid()}&cdid=${await FlutterTbaInfo.instance.getDistinctId()}";
    webViewController.loadRequest(Uri.parse(url));
  }

  String _checkToBrowser(String url){
    if (url.startsWith("market:") ||
        url.startsWith("https://play.google.com/store/") ||
        url.startsWith("http://play.google.com/store/") ||
        url.startsWith("intent://") ||
        url.endsWith(".apk")) {
      if (url.startsWith("market://details?id=")) {
        var newUrl = url.replaceAll("market://details", "https://play.google.com/store/apps/details");
        return newUrl;
      }
      return url;
    }
    return "";
  }
}