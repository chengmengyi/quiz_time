import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiztime55/global/clas/inp_clas_1.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../global/appd/qt_str.dart';
import '../../global/widg/qt_image.dart';
import '../../global/widg/ws_text.dart';

class SetP extends StatelessWidget {
  const SetP({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
        SizedBox(height: 23.w),
        _item("ygeewe", gQtStr.jrooe, () {
          launchUrl(Uri.parse("https://www.google.com/"));
        }),
        SizedBox(height: 2.w),
        _item("krui", gQtStr.hrew, () {
          launchUrl(Uri.parse("https://www.google.com/"));
        }),
        SizedBox(height: 2.w),
        _item("cuer", gQtStr.btnr, () {
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
