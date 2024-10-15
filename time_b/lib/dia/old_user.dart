import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_base/hep/heppppp.dart';
import 'package:time_base/hep/tttt/point_name.dart';
import 'package:time_base/hep/tttt/tttt_hep.dart';
import 'package:time_base/quiz_language/local_text.dart';
import 'package:time_base/w/qt_image.dart';
import 'package:time_base/w/ws_text.dart';


class OldUser extends StatelessWidget{
  Function(bool spin) dismissDialog;
  OldUser({required this.dismissDialog});

  @override
  Widget build(BuildContext context)=>WillPopScope(
    child: Material(
      type: MaterialType.transparency,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20.w,right: 20.w),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  QtImage("fioef",w: double.infinity,h: 380.h,),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 20.h,),
                      QtText(
                        LocalText.dailyBonus.tr,
                        fontSize: 24.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 36.h,),
                      QtImage("hrthrth",w: 120.w,h: 120.h,),
                      SizedBox(height: 12.h,),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 24.w,right: 24.w),
                        child: QtText(LocalText.spinTheWheelDailyForPrize.tr, fontSize: 14.sp, color: const Color(0xffA36B21), fontWeight: FontWeight.w400,),
                      ),
                      SizedBox(height: 12.h,),
                      InkWell(
                        onTap: (){
                          TTTTHep.instance.pointEvent(PointName.old_user_pop_c);
                          Navigator.pop(context);
                          dismissDialog.call(true);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            QtImage("btn",w: 220.w,h: 56.h,),
                            QtText(LocalText.spin.tr, fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.w500,),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 20.h,),
            InkWell(
              onTap: (){
                Navigator.pop(context);
                dismissDialog.call(false);
              },
              child: QtImage("close2",w: 40.w,h: 40.w,),
            )
          ],
        ),
      ),
    ),
    onWillPop: ()async{
      return false;
    },
  );
}