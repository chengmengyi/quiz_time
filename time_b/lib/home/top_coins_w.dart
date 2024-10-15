import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_b/hep/call_listener/call_listener_hep.dart';
import 'package:time_b/hep/info_hep.dart';
import 'package:time_b/hep/value_hep.dart';
import 'package:time_base/hep/heppppp.dart';
import 'package:time_base/quiz_language/local_text.dart';
import 'package:time_base/w/qt_image.dart';
import 'package:time_base/w/ws_text.dart';

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
                QtText(moneyDou2Str(coins), fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.w500),
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
                    child: QtText(LocalText.withdraw.tr, fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.w500),
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
      Expanded(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.w),
          ),
          child: RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
                      text: moneyDou2Str(ValueHepB.instance.getToCashEarnNum()),
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
                      text: moneyDou2Str(ValueHepB.instance.getNextCashNum().toDouble()),
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
        ),
      )
    ],
  );
}