import 'package:flutter/material.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiztime55/pro/pro_pro.dart';
import 'package:time_a/hep/ad/show_ad_hep.dart';
import 'package:time_a/home/home.dart';
import 'package:time_b/home/home.dart';
import 'package:time_base/hep/heppppp.dart';
import 'package:time_base/hep/tttt/ad_pppp.dart';
import 'package:time_base/w/qt_image.dart';
import 'package:time_base/w/ws_text.dart';

class ProP extends StatelessWidget {
  const ProP({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          const QtImage("heerw", w: double.infinity, h: double.infinity),
          Positioned(
            top: 130.w,
            child: QtImage("fwgaw", w: 132.w, h: 132.w),
          ),
          Positioned(
            top: 265.w,
            child: QtText("QuizTime", fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.w400),
          ),
          Positioned(
            bottom: 125.w,
            child: ProPro(() {
              _progressFinish(context);
              // Navigator.pushReplacement(context, getMaterialRoute(const HomeP()));
              // Navigator.pushReplacement(context, getMaterialRoute(Home()));
            }),
          ),
        ],
      ),
    );
  }

  _progressFinish(BuildContext context){
    var checkType = FlutterCheckAdjustCloak.instance.checkType();
    if(FlutterMaxAd.instance.checkHasCache(AdType.inter)){
      ShowAdHep.instance.showOpenAd(
        adType: AdType.inter,
        adPPPP: AdPPPP.kztym_launch,
        hiddenAd: (){
          _toHome(context,checkType);
        },
        showFail: (){
          _toHome(context,checkType);
        },
      );
    }else{
      _toHome(context,checkType);
    }
  }

  _toHome(BuildContext context,bool checkType){
    // Navigator.pushReplacement(context, getMaterialRoute(QuizHomeA()));
    Navigator.pushReplacement(context, getMaterialRoute(checkType?QuizHomeB():QuizHomeA()));
  }
}
