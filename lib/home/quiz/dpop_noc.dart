import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiztime55/global/clas/inp_clas_1.dart';

import '../../global/appd/qt_str.dart';
import '../../global/widg/qt_image.dart';
import '../../global/widg/ws_text.dart';

class DPopNoc extends StatelessWidget {
  const DPopNoc({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.w,
      height: 335.w,
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      decoration: BoxDecoration(image: getBgDecorationImage("mkres")),
      child: Column(
        children: [
          SizedBox(height: 32.w),
          QtImage("kelioe", w: 120.w, h: 120.w),
          SizedBox(height: 16.w),
          QtText(gQtStr.hawwe,
              fontSize: 14.sp, color: const Color(0xFFA36B21), fontWeight: FontWeight.w400, textAlign: TextAlign.center),
          SizedBox(height: 16.w),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 220.w,
              height: 56.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(image: getBgDecorationImage("gawerw220")),
              child: QtText(gQtStr.gaw,
                  fontSize: 18.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  shadows: [Shadow(color: Colors.black.withOpacity(0.25), blurRadius: 2.w, offset: Offset(0, 1.w))]),
            ),
          ),
          SizedBox(height: 6.w),
        ],
      ),
    );
  }
}
