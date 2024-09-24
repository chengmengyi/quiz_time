import 'dart:math';
import 'package:flutter_local_notifications_platform_interface/src/types.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:quiztime55/b/dia/open_notifi.dart';
import 'package:quiztime55/b/hep/ad/ad_pppp.dart';
import 'package:quiztime55/b/hep/ad/show_ad_hep.dart';
import 'package:quiztime55/b/hep/heppppp.dart';
import 'package:quiztime55/b/hep/info_hep.dart';
import 'package:quiztime55/b/hep/notifi/base_noti.dart';
import 'package:quiztime55/b/hep/tttt/point_name.dart';
import 'package:quiztime55/b/hep/tttt/tttt_hep.dart';
import 'package:quiztime55/global/appd/qt_save.dart';

class NotifiId{
  static const int gu=1000;
  static const int qian=1001;
  static const int da=1002;
  static const int pay=1003;
}

const QtSaveKey<bool> showedOpenNotifiBean = QtSaveKey(key: "showedOpenNotifi", de: false);


class NotifiHep extends BaseNotifi{
  factory NotifiHep()=>_getInstance();
  static NotifiHep get instance=>_getInstance();
  static NotifiHep? _instance;
  static NotifiHep _getInstance(){
    _instance??=NotifiHep._internal();
    return _instance!;
  }

  NotifiHep._internal();

  showNotifi()async{
    var result = await initNotifiSetting();
    if(result){
      _createGudingNotifi();
      _createQianNotifi();
      _createDaNotifi();
      _createPayNotifi();
    }
    var has = await checkHasPermission();
    if(!has&&!showedOpenNotifiBean.getV()){
      OpenNotifiDialog(
        openCall: (){
          toOpenNotifi();
        },
      ).show();
    }else{
      showedOpenNotifiBean.putV(true);
    }
  }

  _createGudingNotifi(){
    Future.delayed(Duration(seconds: _getDelayTime()),(){
      periodicallyShow(
        id: NotifiId.gu,
        repeatInterval: RepeatInterval.daily,
        title: "Earn money by QuizTime",
        body: [
          "💰More than 1,000 users have successfully withdrawn money",
          "🎁Turn your knowledge into cash",
          "🔥Here‘s \$100 for you! Expired after 5 minutes!",
        ].getRandom(),
      );
    });
  }

  _createQianNotifi(){
    Future.delayed(Duration(seconds: _getDelayTime()),(){
      periodicallyShow(
        id: NotifiId.qian,
        repeatInterval: RepeatInterval.hourly,
        title: "Cash in check daily ",
        body: "Sign up now and start earning money effortlessly.",
      );
    });
  }

  _createDaNotifi(){
    Future.delayed(Duration(seconds: _getDelayTime()),(){
      periodicallyShow(
        id: NotifiId.da,
        repeatInterval: RepeatInterval.hourly,
        title: "Answer right, Earn Big!",
        body: [
          "💰Someone just made a successful withdrawal on QuizTime！",
          "🎁Put your knowledge to work and earn money!",
        ].getRandom(),
      );
    });
  }

  _createPayNotifi(){
    Future.delayed(Duration(seconds: _getDelayTime()),(){
      periodicallyShow(
        id: NotifiId.pay,
        repeatInterval: RepeatInterval.daily,
        title: "Pending withdraw amount",
        body: "\$100 has arrived in your account",
      );
    });
  }

  int _getDelayTime()=>Random().nextInt(20);

  checkOpenPermission()async{
    var has = await checkHasPermission();
    if(has&&!showedOpenNotifiBean.getV()){
      showedOpenNotifiBean.putV(true);
      InfoHep.instance.addCoins(10);
      showNotifi();
    }
  }

  @override
  clickNotification(NotificationResponse notificationResponse) {
    tbaPointClickNotifi(notificationResponse.id);
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

  tbaPointClickNotifi(int? id){
    switch(id){
      case NotifiId.gu:
        TTTTHep.instance.pointEvent(PointName.fix_inform_c);
        break;
      case NotifiId.qian:
        TTTTHep.instance.pointEvent(PointName.sign_inform_c);
        break;
      case NotifiId.da:
        TTTTHep.instance.pointEvent(PointName.quiz_infrom_c);
        break;
      case NotifiId.pay:
        TTTTHep.instance.pointEvent(PointName.cash_inform_c);
        break;
    }
  }
}