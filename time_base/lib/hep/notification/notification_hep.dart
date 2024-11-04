import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:time_base/hep/heppppp.dart';
import 'package:time_base/hep/notification/notification_call.dart';
import 'package:time_base/hep/notification/notification_id.dart';
import 'package:time_base/hep/notification/open_notifi.dart';
import 'package:time_base/hep/tttt/point_name.dart';
import 'package:time_base/hep/tttt/tttt_hep.dart';
import 'package:time_base/quiz_language/local_text.dart';
import 'package:time_base/time_base.dart';

class NotificationHep{

  factory NotificationHep() => _getInstance();

  static NotificationHep get instance => _getInstance();

  static NotificationHep? _instance;

  static NotificationHep _getInstance() {
    _instance ??= NotificationHep._internal();
    return _instance!;
  }

  NotificationHep._internal();

  initNotification(double userCoins)async{
    // var hasPer = await TimeBase.instance.requestTimeQuizNotificationPer();

    var result = await Permission.notification.request();
    if (result.isGranted) {
      _startForegroundService(userCoins);

      TimeBase.instance.startTimeQuizWork(
        notificationId: NotificationId.notificationId,
        notificationB: FlutterCheckAdjustCloak.instance.getUserType(),
        notificationContent: [LocalText.getPaidForEvery.tr,LocalText.signUpInMinutes.tr,LocalText.hugeRewardsAreWaiting.tr],
        notificationBtn: LocalText.withdraw.tr,
      );
      _addClickListener();


    FirebaseMessaging.instance.subscribeToTopic("BR~ALL");
    }
  }

  _startForegroundService(double userCoins) async{
    var userType = FlutterCheckAdjustCloak.instance.getUserType();
    TimeBase.instance.startTimeQuizService(
      serviceNotificationId: NotificationId.serviceNotificationId,
      notificationB: userType,
      serviceNotificationTitle: LocalText.waitingForWithdrawal.tr,
      serviceNotificationMoney: userType?moneyDou2Str(userCoins):formatCoins(userCoins),
    );
  }

  updateForegroundData(double userCoins) async {
    var status = await Permission.notification.status;
    if(status.isGranted){
      _startForegroundService(userCoins);
    }
  }

  checkLaunchAppFrom()async{
    var id = await TimeBase.instance.getLaunchNotificationId()??0;
    TTTTHep.instance.pointEvent(PointName.launch_page,params: {"source_from":id==0?"icon":"push"});
    _notificationTba(id);
    var hasSim = await FlutterCheckAdjustCloak.instance.checkHasSim();
    TTTTHep.instance.pointEvent(PointName.sim_user,params: {"user_from":hasSim?"1":"0"});
    pushStatusTba();
  }

  _addClickListener(){
    TimeBase.instance.setNotificationCall(
      NotificationCall(userClickNotification: (id){
        _notificationTba(id);
      })
    );
  }

  _notificationTba(int id)async{
    switch(id){
      case NotificationId.notificationId:
        TTTTHep.instance.pointEvent(PointName.inform_c,params: {"inform_from":"fix"});
        break;
      case NotificationId.serviceNotificationId:
        TTTTHep.instance.pointEvent(PointName.inform_c,params: {"inform_from":"cash"});
        break;
    }
  }

  pushStatusTba()async{
    var has = await TimeBase.instance.checkTimeQuizHasNotificationPer();
    if(has){
      TTTTHep.instance.pointEvent(PointName.push_status,);
    }
  }
}