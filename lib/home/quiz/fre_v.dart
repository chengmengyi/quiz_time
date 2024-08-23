import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../global/appd/qt_save.dart';
import '../../global/widg/qt_image.dart';
import '../../global/widg/ws_text.dart';

class FreV extends StatefulWidget {
  const FreV({super.key});

  @override
  State<FreV> createState() => _FreVState();
}

class _FreVState extends State<FreV> {
  int fre = freK.getV();

  late Function() lis;

  @override
  void initState() {
    lis = freK.listen((v) {
      setState(() {
        fre = v;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
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
          QtImage("hhrww", w: 28.w, h: 28.w),
          SizedBox(width: 10.w),
          QtText(fre.toString(), fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.w500),
          SizedBox(width: 15.w)
        ],
      ),
    );
  }
}
