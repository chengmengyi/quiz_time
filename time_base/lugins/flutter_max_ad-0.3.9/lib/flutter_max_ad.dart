import 'dart:convert';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_ad_revenue.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:anythink_sdk/at_index.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_max_ad/ad/ad_bean/max_ad_bean.dart';
import 'package:flutter_max_ad/ad/ad_num_utils.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/load_ad_listener.dart';
import 'package:flutter_max_ad/ad/load/load_ad_utils.dart';
import 'package:flutter_max_ad/ad/load/load_ad_utils2.dart';
import 'package:tradplus_sdk/tradplus_sdk.dart';


class FlutterMaxAd {
  static final FlutterMaxAd _instance = FlutterMaxAd();

  static FlutterMaxAd get instance => _instance;

  var _maxInit=false,_fullAdShowing=false,_initFaceBookResult=false,tradplusInitSuccess=false;
  AdShowListener? _adShowListener;
  // LoadAdListener? _loadAdListener;
  final _facebookAppEvents = FacebookAppEvents();



  // I/anythink_network(21203): {"placementId":"b67a454ff84829","adtype":"reward","api":"result_callback","result":"fail","reason":"returned no eligible ads from any mediated networks. [listener:com.anythink.rewardvideo.api.ATRewardVideoAd$2@e2f575f]"}
  // E/ATFlutterBridge(21203): onRewardedVideoAdFailed: b67a454ff84829,
  // E/ATFlutterBridge(21203): code[ 4001 ]
  // E/ATFlutterBridge(21203): desc[ Return Ad is empty. ]
  // E/ATFlutterBridge(21203): detail[
  // E/ATFlutterBridge(21203):   { ad_source_id[ 7614077 ];network_firm_id[ 102441 ];network_name=[  ];network_error:[ code:[ 4001 ]desc:[ Return Ad is empty. ]platformCode:[  ]platformMSG:[ This network don't support head bidding in current TopOn's version. ] ] }
  // E/ATFlutterBridge(21203): ]
  // I/flutter (21203): qwer====>rewardedVideoEventHandler===>RewardedStatus.rewardedVideoDidFailToLoad

  inittest(){
    print("kkkkk");
    ATInitManger.setLogEnabled(logEnabled: true);
    ATInitManger.initAnyThinkSDK(appidStr: "a6708e000721b4", appidkeyStr: "a477ac1dbf157d91c61670a022ebe4ae7");

    ATListenerManager.rewardedVideoEventHandler.listen((event) {
      print("qwer====>rewardedVideoEventHandler===>${event.rewardStatus}");
    });
  }

  loadtest(){
    print("loadtest");
    ATRewardedManager.loadRewardedVideo(
      placementID: "b67a454ff84829",
      extraMap: {
        ATSplashManager.tolerateTimeout(): 20000
      },
    );
  }

  initMax({
    required String maxKey,
    required String topOnAppId,
    required String topOnAppKey,
    required String tradplusAppId,
    required MaxAdBean maxAdBean,
    bool? logFacebookPurchase,
    List<String>? maxTestDeviceIds,  //android->gaid   ios->idfa
    String? topOnTestDeviceId,  //android->gaid   ios->idfa
    bool? maxOpenDebugger,
  })async{
    setMaxAdInfo(maxAdBean);
    if(null!=maxTestDeviceIds){
      AppLovinMAX.setTestDeviceAdvertisingIds(maxTestDeviceIds);
    }
    _initTopOn(topOnAppId,topOnAppKey,topOnTestDeviceId);
    var maxConfiguration = await AppLovinMAX.initialize(maxKey);
    // _initTradPlus(tradplusAppId);
    if(null!=maxConfiguration){
      _maxInit=true;
      if(kDebugMode&&maxOpenDebugger==true){
        AppLovinMAX.showMediationDebugger();
      }
      _setAdListener();
      loadAdByType(AdType.reward);
      loadAdByType(AdType.inter);
    }
  }

  tradtest(){
    _initTradPlus("8B2A58EAFC96F29CB9DC92B06CD74B4D");
  }

  tradLoad(){
    // TPRewardVideoManager.loadRewardVideoAd("69A39FEEE5309D00BEA47FFE7B7F475C");
    TPInterstitialManager.loadInterstitialAd("A3FB7F4E2DC83B2669C6FC9CE9A23211");
  }

  tradShow(){
    TPInterstitialManager.showInterstitialAd("A3FB7F4E2DC83B2669C6FC9CE9A23211");
  }

  initTopOn(topOnAppId,topOnAppKey){
    _initTopOn(topOnAppId,topOnAppKey,"");
  }

  loadTopon(){
    ATInterstitialManager.loadInterstitialAd(
      placementID: "b6708eb002b870",
      extraMap: {
        ATSplashManager.tolerateTimeout(): 20000
      },
    );
  }
  
  showTopon(){
    ATInterstitialManager.showInterstitialAd(placementID: "b6708eb002b870");
  }

  _initTradPlus(String tradplusAppId){
    TPSDKManager.setInitListener(
        TPInitListener(
            initFinish: (result){
              printDebug("FlutterMaxAd trad init result===>$result");
              tradplusInitSuccess=result;
              loadAdByType(AdType.reward);
              loadAdByType(AdType.inter);
            }
        ));
    TPSDKManager.init(tradplusAppId);
    TPRewardVideoManager.setRewardVideoListener(
        TPRewardVideoAdListener(
          onAdLoaded: (String adUnitId, Map<dynamic, dynamic> adInfo) {
            printDebug("FlutterMaxAd Reward onAdLoaded===>$adInfo");
            LoadAdUtils.instance.loadAdSuccess(adUnitId);
            LoadAdUtils2.instance.loadAdSuccess(adUnitId);
            // _loadAdListener?.loadSuccess.call();
          },
          onAdLoadFailed: (String adUnitId, Map<dynamic, dynamic> error) {
            printDebug("FlutterMaxAd Reward onAdLoadFailed===>$error");
            LoadAdUtils.instance.loadAdFail(adUnitId);
            LoadAdUtils2.instance.loadAdFail(adUnitId);
          },
          onAdImpression: (String adUnitId, Map<dynamic, dynamic> adInfo) {
            printDebug("FlutterMaxAd show ad success---->$adUnitId");
            _fullAdShowing=true;
            _removeMaxAd(adUnitId);
            AdNumUtils.instance.updateShowNum();
            var maxAd = _createMaxAdByTradPlusInfo(adUnitId,adInfo);
            _adShowListener?.showAdSuccess?.call(maxAd,_getMaxInfoById(adUnitId));
            if(null!=maxAd){
              _onAdRevenuePaidByAdjust(maxAd);
            }
          },
          onAdShowFailed: (String adUnitId, Map<dynamic, dynamic> adInfo, Map<dynamic, dynamic> error) {
            printDebug("FlutterMaxAd show ad fail---->$adUnitId---");
            _fullAdShowing=false;
            _removeMaxAd(adUnitId);
            _adShowListener?.showAdFail?.call(_createMaxAdByTradPlusInfo(adUnitId,adInfo),null);
            loadAdByType(AdType.reward);
          },
          onAdClicked: (String adUnitId, Map<dynamic, dynamic> adInfo) {
            AdNumUtils.instance.updateClickNum();
          },
          onAdClosed: (String adUnitId, Map<dynamic, dynamic> adInfo) {
            _fullAdShowing=false;
            loadAdByType(AdType.reward);
            _adShowListener?.onAdHidden.call(_createMaxAdByTradPlusInfo(adUnitId,adInfo));
          },
          onAdReward: (String adUnitId, Map<dynamic, dynamic> adInfo) {

          },
          oneLayerLoadFailed: (String adUnitId, Map<dynamic, dynamic> adInfo, Map<dynamic, dynamic> error) {

          },
        )
    );
    TPInterstitialManager.setInterstitialListener(
        TPInterstitialAdListener(
          onAdLoaded: (String adUnitId, Map<dynamic, dynamic> adInfo) {
            printDebug("FlutterMaxAd Interstitial onAdLoaded===>$adInfo");
            LoadAdUtils.instance.loadAdSuccess(adUnitId);
            LoadAdUtils2.instance.loadAdSuccess(adUnitId);
          },
          onAdLoadFailed: (String adUnitId, Map<dynamic, dynamic> error) {
            printDebug("FlutterMaxAd Interstitial onAdLoadFailed===>$error");
            LoadAdUtils.instance.loadAdFail(adUnitId);
            LoadAdUtils2.instance.loadAdFail(adUnitId);
          },
          onAdImpression: (String adUnitId, Map<dynamic, dynamic> adInfo) {
            printDebug("FlutterMaxAd show ad success---->$adUnitId");
            _fullAdShowing=true;
            _removeMaxAd(adUnitId);
            AdNumUtils.instance.updateShowNum();
            var maxAd = _createMaxAdByTradPlusInfo(adUnitId,adInfo);
            _adShowListener?.showAdSuccess?.call(maxAd,_getMaxInfoById(adUnitId));
            if(null!=maxAd){
              _onAdRevenuePaidByAdjust(maxAd);
            }

          },
          onAdShowFailed: (String adUnitId, Map<dynamic, dynamic> adInfo, Map<dynamic, dynamic> error) {
            printDebug("FlutterMaxAd show ad fail---->$adUnitId---");
            _fullAdShowing=false;
            _removeMaxAd(adUnitId);
            _adShowListener?.showAdFail?.call(_createMaxAdByTradPlusInfo(adUnitId,adInfo),null);
            loadAdByType(AdType.inter);
          },
          onAdClicked: (String adUnitId, Map<dynamic, dynamic> adInfo) {
            AdNumUtils.instance.updateClickNum();
          },
          onAdClosed: (String adUnitId, Map<dynamic, dynamic> adInfo) {
            _fullAdShowing=false;
            loadAdByType(AdType.inter);
            _adShowListener?.onAdHidden.call(_createMaxAdByTradPlusInfo(adUnitId,adInfo));
          },
          oneLayerLoadFailed: (String adUnitId, Map<dynamic, dynamic> adInfo, Map<dynamic, dynamic> error) {

          },
        )
    );
  }

  _initTopOn(String topOnAppId,String topOnAppKey, String? topOnTestDeviceId){
    try{
      ATInitManger.setLogEnabled(logEnabled: kDebugMode);
      ATInitManger.initAnyThinkSDK(appidStr: topOnAppId, appidkeyStr: topOnAppKey);
      // if(kDebugMode){
      //   ATInitManger.integrationChecking();
      //   if(null!=topOnTestDeviceId){
      //     ATInitManger.setDebuggerConfig(topOnTestDeviceId);
      //   }
      // }
      ATListenerManager.interstitialEventHandler.listen((event) {
        var adUnitId = event.placementID;
        switch (event.interstatus) {
        //广告加载失败
          case InterstitialStatus.interstitialAdFailToLoadAD:
            LoadAdUtils.instance.loadAdFail(adUnitId);
            LoadAdUtils2.instance.loadAdFail(adUnitId);
            break;
        //广告加载成功
          case InterstitialStatus.interstitialAdDidFinishLoading:
            LoadAdUtils.instance.loadAdSuccess(adUnitId);
            LoadAdUtils2.instance.loadAdSuccess(adUnitId);
            // _loadAdListener?.loadSuccess.call(_createMaxAdByTopOnInfo(adUnitId,event.extraMap),_getMaxInfoById(adUnitId));
            break;
        //广告展示成功
          case InterstitialStatus.interstitialDidShowSucceed:
            printDebug("FlutterMaxAd show ad success---->$adUnitId");
            _fullAdShowing=true;
            _removeMaxAd(adUnitId);
            AdNumUtils.instance.updateShowNum();
            var maxAd = _createMaxAdByTopOnInfo(adUnitId,event.extraMap);
            _adShowListener?.showAdSuccess?.call(maxAd,_getMaxInfoById(adUnitId));
            if(null!=maxAd){
              _onAdRevenuePaidByAdjust(maxAd);
            }
            break;
        //广告展示失败
          case InterstitialStatus.interstitialFailedToShow:
            printDebug("FlutterMaxAd show ad fail---->$adUnitId---");
            _fullAdShowing=false;
            _removeMaxAd(adUnitId);
            _adShowListener?.showAdFail?.call(_createMaxAdByTopOnInfo(adUnitId,event.extraMap),null);
            loadAdByType(AdType.reward);
            loadAdByType(AdType.inter);
            break;
        //广告被点击
          case InterstitialStatus.interstitialAdDidClick:
            AdNumUtils.instance.updateClickNum();
            break;
        //广告被关闭
          case InterstitialStatus.interstitialAdDidClose:
            _fullAdShowing=false;
            loadAdByType(AdType.inter);
            _adShowListener?.onAdHidden.call(_createMaxAdByTopOnInfo(adUnitId,event.extraMap));
            break;
          default:

            break;
        }
      });
      ATListenerManager.rewardedVideoEventHandler.listen((event) {
        print("FlutterMaxAd==rewardedVideoEventHandler===${event.requestMessage}===${event.rewardStatus}===${event.extraMap}");
        var adUnitId = event.placementID;
        switch (event.rewardStatus) {
        //广告加载失败
          case RewardedStatus.rewardedVideoDidFailToLoad:
            LoadAdUtils.instance.loadAdFail(adUnitId);
            LoadAdUtils2.instance.loadAdFail(adUnitId);
            break;
        //广告加载成功
          case RewardedStatus.rewardedVideoDidFinishLoading:
            LoadAdUtils.instance.loadAdSuccess(adUnitId);
            LoadAdUtils2.instance.loadAdSuccess(adUnitId);
            // _loadAdListener?.loadSuccess.call(_createMaxAdByTopOnInfo(adUnitId,event.extraMap),_getMaxInfoById(adUnitId));
            break;
        //广告展示成功
          case RewardedStatus.rewardedVideoDidStartPlaying:
            printDebug("FlutterMaxAd show ad success---->$adUnitId");
            _fullAdShowing=true;
            _removeMaxAd(adUnitId);
            AdNumUtils.instance.updateShowNum();
            var maxAd = _createMaxAdByTopOnInfo(adUnitId,event.extraMap);
            _adShowListener?.showAdSuccess?.call(maxAd,_getMaxInfoById(adUnitId));
            if(null!=maxAd){
              _onAdRevenuePaidByAdjust(maxAd);
            }
            break;
        //广告展示失败
          case RewardedStatus.rewardedVideoDidFailToPlay:
            printDebug("FlutterMaxAd show ad fail---->$adUnitId---");
            _fullAdShowing=false;
            _removeMaxAd(adUnitId);
            _adShowListener?.showAdFail?.call(_createMaxAdByTopOnInfo(adUnitId,event.extraMap),null);
            loadAdByType(AdType.reward);
            loadAdByType(AdType.inter);
            break;
        //广告被点击
          case RewardedStatus.rewardedVideoDidClick:
            AdNumUtils.instance.updateClickNum();
            break;
        //广告被关闭
          case RewardedStatus.rewardedVideoDidClose:
            _fullAdShowing=false;
            loadAdByType(AdType.reward);
            _adShowListener?.onAdHidden.call(_createMaxAdByTopOnInfo(adUnitId,event.extraMap));
            break;
          default:

            break;
        }
      });
    }catch(e){
    }
  }

  // setLoadAdListener(LoadAdListener loadAdListener){
  //   _loadAdListener=loadAdListener;
  // }

  loadAdByType(AdType adType)async{
    if(!_maxInit){
      printDebug("FlutterMaxAd not init");
      return;
    }
    if(AdNumUtils.instance.getAdNumLimit()){
      printDebug("FlutterMaxAd show or click num limit");
      return;
    }
    LoadAdUtils.instance.loadAd(adType);
    LoadAdUtils2.instance.loadAd(adType);
  }

  _setAdListener(){
    AppLovinMAX.setRewardedAdListener(
        RewardedAdListener(
          onAdLoadedCallback: (MaxAd ad) {
            LoadAdUtils.instance.loadAdSuccess(ad.adUnitId);
            LoadAdUtils2.instance.loadAdSuccess(ad.adUnitId);
            // _loadAdListener?.loadSuccess.call(ad,_getMaxInfoById(ad.adUnitId));
          },
          onAdLoadFailedCallback: (String adUnitId, MaxError error) {
            LoadAdUtils.instance.loadAdFail(adUnitId);
            LoadAdUtils2.instance.loadAdFail(adUnitId);
          },
          onAdDisplayedCallback: (MaxAd ad) {
            printDebug("FlutterMaxAd show ad success---->${ad.adUnitId}");
            _fullAdShowing=true;
            _removeMaxAd(ad.adUnitId);
            AdNumUtils.instance.updateShowNum();
            _adShowListener?.showAdSuccess?.call(ad,_getMaxInfoById(ad.adUnitId));
          },
          onAdDisplayFailedCallback: (MaxAd ad, MaxError error) {
            printDebug("FlutterMaxAd show ad fail---->${ad.adUnitId}---${error.message}");
            _fullAdShowing=false;
            _removeMaxAd(ad.adUnitId);
            _adShowListener?.showAdFail?.call(ad,error);
            loadAdByType(AdType.reward);
            loadAdByType(AdType.inter);
          },
          onAdClickedCallback: (MaxAd ad) {
            AdNumUtils.instance.updateClickNum();
          },
          onAdHiddenCallback: (MaxAd ad) {
            _fullAdShowing=false;
            loadAdByType(AdType.reward);
            _adShowListener?.onAdHidden.call(ad);
          },
          onAdReceivedRewardCallback: (MaxAd ad, MaxReward reward) {
            _adShowListener?.onAdReceivedReward?.call(ad,reward);
          },
          onAdRevenuePaidCallback: (MaxAd ad){
            _onAdRevenuePaidByAdjust(ad);
          }
        )
    );
    AppLovinMAX.setInterstitialListener(
        InterstitialListener(
          onAdLoadedCallback: (ad) {
            LoadAdUtils.instance.loadAdSuccess(ad.adUnitId);
            LoadAdUtils2.instance.loadAdSuccess(ad.adUnitId);
            // _loadAdListener?.loadSuccess.call(ad,_getMaxInfoById(ad.adUnitId));
          },
          onAdLoadFailedCallback: (adUnitId, error) {
            LoadAdUtils.instance.loadAdFail(adUnitId);
            LoadAdUtils2.instance.loadAdFail(adUnitId);
          },
          onAdDisplayedCallback: (ad) {
            printDebug("FlutterMaxAd show ad success---->${ad.adUnitId}");
            _fullAdShowing=true;
            _removeMaxAd(ad.adUnitId);
            AdNumUtils.instance.updateShowNum();
            _adShowListener?.showAdSuccess?.call(ad,_getMaxInfoById(ad.adUnitId));
          },
          onAdDisplayFailedCallback: (ad, error) {
            printDebug("FlutterMaxAd show ad fail---->${ad.adUnitId}---${error.message}");
            _removeMaxAd(ad.adUnitId);
            _adShowListener?.showAdFail?.call(ad,error);
            loadAdByType(AdType.reward);
            loadAdByType(AdType.inter);
          },
          onAdClickedCallback: (ad) {
            AdNumUtils.instance.updateClickNum();
          },
          onAdHiddenCallback: (ad) {
            _fullAdShowing=false;
            loadAdByType(AdType.inter);
            _adShowListener?.onAdHidden.call(ad);
          },
          onAdRevenuePaidCallback: (MaxAd ad){
            _onAdRevenuePaidByAdjust(ad);
          }
        )
    );
  }

  _removeMaxAd(String? adUnitId){
    LoadAdUtils.instance.removeAdByType(adUnitId);
    LoadAdUtils2.instance.removeAdByType(adUnitId);
  }

  setMaxAdInfo(MaxAdBean maxAdBean){
    printDebug("FlutterMaxAd max ad info--->${maxAdBean.toString()}");
    AdNumUtils.instance.setNumInfo(maxAdBean);
    maxAdBean.firstRewardedAdList.sort((a, b) => (b.sort).compareTo(a.sort));
    maxAdBean.secondRewardedAdList.sort((a, b) => (b.sort).compareTo(a.sort));
    maxAdBean.firstInterAdList.sort((a, b) => (b.sort).compareTo(a.sort));
    maxAdBean.secondInterAdList.sort((a, b) => (b.sort).compareTo(a.sort));
    LoadAdUtils.instance.initAdInfo(maxAdBean);
    LoadAdUtils2.instance.initAdInfo(maxAdBean);
  }
  
  showAd({
    required AdType adType,
    required AdShowListener? adShowListener
  })async{
    _adShowListener=adShowListener;
    if(!_maxInit){
      printDebug("FlutterMaxAd not init");
      _adShowListener?.showAdFail?.call(null,null);
      return;
    }
    if(_fullAdShowing){
      printDebug("FlutterMaxAd show ad fail, has ad showing");
      _adShowListener?.showAdFail?.call(null,null);
      return;
    }
    var resultBean = LoadAdUtils.instance.getAdResultByAdType(adType);
    resultBean ??= LoadAdUtils2.instance.getAdResultByAdType(adType);
    if(null!=resultBean){
      printDebug("FlutterMaxAd --->start show ad $adType");
      switch(adType){
        case AdType.reward:
          if(resultBean.maxAdInfoBean.plat=="max"){
            if(await AppLovinMAX.isRewardedAdReady(resultBean.maxAdInfoBean.id)==true){
              AppLovinMAX.showRewardedAd(resultBean.maxAdInfoBean.id);
            }else{
              printDebug("FlutterMaxAd isRewardedAdReady=false");
              _removeMaxAd(resultBean.maxAdInfoBean.id);
              _adShowListener?.showAdFail?.call(null,null);
              loadAdByType(AdType.reward);
              loadAdByType(AdType.inter);
            }
          }else if(resultBean.maxAdInfoBean.plat=="topon"){
            if(await ATRewardedManager.rewardedVideoReady(placementID: resultBean.maxAdInfoBean.id)==true){
              ATRewardedManager.showRewardedVideo(placementID: resultBean.maxAdInfoBean.id);
            }else{
              printDebug("FlutterMaxAd reward ad ready=false");
              _removeMaxAd(resultBean.maxAdInfoBean.id);
              _adShowListener?.showAdFail?.call(null,null);
              loadAdByType(AdType.reward);
              loadAdByType(AdType.inter);
            }
          }else if(resultBean.maxAdInfoBean.plat=="tradplus"){
            printDebug("FlutterMaxAd show tradplus reward ad");
            if(await TPRewardVideoManager.rewardVideoAdReady(resultBean.maxAdInfoBean.id)){
              TPRewardVideoManager.showRewardVideoAd(resultBean.maxAdInfoBean.id);
            }else{
              printDebug("FlutterMaxAd tradplus reward ad ready=false");
              _removeMaxAd(resultBean.maxAdInfoBean.id);
              _adShowListener?.showAdFail?.call(null,null);
              loadAdByType(AdType.reward);
              loadAdByType(AdType.inter);
            }
          }
          break;
        case AdType.inter:
          if(resultBean.maxAdInfoBean.plat=="max"){
            if(await AppLovinMAX.isInterstitialReady(resultBean.maxAdInfoBean.id)==true){
              AppLovinMAX.showInterstitial(resultBean.maxAdInfoBean.id);
            }else{
              printDebug("FlutterMaxAd isRewardedAdReady=false");
              _removeMaxAd(resultBean.maxAdInfoBean.id);
              _adShowListener?.showAdFail?.call(null,null);
              loadAdByType(AdType.reward);
              loadAdByType(AdType.inter);
            }
          }else if(resultBean.maxAdInfoBean.plat=="topon"){
            if(await ATInterstitialManager.hasInterstitialAdReady(placementID: resultBean.maxAdInfoBean.id)==true){
              ATInterstitialManager.showInterstitialAd(placementID: resultBean.maxAdInfoBean.id);
            }else{
              printDebug("FlutterMaxAd inter ad ready=false");
              _removeMaxAd(resultBean.maxAdInfoBean.id);
              _adShowListener?.showAdFail?.call(null,null);
              loadAdByType(AdType.reward);
              loadAdByType(AdType.inter);
            }
          }else if(resultBean.maxAdInfoBean.plat=="tradplus"){
            printDebug("FlutterMaxAd show tradplus int ad");
            if(await TPInterstitialManager.interstitialAdReady(resultBean.maxAdInfoBean.id)){
              TPInterstitialManager.showInterstitialAd(resultBean.maxAdInfoBean.id);
            }else{
              printDebug("FlutterMaxAd tradplus int ad ready=false");
              _removeMaxAd(resultBean.maxAdInfoBean.id);
              _adShowListener?.showAdFail?.call(null,null);
              loadAdByType(AdType.reward);
              loadAdByType(AdType.inter);
            }
          }
          break;
        default:
          _adShowListener?.showAdFail?.call(null,null);
          break;
      }
    }else{
      printDebug("FlutterMaxAd --->$adType result == null");
      _adShowListener?.showAdFail?.call(null,null);
      loadAdByType(AdType.reward);
      loadAdByType(AdType.inter);
    }
  }

  fullAdShowing()=>_fullAdShowing;

  _onAdRevenuePaidByAdjust(MaxAd ad){
    try{
      var adjustAdRevenue = AdjustAdRevenue(AdjustConfig.AdRevenueSourceAppLovinMAX,);
      adjustAdRevenue.setRevenue(ad.revenue, ad.dspName=="topon"?ad.creativeId:"USD");
      adjustAdRevenue.adRevenueNetwork=ad.networkName;
      adjustAdRevenue.adRevenueUnit=ad.adUnitId;
      adjustAdRevenue.adRevenuePlacement=ad.placement;
      Adjust.trackAdRevenueNew(adjustAdRevenue);
    }catch(e){

    }
    try{
      FirebaseAnalytics.instance.logPurchase(
        value: ad.revenue,
        currency: ad.dspName=="topon"?ad.creativeId:"USD",
      );
    }catch(e){

    }
    try{
      if(_initFaceBookResult){
        _facebookAppEvents.logPurchase(amount: ad.revenue, currency: "USD");
      }
    }catch(e){

    }
    _adShowListener?.onAdRevenuePaidCallback?.call(ad);
  }

  MaxAdInfoBean? _getMaxInfoById(String id){
    var infoBean = LoadAdUtils.instance.getAdInfoById(id);
    infoBean ??= LoadAdUtils2.instance.getAdInfoById(id);
    return infoBean;
  }

  bool checkHasCache(AdType adType)=>LoadAdUtils.instance.checkHasCache(adType)||LoadAdUtils2.instance.checkHasCache(adType);

  startLoadAd(){
    // _loadAdListener?.startLoad.call();
  }

  MaxAd? _createMaxAdByTopOnInfo(String adUnitId,Map extraMap){
    try{
      return MaxAd(adUnitId, extraMap["network_name"], extraMap["publisher_revenue"], extraMap["precision"], extraMap["currency"], "topon", "", MaxAdWaterfallInfo("", "", [], 0.0), null);
    }catch(e){
      return null;
    }
  }

  MaxAd? _createMaxAdByTradPlusInfo(String adUnitId, Map<dynamic, dynamic> extraMap){
    // {ecpmPrecision: exact, tpAdUnitId: A3FB7F4E2DC83B2669C6FC9CE9A23211, bannerW: 0,
    // rewardNumber: 0, video_protocol: 0, ecpmLevel: 0, waterfallIndex: 0, bucketId: 0,
    // placementAdType: 0, isNative: 0, isBottom: false, impressionId: e94f8718-ba8b-4b00-a825-6adc518e8add492223,
    // ecpmcny: 2.9, loadTime: 33, configBean: {"placementId":"8999996002","appId":"899999","token":"EaCw0AipSYyvf3E7"},
    // configString: {"placementId":"8999996002","appId":"899999","token":"EaCw0AipSYyvf3E7"},
    // requestId: e94f8718-ba8b-4b00-a825-6adc518e8add, segmentId: 0, adSourceId: 8999996002,
    // adSourcePlacementId: 492223, networkType: interstitial, height: 0, amount: 0, rewardVerifyMap: {},
    // format: interstitial, is_exclusive: 0, impPaidData: {}, adViewWidth: 0, adViewHeight: 0,
    // ecpm: 0.3984, isoCode: CN, bannerH: 0, ecpmExact: 0.3984, width: 0, isBiddingNetwork: true,
    // adNetworkId: 75, adSourceName: KwaiAd, ecpmExactCny: 2.9}
    try{
      return MaxAd(adUnitId, extraMap["networkType"], extraMap["ecpm"], extraMap["ecpmPrecision"], "", "tradplus", "", MaxAdWaterfallInfo("", "", [], 0.0), null);
    }catch(e){
      return null;
    }
  }

  printDebug(Object? object){
    if(kDebugMode){
      print(object);
    }
  }

  initFaceBook(String conf)async{
    var result = await _facebookAppEvents.initFacebook(conf);
    _initFaceBookResult=result??false;
  }

  // dismissMaxAdView(){
  //   if(_fullAdShowing){
  //     _fullAdShowing=false;
  //     _fromForceClose=true;
  //     FlutterMaxAdPlatform.instance.dismissMaxAdView();
  //     FlutterMaxAdPlatform.instance.dismissMaxAdView();
  //     loadAdByType(AdType.inter);
  //     loadAdByType(AdType.reward);
  //     _adShowListener?.onAdHidden.call(null);
  //     Future.delayed(const Duration(milliseconds: 1000),(){
  //       _fromForceClose=false;
  //     });
  //   }
  // }
}
