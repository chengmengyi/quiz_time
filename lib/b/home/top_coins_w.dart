import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiztime55/b/hep/info_hep.dart';
import 'package:quiztime55/global/widg/qt_image.dart';
import 'package:quiztime55/global/widg/ws_text.dart';

class TopCoinsW extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _TopCoinsWState();
}

class _TopCoinsWState extends State<TopCoinsW>{
  var coins=InfoHep.instance.userCoins;

  @override
  void initState() {
    super.initState();
    coinsBean.listen((v){
      setState(() {
        coins=v;
      });
    });
  }
  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Container(
        height: 28.w,
        padding: EdgeInsets.only(left: 32.w,right: 2.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.w),
          color: Colors.black.withOpacity(0.4)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            QtText("\$$coins", fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.w500),
            SizedBox(width: 10.w,),
            InkWell(
              child: Container(
                height: 24.w,
                padding: EdgeInsets.only(left: 8.w,right: 8.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xffFA9600),
                  borderRadius: BorderRadius.circular(12.w),
                ),
                child: QtText("withdraw", fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
      QtImage("money2",w: 28.w,h: 28.w,),
    ],
  );
}