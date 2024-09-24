import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiztime55/b/hep/call_listener/call_listener_hep.dart';
import 'package:quiztime55/b/hep/info_hep.dart';
import 'package:quiztime55/b/hep/value_hep.dart';
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
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Stack(
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
                  onTap: (){
                    CallListenerHep.instance.changeHomeTab(1);
                  },
                  child: Container(
                    height: 24.w,
                    padding: EdgeInsets.only(left: 8.w,right: 8.w),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xffFA9600),
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                    child: QtText("Withdraw", fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          ),
          QtImage("money2",w: 28.w,h: 28.w,),
        ],
      ),
      SizedBox(width: 2.w,),
      Container(
        margin: EdgeInsets.only(top: 10.h),
        child: QtImage("nwomomod",w: 4.w,h: 8.h,),
      ),
      Container(
        width: 128.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.w),
        ),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Earn",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: "oirirj",
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff000000),
                )
              ),
              TextSpan(
                  text: "\$${ValueHep.instance.getToCashEarnNum()}",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: "oirirj",
                    fontWeight: FontWeight.w400,
                    color: const Color(0xffCF382F),
                  )
              ),
              TextSpan(
                  text: " More\n",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: "oirirj",
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff000000),
                  )
              ),
              TextSpan(
                  text: "To Withdraw",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: "oirirj",
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff000000),
                  )
              ),
              TextSpan(
                  text: "\$${ValueHep.instance.getNextCashNum()}",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: "oirirj",
                    fontWeight: FontWeight.w400,
                    color: const Color(0xffCF382F),
                  )
              ),
            ]
          ),
        ),
      )
    ],
  );
}