import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_a/hep/call_listener/call_listener_hep.dart';
import 'package:time_base/hep/heppppp.dart';
import 'package:time_base/quiz_language/local_text.dart';
import 'package:time_base/w/qt_image.dart';
import 'package:time_base/w/ws_text.dart';

class NoMoneyDialog extends StatelessWidget{
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
              QtImage("jiowjofw",w: double.infinity,h: 240.h,),
              Container(
                margin: EdgeInsets.only(top: 24.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    QtText(LocalText.insufficientBalance.tr, fontSize: 24.sp, color: const Color(0xffFFFDF5), fontWeight: FontWeight.w600,),
                    Container(
                      margin: EdgeInsets.only(left: 36.w,right: 36.w,top: 36.h),
                      child: QtText(LocalText.yourAccountBalanceIsInsufficient.tr, fontSize: 14.sp, color: const Color(0xffA36B21), fontWeight: FontWeight.w400,textAlign: TextAlign.center,),
                    ),
                    SizedBox(height: 16.h,),
                    InkWell(
                      onTap: (){
                        closeDialog();
                        CallListenerHep.instance.changeHomeTab(0);
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          QtImage("btn",w: 220.w,h: 56.h,),
                          QtText(LocalText.earnMoreCash.tr, fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.w500,),
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