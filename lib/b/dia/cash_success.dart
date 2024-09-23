import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiztime55/b/hep/heppppp.dart';
import 'package:quiztime55/b/hep/tttt/point_name.dart';
import 'package:quiztime55/b/hep/tttt/tttt_hep.dart';
import 'package:quiztime55/global/widg/qt_image.dart';
import 'package:quiztime55/global/widg/ws_text.dart';

class CashSuccessDialog extends StatelessWidget{
  int chooseMoney;
  CashSuccessDialog({required this.chooseMoney});

  @override
  Widget build(BuildContext context)=>WillPopScope(
    child: Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          margin: EdgeInsets.only(left: 8.w,right: 8.w),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              QtImage("mofmew",w: double.infinity,h: 284.h,),
              Container(
                margin: EdgeInsets.only(top: 24.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    QtText("Congratulations!", fontSize: 24.sp, color: const Color(0xffFFFDF5), fontWeight: FontWeight.w600,),
                    SizedBox(height: 36.h,),
                    QtText("+\$$chooseMoney", fontSize: 32.sp, color: const Color(0xffF26805), fontWeight: FontWeight.w500,),
                    Container(
                      margin: EdgeInsets.only(left: 36.w,right: 36.w,top: 10.h),
                      child: QtText("Your cash will arrive in your account within 3-7 business days. Please keep an eye on your account!", fontSize: 14.sp, color: const Color(0xffA36B21), fontWeight: FontWeight.w400,textAlign: TextAlign.center,),
                    ),
                    SizedBox(height: 16.h,),
                    InkWell(
                      onTap: (){
                        TTTTHep.instance.pointEvent(PointName.cash_suc_pop_c);
                        closeDialog();
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          QtImage("btn",w: 220.w,h: 56.h,),
                          QtText("I Known", fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.w500,),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  onTap: (){
                    closeDialog();
                  },
                  child: QtImage("icon_close",w: 40.w,h: 40.w,),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    onWillPop: ()async{
      return false;
    },
  );
}