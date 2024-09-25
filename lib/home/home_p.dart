import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiztime55/b/hep/tttt/tttt_hep.dart';
import 'package:quiztime55/global/clas/inp_clas_1.dart';
import 'package:quiztime55/home/quiz/quiz_p.dart';
import 'package:quiztime55/home/set/set_p.dart';

import '../global/widg/qt_image.dart';

class HomeP extends StatefulWidget {
  const HomeP({super.key});

  @override
  State<HomeP> createState() => _HomePState();
}

class _HomePState extends State<HomeP> {
  int i = 0;

  @override
  void initState() {
    super.initState();
    TTTTHep.instance.uploadLocalTbaData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(image: getBgDecorationImage("hrerw$i")),
        child: SafeArea(
            child: Column(
          children: [
            Expanded(
                child: IndexedStack(
              alignment: Alignment.topCenter,
              index: i,
              children: [QuizP(), SetP()],
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () {
                      if (i != 0) {
                        setState(() {
                          i = 0;
                        });
                      }
                    },
                    child: QtImage(i == 0 ? "gaewe_s" : "gaewe", w: 108.w, h: 64.w)),
                SizedBox(width: 18.w),
                InkWell(
                    onTap: () {
                      if (i != 1) {
                        setState(() {
                          i = 1;
                        });
                      }
                    },
                    child: QtImage(i == 1 ? "htgswe_s" : "htgswe", w: 108.w, h: 64.w))
              ],
            )
          ],
        )),
      ),
    );
  }
}
