import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quiztime55/b/hep/tttt/point_name.dart';
import 'package:quiztime55/b/hep/tttt/tttt_hep.dart';

abstract class BaseNotifi{
  var localNotifi=FlutterLocalNotificationsPlugin();

  Future<bool> initNotifiSetting()async{
    InitializationSettings initializationSettings = const InitializationSettings(
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      )
    );
    var success = await localNotifi.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (
          NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            clickNotification(notificationResponse);
            break;
          case NotificationResponseType.selectedNotificationAction:
            clickNotification(notificationResponse);
            break;
        }
      },
    );
    return success??false;
  }

  clickNotification(NotificationResponse notificationResponse);

  periodicallyShow({
    required int id,
    required RepeatInterval repeatInterval,
    required String title,
    required String body
  }){
    const NotificationDetails notificationDetails = NotificationDetails();
    localNotifi.periodicallyShow(
        id,
        title,
        body,
        repeatInterval,
        notificationDetails
    );
  }

  Future<bool> checkHasPermission()async{
    var plugin = localNotifi.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    var options = await plugin?.checkPermissions();
    var has = options?.isEnabled==true;
    if(has){
      TTTTHep.instance.pointEvent(PointName.push_status);
    }
    return has;
  }

  toOpenNotifi()async{
    AppSettings.openAppSettings(type: AppSettingsType.notification);
  }

  Future<NotificationAppLaunchDetails?> getNotificationAppLaunchDetails()async{
    return await localNotifi.getNotificationAppLaunchDetails();
  }
}