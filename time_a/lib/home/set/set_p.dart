import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_base/hep/heppppp.dart';
import 'package:time_base/hep/save/qt_str.dart';
import 'package:time_base/quiz_language/local_text.dart';
import 'package:time_base/w/qt_image.dart';
import 'package:time_base/w/ws_text.dart';
import 'package:url_launcher/url_launcher.dart';



class SetP extends StatelessWidget {
  bool showBack;
  SetP({super.key, this.showBack=false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Stack(
              children: [
                Text(gQtStr.afwe,
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
                    child: Text(gQtStr.afwe,
                        style: TextStyle(fontSize: 24.sp, height: 1.3, fontFamily: "oirirj", fontWeight: FontWeight.w500))),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Visibility(
                visible: showBack,
                child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back,color: Colors.black,),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 23.w),
        _item("ygeewe", LocalText.privacyPolicy.tr, () {
          launchUrl(Uri.parse("http://quizrightanswer.com/privacy/"));
        }),
        SizedBox(height: 2.w),
        _item("krui", LocalText.termOfUser.tr, () {
          launchUrl(Uri.parse("https://quizrightanswer.com/terms/"));
        }),
        SizedBox(height: 2.w),
        _item("cuer", LocalText.contactUs.tr, () {
          launchUrl(Uri.parse("mailto:ilenes@thanksflooring.com"));
        })
      ],
    );
  }

  Widget _item(String ina, String nna, Function() click) {
    return InkWell(
      onTap: click,
      child: Container(
        width: 352.w,
        height: 76.w,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        decoration: BoxDecoration(image: getBgDecorationImage("ygrerrg")),
        child: Row(
          children: [
            QtImage(ina, w: 24.w, h: 24.w),
            SizedBox(width: 4.w),
            QtText(nna, fontSize: 16.sp, color: const Color(0xFF774607), fontWeight: FontWeight.w500),
            const Spacer(),
            QtImage("gnrwew", w: 24.w, h: 24.w),
          ],
        ),
      ),
    );
  }
}
