import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:quiztime55/b/hep/pro_hep.dart';
import 'package:quiztime55/b/hep/tttt/point_name.dart';
import 'package:quiztime55/b/hep/tttt/tttt_hep.dart';
import 'package:quiztime55/b/home/finger_w.dart';
import 'package:quiztime55/global/widg/qt_image.dart';
import 'package:quiztime55/global/widg/ws_text.dart';

class ProgressWheelOver extends StatelessWidget{
  Offset offset;
  Function() dismissOver;

  ProgressWheelOver({required this.offset,required this.dismissOver});

  @override
  Widget build(BuildContext context)=>Material(
    type: MaterialType.transparency,
    child: InkWell(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withOpacity(0.8),
        child: Stack(
          children: [
            Positioned(
              top: offset.dy+18.h,
              left: offset.dx+9.w,
              child: InkWell(
                onTap: (){
                  TTTTHep.instance.pointEvent(PointName.wheel_guide_c);
                  ProHep.instance.hideOverlay();
                  dismissOver.call();
                },
                child: Stack(
                  children: [
                    Lottie.asset("qtf/f4/doudong_wheel.json",width: 32.w,height: 32.w),
                    Container(
                      margin: EdgeInsets.only(top: 62.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Container(
                          //   margin: EdgeInsets.only(left: 10.w),
                          //   child: Transform.rotate(
                          //     angle: 90*(pi/180.0),
                          //     child: QtImage("hiuwhof",w: 4.w,h: 8.h,),
                          //   ),
                          // ),
                          Container(
                            width: 176.w,
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.w),
                            ),
                            child: QtText(
                              "Pass 8 questions to get a lucky spin!",
                              fontSize: 12.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 8.w,top: 20.h),
                      child: FingerW(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );

}