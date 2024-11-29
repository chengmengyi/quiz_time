import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'hep/notification/notification_call.dart';
import 'time_base_platform_interface.dart';

/// An implementation of [TimeBasePlatform] that uses method channels.
class MethodChannelTimeBase extends TimeBasePlatform {
  NotificationCall? _call;

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('time_base');

  MethodChannelTimeBase(){
    methodChannel.setMethodCallHandler((result)async{
      if(result.method=="clickNotification"){
        _call?.userClickNotification.call(result.arguments["notificationId"]);
      }
    });
  }

  @override
  Future<void> startTimeQuizWork({
    required int notificationId, 
    required bool notificationB,
    required List<String> notificationContent,
    required String notificationBtn,
    required int repeatIntervalMinutes,
  }) async{
    await methodChannel.invokeMethod(
      "startTimeQuizWork",
      {
        "notificationId":notificationId,
        "notificationB":notificationB,
        "notificationContent":notificationContent,
        "notificationBtn":notificationBtn,
        "test":kDebugMode,
        "repeatIntervalMinutes":repeatIntervalMinutes
      }
    );
  }

  @override
  Future<bool> requestPer() async{
    return await methodChannel.invokeMethod("requestTimeQuizNotificationPer");
  }

  @override
  Future<bool> checkHasPer() async{
    return await methodChannel.invokeMethod("checkTimeQuizHasNotificationPer");
  }

  @override
  Future<void> startTimeQuizService({required int serviceNotificationId, required bool notificationB, required String serviceNotificationTitle, required String serviceNotificationMoney}) async{
    await methodChannel.invokeMethod(
        "startTimeQuizService",
        {
          "serviceNotificationId":serviceNotificationId,
          "notificationB":notificationB,
          "serviceNotificationTitle":serviceNotificationTitle,
          "serviceNotificationMoney":serviceNotificationMoney,
        }
    );
  }

  @override
  Future<void> setNotificationCall(NotificationCall call) async{
    _call=call;
  }

  @override
  Future<int?> getLaunchNotificationId()async{
    return await methodChannel.invokeMethod("getLaunchNotificationId");
  }

  @override
  Future<void> showUrlByBrowser(String url) async{
    await methodChannel.invokeMethod("showUrlByBrowser",{"url":url});
  }

  @override
  Future<void> showOnceNotification(int notificationId, bool notificationB, List<String> notificationContent, String notificationBtn) async{
    await methodChannel.invokeMethod(
        "showOnceNotification",
        {
          "notificationId":notificationId,
          "notificationB":notificationB,
          "notificationContent":notificationContent,
          "notificationBtn":notificationBtn,
        }
    );
  }

  @override
  setMainExist(bool exist) async{
    await methodChannel.invokeMethod("setMainExist",{"exist":exist});
  }
}
