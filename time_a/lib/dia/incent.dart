import 'package:flutter/material.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:time_a/hep/ad/show_ad_hep.dart';
import 'package:time_a/hep/info_hep.dart';
import 'package:time_a/hep/sql/sql_hep_a.dart';
import 'package:time_base/hep/heppppp.dart';
import 'package:time_base/hep/tttt/ad_pppp.dart';
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
                  QtImage("moneya2", w: 160.w, h: 160.w),
                ],
              ),
              QtText(
                "+${formatCoins(add)}",
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
                          "${LocalText.claim.tr} ${formatCoins(add.tox2())}",
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
                  "+${formatCoins(add)}",
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
    var start = await SqlHepA.instance.checkStartCashTask();
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
    var start = await SqlHepA.instance.checkStartCashTask();
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