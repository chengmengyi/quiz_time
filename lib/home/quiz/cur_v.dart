import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../global/appd/qt_cur.dart';
import '../../global/widg/qt_image.dart';
import '../../global/widg/ws_text.dart';

class CurV extends StatefulWidget {
  const CurV({super.key});

  @override
  State<CurV> createState() => _CurVState();
}

class _CurVState extends State<CurV> with SingleTickerProviderStateMixin {
  int oldCur = QtCur.cur;

  late AnimationController curvAniC;
  late Animation curvAni;

  late Function() lis;

  @override
  void initState() {
    curvAniC = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    curvAniC.addListener(() {
      setState(() {
        oldCur = curvAni.value;
      });
    });

    curvAniC.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          oldCur = QtCur.cur;
        });
      }
    });

    lis = QtCur.curLis((c) {
      curvAni = IntTween(begin: oldCur, end: c).chain(CurveTween(curve: Curves.ease)).animate(curvAniC);
      curvAniC.forward(from: 0);
    });

    super.initState();
  }

  @override
  void dispose() {
    curvAniC.dispose();
    lis.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28.w,
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), borderRadius: BorderRadius.circular(14.w)),
      child: Row(
        children: [
          QtImage("hbrw", w: 28.w, h: 28.w),
          SizedBox(width: 10.w),
          QtText(oldCur.toString(), fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.w500),
          SizedBox(width: 15.w)
        ],
      ),
    );
  }
}
