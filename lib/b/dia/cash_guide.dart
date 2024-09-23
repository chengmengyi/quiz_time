import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiztime55/b/hep/info_hep.dart';
import 'package:quiztime55/b/hep/tttt/point_name.dart';
import 'package:quiztime55/b/hep/tttt/tttt_hep.dart';
import 'package:quiztime55/b/hep/value_hep.dart';
import 'package:quiztime55/b/home/finger_w.dart';
import 'package:quiztime55/global/widg/qt_image.dart';
import 'package:quiztime55/global/widg/ws_text.dart';

class CashGuide extends StatelessWidget{
  var addNum=ValueHep.instance.getNewUserCoins();
  Function(bool toCash) dismissDialog;
  CashGuide({required this.dismissDialog});

  @override
  Widget build(BuildContext context)=>WillPopScope(
    child: Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          margin: EdgeInsets.only(left: 20.w,right: 20.w),
          child: Stack(
            alignment: Alignment.center,
            children: [
              QtImage("foefoe",w: double.infinity,h: 316.h,),
              Positioned(
                top: 8.w,
                right: 8.w,
                child: InkWell(
                  onTap: (){
                    _click(false, context);
                  },
                  child: QtImage("fggccx",w: 24.w,h: 24.w,),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  QtImage("money1", w: 160.w, h: 160.w),
                  QtText(
                    "+\$$addNum",
                    fontSize: 32.sp,
                    color: const Color(0xffF26805),
                    fontWeight: FontWeight.w500,
                  ),
                  InkWell(
                    onTap: (){
                      TTTTHep.instance.pointEvent(PointName.quiz_guide_cash_pop_c);
                      _click(true, context);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        QtImage("btn",w: 220.w,h: 56.h,),
                        QtText("Withdraw", fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.w500,)
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                right: 34.w,
                bottom: 8.h,
                child: FingerW(),
              )
            ],
          ),
        ),
      ),
    ),
    onWillPop: ()async{
      return false;
    },
  );


  _click(bool toCash,context){
    Navigator.pop(context);
    InfoHep.instance.addCoins(addNum.toDouble());
    dismissDialog.call(toCash);
  }
}