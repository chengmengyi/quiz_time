import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../global/appd/qt_quiz_hep.dart';
import '../../global/appd/qt_str.dart';
import '../../global/clas/inp_clas_1.dart';
import '../../global/widg/qt_image.dart';
import '../../global/widg/ws_text.dart';

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
            qPitem(QtQuizHep.QH_NK_N, context),
            qPitem(QtQuizHep.QH_NK_H, context),
            qPitem(QtQuizHep.QH_NK_S, context),
            qPitem(QtQuizHep.QH_NK_M, context),
            qPitem(QtQuizHep.QH_NK_A, context),
          ],
        )),
      ),
    );
  }

  Widget qPitem(String nk, BuildContext context) {
    var max = QtQuizHep.getItems(nk)?.length ?? 1;
    var inp = QtQuizHep.getKeyPosSave(nk).getV();
    var isCom = inp >= max;

    return Container(
      width: 352.w,
      height: 96.w,
      decoration: BoxDecoration(image: getBgDecorationImage("ghteww")),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
                  catPro(isCom, inp / max),
                  SizedBox(width: 4.w),
                  QtText(
                    "($inp/$max)",
                    fontSize: 12.sp,
                    color: isCom ? const Color(0xFF3DB24F) : const Color(0xFFED7200),
                    fontWeight: FontWeight.w400,
                  )
                ],
              )
            ],
          ),
          SizedBox(width: 2.w),
          InkWell(
            onTap: () {
              if (!isCom) {
                Navigator.pop(context, nk);
              }
            },
            child: Container(
              width: 68.w,
              height: 32.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(image: getBgDecorationImage(isCom ? "gawerw68_g" : "gawerw68")),
              child: QtText(isCom ? gQtStr.bher : gQtStr.hreerw,
                  fontSize: 12.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  shadows: [Shadow(color: Colors.black.withOpacity(0.25), blurRadius: 1.w, offset: Offset(0, 0.5.w))]),
            ),
          )
        ],
      ),
    );
  }

  //进度条
  Widget catPro(bool isCom, double d) {
    return Container(
        width: 140.w,
        height: 12.w,
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(image: getBgDecorationImage("nyrtee")),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: min(d, 1),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.w),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isCom
                      ? [const Color(0xFFFFF681), const Color(0xFFCEFFA7), const Color(0xFF41C556)]
                      : [const Color(0xFFFFF681), const Color(0xFFFFAE12)]),
            ),
          ),
        ));
  }
}
