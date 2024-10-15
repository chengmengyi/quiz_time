import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:time_a/hep/pro_hep.dart';
import 'package:time_a/home/finger_w.dart';
import 'package:time_base/hep/heppppp.dart';
import 'package:time_base/quiz_language/local_text.dart';
import 'package:time_base/w/qt_image.dart';
import 'package:time_base/w/ws_text.dart';

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
                  // TTTTHep.instance.pointEvent(PointName.box_guide_c);
                  ProHep.instance.hideOverlay();
                  dismissOver.call();
                },
                child: Stack(
                  children: [
                    Lottie.asset("qtf/f4/doudong_box.json",width: 32.w,height: 32.w),
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
                              LocalText.pass2Questions.tr,
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