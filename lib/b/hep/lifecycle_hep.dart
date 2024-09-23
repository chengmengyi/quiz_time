import 'dart:async';
import 'package:flutter_app_lifecycle/app_state_observer.dart';
import 'package:flutter_app_lifecycle/flutter_app_lifecycle.dart';
import 'package:adjust_sdk/adjust.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:quiztime55/b/hep/ad/ad_pppp.dart';
import 'package:quiztime55/b/hep/ad/show_ad_hep.dart';
import 'package:quiztime55/b/hep/notifi/notifi_hep.dart';
import 'package:quiztime55/b/hep/tttt/tttt_hep.dart';

class LifecycleHep {
  factory LifecycleHep()=>_getInstance();
  static LifecycleHep get instance=>_getInstance();
  static LifecycleHep? _instance;
  static LifecycleHep _getInstance(){
    _instance??=LifecycleHep._internal();
    return _instance!;
  }

  LifecycleHep._internal();

  var appBackground=false;
  Timer? _backTimer;

  initListener(){
    FlutterAppLifecycle.instance.setCallObserver(
      AppStateObserver(call: (background){
        if(background){
          Adjust.onPause();
          _backTimer=Timer(const Duration(milliseconds: 3000), (){
            appBackground=true;
          });
        }else{
          Adjust.onResume();
          _backTimer?.cancel();
          TTTTHep.instance.sessionEvent();
          Future.delayed(const Duration(milliseconds: 100),(){
            NotifiHep.instance.checkOpenPermission();
            if(FlutterMaxAd.instance.fullAdShowing()){
              appBackground=false;
            }else{
              if(appBackground){
                if(FlutterMaxAd.instance.checkHasCache(AdType.inter)){
                  ShowAdHep.instance.showOpenAd(
                    adType: AdType.inter,
                    adPPPP: AdPPPP.kztym_launch,
                    hiddenAd: (){

                    },
                    showFail: (){

                    },
                  );
                }
              }
              appBackground=false;
            }
          });
        }
      })
    );
  }


}