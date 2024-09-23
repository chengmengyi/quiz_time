import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiztime55/b/hep/heppppp.dart';
import 'package:quiztime55/global/widg/qt_image.dart';
import 'package:quiztime55/global/widg/ws_text.dart';

class CommentSuccessDialog extends StatelessWidget{
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
              QtImage("jowmo",w: double.infinity,h: 284.h,),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  QtImage("moim",w: 120.w,h: 120.h,),
                  SizedBox(height: 20.h,),
                  QtText("Thanks for your feedback", fontSize: 16.sp, color: const Color(0xffA36B21), fontWeight: FontWeight.w600,),
                  SizedBox(height: 16.h,),
                  InkWell(
                    onTap: (){
                      closeDialog();
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        QtImage("btn",w: 220.w,h: 56.h,),
                        QtText("OK", fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.w500,),
                      ],
                    ),
                  )
                ],
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
}