import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiztime55/global/clas/inp_clas_1.dart';

import '../../global/appd/qt_save.dart';
import '../../global/appd/qt_str.dart';
import '../../global/widg/qt_image.dart';
import '../../global/widg/ws_text.dart';

class QuizConV extends StatefulWidget {
  const QuizConV({super.key});

  @override
  State<QuizConV> createState() => _QuizConVState();
}

class _QuizConVState extends State<QuizConV> {
  int level = levelK.getV();

  @override
  void initState() {
    //TODO 等级、类别，监听
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20.w),
          child: Container(
            height: 520.w,
            padding: EdgeInsets.symmetric(horizontal: 50.w),
            decoration: BoxDecoration(image: getBgDecorationImage("gwegr")),
            child: Column(
              children: [
                SizedBox(height: 46.w),
                levelL(),
                SizedBox(height: 12.w),
                Divider(height: 0.5.w, color: const Color(0xFFE7AE66)),
                SizedBox(height: 7.w),
                Container(
                  alignment: Alignment.center,
                  height: 200.w,
                  child: QtText(
                    "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
                    fontSize: 16.sp,
                    color: const Color(0xFF774607),
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 42.w),
                ans("A"),
                SizedBox(height: 20.w),
                ans("B"),
              ],
            ),
          ),
        ),
        titleL()
      ],
    );
  }

  Widget titleL() {
    return Transform.translate(
      offset: Offset(-18.w, 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          QtImage("etgeewe", w: 204.w, h: 48.w),
          Transform.translate(
            offset: Offset(12.w, 0),
            child: QtText(
              "xxxx",
              fontSize: 21.sp,
              color: const Color(0xFFFFF1CD),
              fontWeight: FontWeight.w600,
              shadows: [Shadow(color: const Color(0xFFD03938), blurRadius: 1.w, offset: Offset(0, 2.w))],
            ),
          ),
        ],
      ),
    );
  }

  Widget levelL() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        QtText(
          qtRepAs(gQtStr.agewft, "$level"),
          fontSize: 21.sp,
          color: const Color(0xFFE46000),
          fontWeight: FontWeight.w500,
        ),
        SizedBox(width: 8.w),
        QtText(
          "(x/x)",
          fontSize: 16.sp,
          color: const Color(0xFFE46000),
          fontWeight: FontWeight.w500,
        )
      ],
    );
  }

  Widget ans(String tip) {
    return Container(
      width: 240.w,
      height: 44.w,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(image: getBgDecorationImage("fgewer")),
      child: QtText(
        "$tip.xxxx",
        fontSize: 18.sp,
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
