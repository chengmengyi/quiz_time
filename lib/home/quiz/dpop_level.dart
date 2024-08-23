import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiztime55/global/clas/inp_clas_1.dart';

import '../../global/appd/qt_str.dart';
import '../../global/widg/qt_image.dart';
import '../../global/widg/ws_text.dart';

class DPopLevel extends StatelessWidget {
  final int level;

  const DPopLevel(this.level, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 344.w,
      height: 456.w,
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      decoration: BoxDecoration(image: getBgDecorationImage("ktyefawf456")),
      child: Column(
        children: [
          SizedBox(height: 19.w),
          QtText(
            gQtStr.nrree,
            fontSize: 24.sp,
            color: const Color(0xFFFFFDF5),
            fontWeight: FontWeight.w600,
            shadows: [Shadow(color: const Color(0xFFCA780A), blurRadius: 2.w, offset: Offset(0, 2.w))],
          ),
          SizedBox(height: 40.w),
          QtImage("hgrew", w: 120.w, h: 120.w),
          SizedBox(height: 20.w),
          QtText(
            qtRepAs(gQtStr.hreh, "$level"),
            fontSize: 18.sp,
            color: const Color(0xFF774607),
            fontWeight: FontWeight.w400,
          ),
          SizedBox(height: 9.w),
          QtText(
            gQtStr.hreww,
            fontSize: 14.sp,
            color: const Color(0xFFA36B21),
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 17.w),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 220.w,
              height: 56.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(image: getBgDecorationImage("gawerw220")),
              child: QtText(gQtStr.hhew,
                  fontSize: 18.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  shadows: [Shadow(color: Colors.black.withOpacity(0.25), blurRadius: 2.w, offset: Offset(0, 1.w))]),
            ),
          ),
          SizedBox(height: 6.w),
          InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: QtText(gQtStr.nrew, fontSize: 18.sp, color: const Color(0xFFD9831E), fontWeight: FontWeight.w500))
        ],
      ),
    );
  }
}
