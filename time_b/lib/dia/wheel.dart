import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_b/hep/ad/show_ad_hep.dart';
import 'package:time_b/hep/sql/sql_hep_b.dart';
import 'package:time_b/hep/value_hep.dart';
import 'package:time_base/hep/heppppp.dart';
import 'package:time_base/hep/tttt/ad_pppp.dart';
import 'package:time_base/hep/tttt/point_name.dart';
import 'package:time_base/hep/tttt/tttt_hep.dart';
import 'package:time_base/quiz_language/local_text.dart';
import 'package:time_base/w/qt_image.dart';
import 'package:time_base/w/ws_text.dart';

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
    TTTTHep.instance.pointEvent(PointName.wheel_pop,params: {"source_from":_getSourceFrom()});
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
                LocalText.usersHaveSuccessfullyWithdrawnMoney.tr,
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
    var wheelAddNum = ValueHepB.instance.getWheelAddNum();
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
    Future.delayed(const Duration(milliseconds: 800),()async{
      _wheelTimer=null;
      switch(widget.wheelFrom){
        case WheelFrom.oldUser:
          ShowAdHep.instance.showAd(
            adType: AdType.inter,
            adPPPP: AdPPPP.kztym_int_spin_step,
            hiddenAd: (){
              closeDialog();
              widget.dismissDialog.call(wheelAddNum.toDouble());
            },
            showFail: (){
              closeDialog();
              widget.dismissDialog.call(wheelAddNum.toDouble());
            },
          );
          break;
        case WheelFrom.answer8Guide:
          closeDialog();
          widget.dismissDialog.call(wheelAddNum.toDouble());
          break;
        case WheelFrom.progress:
          var start = await SqlHepB.instance.checkStartCashTask();
          ShowAdHep.instance.showAd(
            adType: AdType.inter,
            adPPPP: start?AdPPPP.kztym_int_task_spin_go:AdPPPP.kztym_int_spin_go,
            hiddenAd: (){
              closeDialog();
              widget.dismissDialog.call(wheelAddNum.toDouble());
            },
            showFail: (){
              closeDialog();
              widget.dismissDialog.call(wheelAddNum.toDouble());
            },
          );
          break;
      }
    });
  }

  _clickClose(BuildContext context)async{
    _wheelTimer?.cancel();
    _wheelTimer=null;
    if(widget.wheelFrom==WheelFrom.answer8Guide){
      closeDialog();
      widget.dismissDialog.call(ValueHepB.instance.getWheelAddNum().toDouble());
      return;
    }
    var start = await SqlHepB.instance.checkStartCashTask();
    ShowAdHep.instance.showAd(
      adType: AdType.inter,
      adPPPP: start?AdPPPP.kztym_int_task_close_spin:AdPPPP.kztym_int_close_spin,
      hiddenAd: (){
        Navigator.pop(context);
      },
      showFail: (){
        Navigator.pop(context);
      },
    );
  }

  String _getSourceFrom(){
    switch(widget.wheelFrom){
      case WheelFrom.answer8Guide: return "guide";
      case WheelFrom.progress: return "quiz";
      case WheelFrom.oldUser: return "old";
    }
  }

  @override
  void dispose() {
    _wheelTimer?.cancel();
    _wheelTimer=null;
    super.dispose();
  }
}