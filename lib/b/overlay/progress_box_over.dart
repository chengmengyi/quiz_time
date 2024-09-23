import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiztime55/b/hep/pro_hep.dart';
import 'package:quiztime55/b/hep/tttt/point_name.dart';
import 'package:quiztime55/b/hep/tttt/tttt_hep.dart';
import 'package:quiztime55/b/home/finger_w.dart';
import 'package:quiztime55/global/widg/qt_image.dart';
import 'package:quiztime55/global/widg/ws_text.dart';

class ProgressBoxOver extends StatelessWidget{
  Offset offset;
  Function() dismissOver;

  ProgressBoxOver({required this.offset,required this.dismissOver});

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
                  TTTTHep.instance.pointEvent(PointName.box_guide_c);
                  ProHep.instance.hideOverlay();
                  dismissOver.call();
                },
                child: Stack(
                  children: [
                    QtImage("fswfsfew",w: 32.w,h: 32.h,),
                    Container(
                      margin: EdgeInsets.only(left: 40.w),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10.h),
                            child: QtImage("hiuwhof",w: 4.w,h: 8.h,),
                          ),
                          Container(
                            width: 176.w,
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.w),
                            ),
                            child: QtText(
                              "Pass 2 questions to get a treasure chest reward",
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