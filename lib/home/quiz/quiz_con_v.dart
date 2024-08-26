import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiztime55/global/clas/inp_clas_1.dart';
import 'package:quiztime55/global/pop/d_pop.dart';

import '../../global/appd/qt_cur.dart';
import '../../global/appd/qt_event.dart';
import '../../global/appd/qt_quiz_hep.dart';
import '../../global/appd/qt_save.dart';
import '../../global/appd/qt_str.dart';
import '../../global/widg/qt_image.dart';
import '../../global/widg/ws_text.dart';
import 'dpop_fal.dart';
import 'dpop_level.dart';
import 'dpop_noc.dart';
import 'dpop_yes.dart';

class QuizConV extends StatefulWidget {
  const QuizConV({super.key});

  @override
  State<QuizConV> createState() => _QuizConVState();
}

class _QuizConVState extends State<QuizConV> {
  Function()? f1;
  Function()? f2;

  int level = levelK.getV();

  var nk = QtQuizHep.qtCurK.getV();
  List<Map<String, dynamic>>? items;
  Map<String, dynamic>? item;

  String? select;

  @override
  void initState() {
    super.initState();

    f1 = QtEvent.listen(QtEvent.quizNk, (v) {
      QtQuizHep.qtCurK.putV(v);
      nk = v;
      items = QtQuizHep.getItems(nk);
      update();
    });

    f2 = levelK.listen((v) {
      setState(() {
        level = v;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await QtQuizHep.loadQtData();
      items = QtQuizHep.getItems(nk);
      update();
    });
  }

  @override
  void dispose() {
    f1?.call();
    f2?.call();
    super.dispose();
  }

  update() async {
    if (QtQuizHep.getKeyPosSave(nk).getV() >= (items?.length ?? 0)) {
      nk = QtQuizHep.checkNext();
      items = QtQuizHep.getItems(nk);
    }

    setState(() {
      select = null;
      item = items?[QtQuizHep.getKeyPosSave(nk).getV()];
    });
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
                    item?["qtq"] ?? "-",
                    fontSize: 16.sp,
                    color: const Color(0xFF774607),
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 42.w),
                ans("A", item?["qt_a"] ?? "-"),
                SizedBox(height: 20.w),
                ans("B", item?["qt_b"] ?? "-"),
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
              QtQuizHep.getKeyName(nk),
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
          "(${QtQuizHep.getKeyPosSave(nk).getV()}/${items?.length ?? 0})",
          fontSize: 16.sp,
          color: const Color(0xFFE46000),
          fontWeight: FontWeight.w500,
        )
      ],
    );
  }

  Widget ans(String tip, String ans) {
    var bgIc = "fgewer";
    String? endIc;

    if (select == tip) {
      if ((item?["qt_res"] ?? "-").toUpperCase() == tip) {
        endIc = "fearg";
        bgIc = "heeqwg";
      } else {
        endIc = "feargx";
        bgIc = "heeqwgx";
      }
    }

    return InkWell(
      onTap: () {
        if (freK.getV() <= 0) {
          const DPopNoc().dPop(context);
        } else {
          if (select == null) {
            setState(() {
              select = tip;
            });

            checkAns();
          }
        }
      },
      child: Container(
        width: 240.w,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
        decoration: BoxDecoration(image: getBgDecorationImage(bgIc)),
        child: Row(
          children: [
            Expanded(
              child: QtText(
                "$tip.$ans",
                fontSize: 18.sp,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (endIc != null) QtImage(endIc, w: 24.w, h: 24.w)
          ],
        ),
      ),
    );
  }

  checkAns() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted && select != null) return;

    if ((item?["qt_res"] ?? "-").toUpperCase() == select) {
      //答对
      await const DPopYes(10).dPop(context);

      levelProK.addV(-1);
      if (levelProK.getV() <= 0) {
        await DPopLevel(level + 1).dPop(context);
        levelK.addV(1);
        levelProK.putV(levelProK.def());
      }

      QtCur.putCur(10);

      QtQuizHep.getKeyPosSave(nk).addV(1);
      update();
    } else {
      //答错
      freK.addV(-1);

      if (await const DPopFal().dPop(context) == 1) {
        setState(() {
          select = null;
        });
      } else {
        QtQuizHep.getKeyPosSave(nk).addV(1);
        update();
      }
    }
  }
}
