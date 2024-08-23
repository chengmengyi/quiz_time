import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../global/appd/qt_quiz_hep.dart';
import '../../global/appd/qt_str.dart';
import '../../global/clas/inp_clas_1.dart';
import '../../global/widg/qt_image.dart';
import '../../global/widg/ws_text.dart';

//TODO 进入该页确保json解析完成，可在跳转的地方await json 初始化（需枷锁）
class CatP extends StatelessWidget {
  const CatP({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(image: getBgDecorationImage("jrgerw")),
        child: SafeArea(
            child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: 12.w),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: QtImage("hserrt", w: 36.w, h: 36.w)),
                SizedBox(width: 12.w),
                QtText(
                  gQtStr.heew,
                  fontSize: 18.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                )
              ],
            ),
            SizedBox(height: 18.w),
            qPitem(QtQuizHep.QH_NK_N),
            qPitem(QtQuizHep.QH_NK_H),
            qPitem(QtQuizHep.QH_NK_S),
            qPitem(QtQuizHep.QH_NK_M),
            qPitem(QtQuizHep.QH_NK_A),
          ],
        )),
      ),
    );
  }

  Widget qPitem(String nk) {
    return Container(
      width: 352.w,
      height: 96.w,
      padding: EdgeInsets.symmetric(horizontal: 26.w),
      decoration: BoxDecoration(image: getBgDecorationImage("ghteww")),
      child: Row(
        children: [
          Stack(
            children: [
              QtImage("htreverb", w: 48.w, h: 48.w),
              QtImage("htreer_$nk", w: 44.w, h: 44.w),
            ],
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              QtText(
                QtQuizHep.getKeyName(nk),
                fontSize: 16.sp,
                color: const Color(0xFF673A13),
                fontWeight: FontWeight.w500,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  catPro(0.1),
                  SizedBox(width: 4.w),
                  QtText(
                    "(x/x)",
                    fontSize: 12.sp,
                    color: const Color(0xFFED7200),
                    fontWeight: FontWeight.w400,
                  )
                ],
              )
            ],
          ),
          SizedBox(width: 2.w),
          //TODO 按钮
        ],
      ),
    );
  }

  //进度条
  Widget catPro(double d) {
    return Container(
        width: 140.w,
        height: 12.w,
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(image: getBgDecorationImage("nyrtee")),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: d,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.w),
              gradient: const LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFFFF681), Color(0xFFFFAE12)]),
            ),
          ),
        ));
  }
}
