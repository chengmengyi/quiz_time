import 'package:flutter_max_ad/export.dart';
import 'package:time_base/hep/heppppp.dart';
import 'package:anythink_sdk/at_index.dart';

class TestAd{
  factory TestAd()=>_getInstance();
  static TestAd get instance=>_getInstance();
  static TestAd? _instance;
  static TestAd _getInstance(){
    _instance??=TestAd._internal();
    return _instance!;
  }

  TestAd._internal();


  init()async{

    print("kk====kaishi=${DateTime.now()}");
    try{
      ATInitManger.setLogEnabled(logEnabled: true);
      ATInitManger.initAnyThinkSDK(appidStr: strBase64Decode(toponId), appidkeyStr: strBase64Decode(toponKey));
      print("kk====chushihua jieguo====${DateTime.now()}");
      ATListenerManager.interstitialEventHandler.listen((event) {
        var adUnitId = event.placementID;
        switch (event.interstatus) {
        //广告加载失败
          case InterstitialStatus.interstitialAdFailToLoadAD:
            print("kk===inter shibai====${DateTime.now()}");
            break;
        //广告加载成功
          case InterstitialStatus.interstitialAdDidFinishLoading:
            print("kk===inter chenggong====${DateTime.now()}");
            break;
        //广告展示成功
          case InterstitialStatus.interstitialDidShowSucceed:

            break;
        //广告展示失败
          case InterstitialStatus.interstitialFailedToShow:


            break;
        //广告被点击
          case InterstitialStatus.interstitialAdDidClick:

            break;
        //广告被关闭
          case InterstitialStatus.interstitialAdDidClose:

            break;
          default:

            break;
        }
      });
      ATListenerManager.rewardedVideoEventHandler.listen((event) {
        print("kk===jili event====${DateTime.now()}====${event.requestMessage}===${event.extraMap}");
        var adUnitId = event.placementID;
        switch (event.rewardStatus) {
        //广告加载失败
          case RewardedStatus.rewardedVideoDidFailToLoad:
            print("kk===jili shibai====${DateTime.now()}");
            break;
        //广告加载成功
          case RewardedStatus.rewardedVideoDidFinishLoading:
            print("kk===jili chenggong====${DateTime.now()}");
            break;
        //广告展示成功
          case RewardedStatus.rewardedVideoDidStartPlaying:

            break;
        //广告展示失败
          case RewardedStatus.rewardedVideoDidFailToPlay:

            break;
        //广告被点击
          case RewardedStatus.rewardedVideoDidClick:

            break;
        //广告被关闭
          case RewardedStatus.rewardedVideoDidClose:

            break;
          default:

            break;
        }
      });


    }catch(e){
      print("kk====error====${e}");
    }
  }

  load(){
    print("kk===jili kaishijiazai====${DateTime.now()}");
    // ATRewardedManager.loadRewardedVideo(
    //   placementID: "b6708eaf253569",
    //   extraMap: {
    //     ATSplashManager.tolerateTimeout(): 20000
    //   },
    // );

    //jili kaishijiazai====2024-11-21 13:32:47.593030
    //jili chenggong====   2024-11-21 13:33:08.108639



    //kaishijiazai====2024-11-21 13:38:55.24831
    //chenggong===   =2024-11-21 13:39:04.329263
    ATInterstitialManager.loadInterstitialAd(
      placementID: "b6708eb002b870",
      extraMap: {
        ATSplashManager.tolerateTimeout(): 20000
      },
    );
  }


  initMax()async{
    // {"mlpokjiu":100,"hnbvgytf":100,"kztym_int_one":[{"cxdresza":"9ebb44ab24d26b30","qetuoljg":
    // "max","daxvnlhf":"interstitial","fhiursnj":3000,"osnenhfq":3}],"kztym_int_two":[{
    //   "cxdresza":"ebefb1aed2c6f460","qetuoljg":"max","daxvnlhf":"interstitial","fhiursnj":
    // 3000,"osnenhfq":3}],"kztym_rv_one":[{"cxdresza":"e601627c0ed88c55","qetuoljg":"max",
    // "daxvnlhf":"reward","fhiursnj":3000,"osnenhfq":3}],"kztym_rv_two":[{"cxdresza":"ea56f2d121ec93ac",
    // "qetuoljg":"max","daxvnlhf":"reward","fhiursnj":3000,"osnenhfq":3}]}
    print("kk===chushihua====${DateTime.now()}");
    var maxConfiguration = await AppLovinMAX.initialize(strBase64Decode(maxKeyBase64));
    print("kk===chushihua jieguo==${null!=maxConfiguration}==${DateTime.now()}");
    AppLovinMAX.setRewardedAdListener(
        RewardedAdListener(
            onAdLoadedCallback: (MaxAd ad) {
              print("kk===onAdLoadedCallback====${DateTime.now()}");
            },
            onAdLoadFailedCallback: (String adUnitId, MaxError error) {
              print("kk===onAdLoadFailedCallback====${error.message}");
            },
            onAdDisplayedCallback: (MaxAd ad) {

            },
            onAdDisplayFailedCallback: (MaxAd ad, MaxError error) {

            },
            onAdClickedCallback: (MaxAd ad) {
            },
            onAdHiddenCallback: (MaxAd ad) {

            },
            onAdReceivedRewardCallback: (MaxAd ad, MaxReward reward) {
            },
            onAdRevenuePaidCallback: (MaxAd ad){
            }
        )
    );

    print("kk===kaishi====${DateTime.now()}");
    //30
    // AppLovinMAX.loadRewardedAd("e601627c0ed88c55");
    
    
    
    //kk===kaishi====2024-11-23 10:30:13.312411
    //kk===onAdLoaded2024-11-23 10:30:43.608788

  }
  
  loadMax(){
    AppLovinMAX.setInterstitialListener(InterstitialListener(onAdLoadedCallback: (MaxAd ad) {
      print("kk===onAdLoadedCallback====${DateTime.now()}");
    }, onAdLoadFailedCallback: (String adUnitId, MaxError error) {
      print("kk===onAdLoadFailedCallback====${error.message}");
    }, onAdDisplayedCallback: (MaxAd ad) {  }, onAdDisplayFailedCallback: (MaxAd ad, MaxError error) {  }, onAdClickedCallback: (MaxAd ad) {  }, onAdHiddenCallback: (MaxAd ad) {  }));
    print("kk===kaishi====${DateTime.now()}");
    AppLovinMAX.loadInterstitial("9ebb44ab24d26b30");

    //kk===kaishi====2024-11-23 10:34:10.566984
    //kk===onAdLo====2024-11-23 10:34:19.271916
  }
}