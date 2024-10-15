import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_base/hep/heppppp.dart';
import 'package:time_base/hep/notification/notification_hep.dart';
import 'package:time_base/hep/tttt/point_name.dart';
import 'package:time_base/hep/tttt/tttt_hep.dart';
import 'package:time_base/time_base.dart';

//进度条
class ProPro extends StatefulWidget {
  final Function() call;

  const ProPro(this.call, {super.key});

  @override
  State<ProPro> createState() => _ProProState();
}

class _ProProState extends State<ProPro> with SingleTickerProviderStateMixin {
  late AnimationController proAniC;
  late Animation proAni;

  @override
  void initState() {
    proAniC = AnimationController(vsync: this);
    proAni = Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: Curves.ease)).animate(proAniC);

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      proAniC.duration = const Duration(seconds: 15);

      await proAniC.forward(from: proAniC.value);
      widget.call();
    });
    NotificationHep.instance.checkLaunchAppFrom();
  }

  @override
  void dispose() {
    proAniC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140.w,
      height: 8.w,
      decoration: BoxDecoration(
        color: const Color(0xFF5BA3C6),
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(4.w),
          child: AnimatedBuilder(
            animation: proAni,
            builder: (context, child) => FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: proAni.value,
              child: child,
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(29.w),
                color: Colors.white,
              ),
            ),
          )),
    );
  }
}
