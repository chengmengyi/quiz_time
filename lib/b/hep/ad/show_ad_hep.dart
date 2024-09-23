import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:quiztime55/b/hep/ad/ad_pppp.dart';
import 'package:quiztime55/b/hep/heppppp.dart';
import 'package:quiztime55/b/hep/info_hep.dart';
import 'package:quiztime55/b/hep/tttt/point_name.dart';
import 'package:quiztime55/b/hep/tttt/tttt_hep.dart';
import 'package:quiztime55/b/hep/value_hep.dart';

class ShowAdHep{
  factory ShowAdHep()=>_getInstance();
  static ShowAdHep get instance=>_getInstance();
  static ShowAdHep? _instance;
  static ShowAdHep _getInstance(){
    _instance??=ShowAdHep._internal();
    return _instance!;
  }

  ShowAdHep._internal();

  showAd({
    required AdType adType,
    required AdPPPP adPPPP,
    required Function() hiddenAd,
    required Function() showFail,
  }){
    var hasCache = FlutterMaxAd.instance.checkHasCache(adType);
    if(!hasCache){
      FlutterMaxAd.instance.loadAdByType(adType);
      if(adType==AdType.inter){
        hiddenAd.call();
        return;
      }
    }
    var canShowAd = ValueHep.instance.canShowAdByType(adType);
    if(!canShowAd){
      hiddenAd.call();
      return;
    }
    if(hasCache){
      TTTTHep.instance.pointEvent(PointName.kztym_ad_chance,params: {"ad_pos_id":adPPPP.name});
      FlutterMaxAd.instance.showAd(
        adType: adType,
        adShowListener: AdShowListener(
          showAdSuccess: (ad,info){
            InfoHep.instance.updateWatchAdNum();
            TTTTHep.instance.adEvent(ad, info, adPPPP, adType);
            TTTTHep.instance.pointEvent(PointName.kztym_ad_impression,params: {"ad_pos_id":adPPPP.name});
          },
          onAdHidden: (ad){
            hiddenAd.call();
          },
          showAdFail: (ad,error){
            showFail.call();
          }
        ),
      );
      return;
    }
    "Ad loading failed, please try again later".toast();
    showFail.call();
  }

  showOpenAd({
    required AdType adType,
    required AdPPPP adPPPP,
    required Function() hiddenAd,
    required Function() showFail,
  }){
    var hasCache = FlutterMaxAd.instance.checkHasCache(adType);
    if(!hasCache){
      FlutterMaxAd.instance.loadAdByType(adType);
      hiddenAd.call();
    }else{
      TTTTHep.instance.pointEvent(PointName.kztym_ad_chance,params: {"ad_pos_id":adPPPP.name});
      FlutterMaxAd.instance.showAd(
        adType: adType,
        adShowListener: AdShowListener(
            showAdSuccess: (ad,info){
              InfoHep.instance.updateWatchAdNum();
              TTTTHep.instance.adEvent(ad, info, adPPPP, adType);
              TTTTHep.instance.pointEvent(PointName.kztym_ad_impression,params: {"ad_pos_id":adPPPP.name});
            },
            onAdHidden: (ad){
              hiddenAd.call();
            },
            showAdFail: (ad,error){
              showFail.call();
            }
        ),
      );
    }
  }
}