import 'package:flutter/material.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_b/hep/ad/show_ad_hep.dart';
import 'package:time_b/hep/info_hep.dart';
import 'package:time_b/hep/value_hep.dart';
import 'package:time_base/hep/heppppp.dart';
import 'package:time_base/hep/tttt/ad_pppp.dart';
import 'package:time_base/hep/tttt/point_name.dart';
import 'package:time_base/hep/tttt/tttt_hep.dart';
import 'package:time_base/quiz_language/local_text.dart';
import 'package:time_base/w/qt_image.dart';
import 'package:time_base/w/ws_text.dart';


class SignIncent extends StatelessWidget{
  double signSAddNum=ValueHepB.instance.getSignCoins();
  Function() dismissDialog;
  SignIncent({required this.dismissDialog});

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
                      SizedBox(height: 20.h,),
                      _wheelSignWidget(),
                      SizedBox(height: 12.h,),
                      _douBtnWidget(),
                      SizedBox(height: 12.h,),
                      _claimBtnWidget(context),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 20.h,),
            InkWell(
              onTap: (){
                closeDialog();
                dismissDialog.call();
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

  _wheelSignWidget()=>Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      QtImage("dnovndnv",w: 100.w,h: 100.h,),
      QtText(LocalText.dailyCheckReward.tr, fontSize: 10.sp, color: const Color(0xffA36B21), fontWeight: FontWeight.w400),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          QtImage("money1",w: 24.w,h: 24.w,),
          QtText("+${moneyDou2Str(signSAddNum)}", fontSize: 18.sp, color: const Color(0xffF26805), fontWeight: FontWeight.w500)
        ],
      )
    ],
  );

  _douBtnWidget()=>InkWell(
    onTap: (){
      TTTTHep.instance.pointEvent(PointName.daily_pop_c,params: {"source_from":"check"});
      _clickDou();
    },
    child: Stack(
      alignment: Alignment.center,
      children: [
        QtImage("btn",w: 240.w,h: 56.h,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            QtImage("video",w: 24.w,h: 24.w,),
            SizedBox(width: 10.w,),
            QtText(LocalText.doubleClaim.tr, fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.w500)
          ],
        )
      ],
    ),
  );

  _claimBtnWidget(BuildContext context)=>InkWell(
    onTap: (){
      _clickClaim();
    },
    child: QtText(LocalText.claim.tr, fontSize: 18.sp, color: const Color(0xffD9831E), fontWeight: FontWeight.w500),
  );

  _clickDou(){
    var add = signSAddNum.tox2();
    ShowAdHep.instance.showAd(
      adType: AdType.reward,
      adPPPP: AdPPPP.kztym_rv_double_only,
      hiddenAd: (){
        closeDialog();
        InfoHep.instance.addCoins(add);
        dismissDialog.call();
      },
      showFail: (){
        closeDialog();
        InfoHep.instance.addCoins(add);
        dismissDialog.call();
      },
    );
  }

  _clickClaim(){
    closeDialog();
    InfoHep.instance.addCoins(signSAddNum);
    dismissDialog.call();
  }
}