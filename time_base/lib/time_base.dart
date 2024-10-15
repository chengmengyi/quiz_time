import 'dart:io';

import 'package:time_base/hep/notification/notification_call.dart';

import 'time_base_platform_interface.dart';

class TimeBase {
  static final TimeBase _instance=TimeBase();

  static TimeBase get instance=>_instance;

  startTimeQuizWork({
    required int notificationId,
    required bool notificationB,
    required List<String> notificationContent,
    required String notificationBtn,
  }){
    if(Platform.isIOS){
      return;
    }
    TimeBasePlatform.instance.startTimeQuizWork(notificationId: notificationId, notificationB: notificationB, notificationContent: notificationContent, notificationBtn: notificationBtn);
  }

  Future<bool> requestTimeQuizNotificationPer()async{
    return await TimeBasePlatform.instance.requestPer();
  }

  Future<bool> checkTimeQuizHasNotificationPer()async{
    return await TimeBasePlatform.instance.checkHasPer();
  }

  startTimeQuizService({
    required int serviceNotificationId,
    required bool notificationB,
    required String serviceNotificationTitle,
    required String serviceNotificationMoney,
  }){
    if(Platform.isIOS){
      return;
    }
    TimeBasePlatform.instance.startTimeQuizService(serviceNotificationId: serviceNotificationId, notificationB: notificationB, serviceNotificationTitle: serviceNotificationTitle, serviceNotificationMoney: serviceNotificationMoney);
  }

  setNotificationCall(NotificationCall call){
    TimeBasePlatform.instance.setNotificationCall(call);
  }

  Future<int?> getLaunchNotificationId()async{
    return await TimeBasePlatform.instance.getLaunchNotificationId();
  }
}
