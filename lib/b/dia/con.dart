import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiztime55/global/widg/qt_image.dart';
import 'package:quiztime55/global/widg/ws_text.dart';

class Con extends StatelessWidget{
  double add;
  Con({required this.add});

  @override
  Widget build(BuildContext context){
    Future.delayed(const Duration(milliseconds: 1500),(){
      Navigator.pop(context);
    });
    return WillPopScope(
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 20.w,right: 20.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.w),
                color: Colors.black.withOpacity(0.8)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 24.h,),
                QtText(
                  "Congratulation!",
                  fontSize: 24.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  shadows: [Shadow(color: const Color(0xFFCA780A), blurRadius: 1.w, offset: Offset(0, 2.w))],
                ),
                SizedBox(height: 24.h,),
                QtImage("money1", w: 160.w, h: 160.w),
                SizedBox(height: 24.h,),
                QtText(
                  "+\$${add}",
                  fontSize: 32.sp,
                  color: const Color(0xffFFBB19),
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 24.h,),
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
}