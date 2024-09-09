import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiztime55/b/hep/heppppp.dart';
import 'package:quiztime55/b/hep/info_hep.dart';
import 'package:quiztime55/global/widg/qt_image.dart';
import 'package:quiztime55/global/widg/ws_text.dart';

class Incent extends StatelessWidget{
  double add;
  Function() dismissCall;

  Incent({required this.add,required this.dismissCall});

  @override
  Widget build(BuildContext context)=>WillPopScope(
    child: Material(
      type: MaterialType.transparency,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QtText(
              "Congratulation",
              fontSize: 32.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              shadows: [Shadow(color: const Color(0xFFCA780A), blurRadius: 1.w, offset: Offset(0, 2.w))],
            ),
            SizedBox(height: 16.h,),
            QtImage("money1", w: 160.w, h: 160.w),
            QtText(
              "+\$$add",
              fontSize: 32.sp,
              color: const Color(0xffFFBB19),
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 16.h,),
            QtText(
              "Open 10 gift boxes and get an extra \$100",
              fontSize: 12.sp,
              color: const Color(0xffBBBBBB),
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 16.h,),
            InkWell(
              onTap: (){
                _clickBtn(true,context);
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  QtImage("btn", w: 220.w, h: 56.w),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      QtImage("video", w: 24.w, h: 24.w),
                      SizedBox(width: 8.w,),
                      QtText(
                        "Claim \$${add.tox2()}",
                        fontSize: 18.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 16.h,),
            InkWell(
              onTap: (){
                _clickBtn(false,context);
              },
              child: QtText(
                "+\$$add",
                fontSize: 14.sp,
                color: const Color(0xffFFBB19),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ),
    onWillPop: ()async{
      return false;
    },
  );

  _clickBtn(bool d,context){
    if(d){
      InfoHep.instance.addCoins(add.tox2());
    }else{
      InfoHep.instance.addCoins(add);
    }
    Navigator.pop(context);
    dismissCall.call();
  }
}