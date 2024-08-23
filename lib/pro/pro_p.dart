import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiztime55/global/widg/qt_image.dart';
import 'package:quiztime55/global/widg/ws_text.dart';
import 'package:quiztime55/pro/pro_pro.dart';

import '../global/clas/inp_clas_1.dart';
import '../home/home_p.dart';

class ProP extends StatelessWidget {
  const ProP({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          const QtImage("heerw", w: double.infinity, h: double.infinity),
          Positioned(
            top: 130.w,
            child: QtImage("fwgaw", w: 132.w, h: 132.w),
          ),
          Positioned(
            top: 265.w,
            child: QtText("QuizTime", fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.w400),
          ),
          Positioned(
            bottom: 125.w,
            child: ProPro(() {
              Navigator.pushReplacement(context, getMaterialRoute(const HomeP()));
            }),
          ),
        ],
      ),
    );
  }
}
