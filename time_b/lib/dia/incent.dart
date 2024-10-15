import 'package:flutter/material.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:time_b/hep/ad/show_ad_hep.dart';
import 'package:time_b/hep/info_hep.dart';
import 'package:time_b/hep/sql/sql_hep_b.dart';
import 'package:time_base/hep/heppppp.dart';
import 'package:time_base/hep/tttt/ad_pppp.dart';
import 'package:time_base/hep/tttt/point_name.dart';
import 'package:time_base/hep/tttt/tttt_hep.dart';
import 'package:time_base/quiz_language/local_text.dart';
import 'package:time_base/w/qt_image.dart';
import 'package:time_base/w/ws_text.dart';


enum IncentFrom{
  answerRight,box,wheel
}

class Incent extends StatelessWidget{
  double add;
  IncentFrom incentFrom;
  Function() dismissCall;

  Incent({required this.add,required this.incentFrom,required this.dismissCall});

  @override
  Widget build(BuildContext context){
    TTTTHep.instance.pointEvent(PointName.coin_pop,params: {"source_from":_getSourceFrom()});
    return WillPopScope(
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QtText(
                LocalText.congratulation.tr,
                fontSize: 32.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                shadows: [Shadow(color: const Color(0xFFCA780A), blurRadius: 1.w, offset: Offset(0, 2.w))],
              ),
              SizedBox(height: 16.h,),
              Stack(
                alignment: Alignment.center,
                children: [
                  Lottie.asset("qtf/f4/xuanguang.json",width: 200.w,height: 200.w),
                  QtImage("money1", w: 160.w, h: 160.w),
                ],
              ),
              QtText(
                "+${moneyDou2Str(add)}",
                fontSize: 32.sp,
                color: const Color(0xffFFBB19),
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 16.h,),
              QtText(
                LocalText.open10GiftBoxesAndGetAnExtra100.tr,
                fontSize: 12.sp,
                color: const Color(0xffBBBBBB),
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 16.h,),
              InkWell(
                onTap: ()async{
                  TTTTHep.instance.pointEvent(PointName.coin_pop_c,params: {"source_from":_getSourceFrom()});
                  var adPPPP = await _getRewardAdPPP();
                  ShowAdHep.instance.showAd(
                    adType: AdType.reward,
                    adPPPP: adPPPP,
                    hiddenAd: (){
                      _clickBtn(true,context);
                    },
                    showFail: (){

                    },
                  );
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
                          "${LocalText.claim.tr} ${moneyDou2Str(add.tox2())}",
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
                onTap: ()async{
                  TTTTHep.instance.pointEvent(PointName.coin_pop_close,params: {"source_from":_getSourceFrom()});
                  var adPPPP = await _getIntAdPPP();
                  ShowAdHep.instance.showAd(
                    adType: AdType.inter,
                    adPPPP: adPPPP,
                    hiddenAd: (){
                      _clickBtn(false,context);
                    },
                    showFail: (){
                      _clickBtn(false,context);
                    },
                  );
                },
                child: QtText(
                  "+${moneyDou2Str(add)}",
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
  }

  _clickBtn(bool d,context){
    closeDialog();
    dismissCall.call();
    if(d){
      InfoHep.instance.addCoins(add.tox2());
    }else{
      InfoHep.instance.addCoins(add);
    }
  }

  Future<AdPPPP> _getRewardAdPPP()async{
    var start = await SqlHepB.instance.checkStartCashTask();
    if(start){
      switch(incentFrom){
        case IncentFrom.answerRight:return AdPPPP.kztym_rv_task_answer;
        case IncentFrom.box:return AdPPPP.kztym_rv_task_box;
        case IncentFrom.wheel:return AdPPPP.kztym_rv_task_claim_spin;
      }
    }else{
      switch(incentFrom){
        case IncentFrom.answerRight:return AdPPPP.kztym_rv_claim_answer;
        case IncentFrom.box:return AdPPPP.kztym_rv_open_box;
        case IncentFrom.wheel:return AdPPPP.kztym_rv_claim_spin;
      }
    }
  }

  Future<AdPPPP> _getIntAdPPP()async{
    var start = await SqlHepB.instance.checkStartCashTask();
    if(start){
      switch(incentFrom){
        case IncentFrom.answerRight:return AdPPPP.kztym_int_task_answer_close;
        case IncentFrom.box:return AdPPPP.kztym_rv_task_box_close;
        case IncentFrom.wheel:return AdPPPP.kztym_int_task_claim_spin;
      }
    }else{
      switch(incentFrom){
        case IncentFrom.answerRight:return AdPPPP.kztym_int_answer_continue;
        case IncentFrom.box:return AdPPPP.kztym_int_box_continue;
        case IncentFrom.wheel:return AdPPPP.kztym_int_claim_spin;
      }
    }
  }

  String _getSourceFrom(){
    switch(incentFrom){
      case IncentFrom.answerRight: return "quiz";
      case IncentFrom.wheel: return "wheel";
      case IncentFrom.box: return "box";
    }
  }
}