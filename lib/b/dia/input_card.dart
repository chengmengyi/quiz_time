import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiztime55/b/hep/heppppp.dart';
import 'package:quiztime55/global/widg/qt_image.dart';
import 'package:quiztime55/global/widg/ws_text.dart';

class InputCardDialog extends StatelessWidget{
  int chooseMoney;
  Function(String cardNum) call;
  String content="";

  InputCardDialog({
    required this.chooseMoney,
    required this.call,
  });

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
              QtImage("jfgh",w: double.infinity,h: 356.h,),
              Container(
                margin: EdgeInsets.only(top: 24.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    QtText("Congratulations!", fontSize: 24.sp, color: const Color(0xffFFFDF5), fontWeight: FontWeight.w600,),
                    SizedBox(height: 36.h,),
                    QtText("+\$$chooseMoney", fontSize: 32.sp, color: const Color(0xffF26805), fontWeight: FontWeight.w500,),
                    SizedBox(height: 20.h,),
                    Container(
                      width: double.infinity,
                      height: 52.h,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 36.w,right: 36.w),
                      decoration: BoxDecoration(
                        color: const Color(0xffE9BD96),
                        borderRadius: BorderRadius.circular(16.w)
                      ),
                      child: TextField(
                        enabled: true,
                        maxLength: 20,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xff774607),
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          isCollapsed: true,
                          hintText: 'Please input your account',
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xffAD815A),
                          ),
                          border: InputBorder.none,
                        ),
                        onChanged: (v){
                          content=v;
                        },
                      ),
                    ),
                    SizedBox(height: 16.h,),
                    InkWell(
                      onTap: (){
                        _clickCash();
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          QtImage("btn",w: 220.w,h: 56.h,),
                          QtText("Withdraw Now", fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.w500,),
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

  _clickCash(){
    if(content.isEmpty){
      return;
    }
    "Congratulations on your successful withdrawal. Your money has arrived.".toast();
    closeDialog();
    call.call(content);
  }
}