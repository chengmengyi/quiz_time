import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiztime55/b/hep/ad_hep.dart';
import 'package:quiztime55/b/hep/heppppp.dart';
import 'package:quiztime55/b/hep/info_hep.dart';
import 'package:quiztime55/b/hep/value_hep.dart';
import 'package:quiztime55/global/widg/qt_image.dart';
import 'package:quiztime55/global/widg/ws_text.dart';

enum WheelFrom{
  oldUser,answer8Guide,progress,
}

class WheelDialog extends StatefulWidget{
  WheelFrom wheelFrom;
  Function(double addNum) dismissDialog;
  WheelDialog({required this.wheelFrom,required this.dismissDialog});

  @override
  State<StatefulWidget> createState() => _WheelState();
}

class _WheelState extends  State<WheelDialog>{
  var _wheelAngle=0.0;
  Timer? _wheelTimer;

  @override
  void initState() {
    super.initState();
    if(widget.wheelFrom==WheelFrom.oldUser){
      Future((){
        _startWheel();
      });
    }
  }

  @override
  Widget build(BuildContext context)=>WillPopScope(
    child: Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          margin: EdgeInsets.only(left: 10.w,right: 10.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: (){
                      _clickClose(context);
                    },
                    child: QtImage("close",w: 40.w,h: 40.w,),
                  )
                ],
              ),
              SizedBox(height: 28.h,),
              QtImage("mjiomko",h: 52.h,),
              SizedBox(height: 12.h,),
              QtText(
                "20000 Users Have Successfully Withdrawn Money",
                fontSize: 12.sp,
                color: const Color(0xffBBBBBB),
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 28.h,),
              _wheelWidget(),
            ],
          ),
        ),
      ),
    ),
    onWillPop: ()async{
      return false;
    },
  );

  _wheelWidget()=>Stack(
    alignment: Alignment.center,
    children: [
      Transform.rotate(
        angle: _wheelAngle*(pi/180.0),
        child: QtImage("fjewjo",w: 320.w,h: 320.w,),
      ),
      InkWell(
        onTap: (){
          _startWheel();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            QtImage("jofwmo",w: 124.w,h: 124.w,),
            QtImage("dwdwdc",w: 60.w,h: 40.w,),
          ],
        ),
      ),
    ],
  );

  _startWheel(){
    if(null!=_wheelTimer){
      return;
    }
    setState(() {
      _wheelAngle=0.0;
    });
    var wheelAddNum = ValueHep.instance.getWheelAddNum();
    int randomAngel=180;
    switch(wheelAddNum){
      case 5:
        randomAngel=[135,225].getRandom();
        break;
      case 10:
        randomAngel=315;
        break;
      case 20:
        randomAngel=90;
        break;
      case 50:
        randomAngel=45;
        break;
      case 80:
        randomAngel=[180,270].getRandom();
        break;
    }
    var totalAngel=360*(Random().nextInt(3)+1)+randomAngel;
    _wheelTimer=Timer.periodic(const Duration(milliseconds: 1), (t){
      setState(() {
        _wheelAngle++;
      });
      if(_wheelAngle>=totalAngel){
        _stopWheel(wheelAddNum);
      }
    });
  }

  _stopWheel(int wheelAddNum){
    _wheelTimer?.cancel();
    Future.delayed(const Duration(milliseconds: 800),(){
      _wheelTimer=null;
      switch(widget.wheelFrom){
        case WheelFrom.oldUser:
          AdHep.instance.showAd(
            adType: AdType.inter,
            hiddenAd: (){
              closeDialog();
              InfoHep.instance.addCoins(wheelAddNum.toDouble());
              widget.dismissDialog.call(wheelAddNum.toDouble());
            },
            showFail: (){
              closeDialog();
              InfoHep.instance.addCoins(wheelAddNum.toDouble());
              widget.dismissDialog.call(wheelAddNum.toDouble());
            },
          );
          break;
        case WheelFrom.answer8Guide:
          closeDialog();
          InfoHep.instance.addCoins(wheelAddNum.toDouble());
          widget.dismissDialog.call(wheelAddNum.toDouble());
          break;
        case WheelFrom.progress:
          AdHep.instance.showAd(
            adType: AdType.inter,
            hiddenAd: (){
              closeDialog();
              InfoHep.instance.addCoins(wheelAddNum.toDouble());
              widget.dismissDialog.call(wheelAddNum.toDouble());
            },
            showFail: (){
              closeDialog();
            },
          );
          break;
      }
    });
  }

  _clickClose(BuildContext context){
    _wheelTimer?.cancel();
    _wheelTimer=null;
    AdHep.instance.showAd(
      adType: AdType.inter,
      hiddenAd: (){
        Navigator.pop(context);
      },
      showFail: (){
        Navigator.pop(context);
      },
    );
  }

  @override
  void dispose() {
    _wheelTimer?.cancel();
    _wheelTimer=null;
    super.dispose();
  }
}