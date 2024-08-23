import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiztime55/global/appd/qt_str.dart';
import 'package:quiztime55/home/quiz/cur_v.dart';

import '../../global/widg/qt_image.dart';
import '../../global/widg/ws_text.dart';
import 'fre_v.dart';

class QuizP extends StatefulWidget {
  const QuizP({super.key});

  @override
  State<QuizP> createState() => _QuizPState();
}

class _QuizPState extends State<QuizP> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 12.w),
            const CurV(),
            SizedBox(width: 8.w),
            const FreV(),
            const Spacer(),
            Container(
              height: 28.w,
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), borderRadius: BorderRadius.circular(14.w)),
              child: Row(
                children: [
                  SizedBox(width: 10.w),
                  QtImage("herwrg", w: 20.w, h: 20.w),
                  SizedBox(width: 10.w),
                  QtText(gQtStr.heew, fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.w500),
                  SizedBox(width: 15.w)
                ],
              ),
            ),
            SizedBox(width: 12.w)
          ],
        )
      ],
    );
  }
}
