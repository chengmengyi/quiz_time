import 'package:flutter_max_ad/ad/ad_type.dart';

class AdHep{
  factory AdHep()=>_getInstance();
  static AdHep get instance=>_getInstance();
  static AdHep? _instance;
  static AdHep _getInstance(){
    _instance??=AdHep._internal();
    return _instance!;
  }

  AdHep._internal();

  showAd({
    required AdType adType,
    required Function() hiddenAd,
    required Function() showFail,
  }){
    hiddenAd.call();
  }
}