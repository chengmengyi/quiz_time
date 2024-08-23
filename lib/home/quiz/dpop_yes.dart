import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiztime55/global/clas/inp_clas_1.dart';

import '../../global/appd/qt_str.dart';
import '../../global/widg/qt_image.dart';
import '../../global/widg/ws_text.dart';

class DPopYes extends StatelessWidget {
  final int v;

  const DPopYes(this.v, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 344.w,
      height: 378.w,
      decoration: BoxDecoration(image: getBgDecorationImage("ktyefawf368")),
      child: Column(
        children: [
          SizedBox(height: 21.w),
          QtText(
            gQtStr.hew,
            fontSize: 24.sp,
            color: const Color(0xFFFFFDF5),
            fontWeight: FontWeight.w600,
            shadows: [Shadow(color: const Color(0xFFCA780A), blurRadius: 2.w, offset: Offset(0, 2.w))],
          ),
          SizedBox(height: 27.w),
          QtImage("hsner", w: 120.w, h: 120.w),
          SizedBox(height: 4.w),
          QtText("+$v", fontSize: 32.sp, color: const Color(0xFFF26805), fontWeight: FontWeight.w500),
          SizedBox(height: 18.w),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 220.w,
              height: 56.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(image: getBgDecorationImage("gawerw220")),
              child: QtText(gQtStr.gawr,
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
