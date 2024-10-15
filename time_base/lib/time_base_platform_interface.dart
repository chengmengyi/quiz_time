import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:time_base/hep/notification/notification_call.dart';

import 'time_base_method_channel.dart';

abstract class TimeBasePlatform extends PlatformInterface {
  /// Constructs a TimeBasePlatform.
  TimeBasePlatform() : super(token: _token);

  static final Object _token = Object();

  static TimeBasePlatform _instance = MethodChannelTimeBase();

  /// The default instance of [TimeBasePlatform] to use.
  ///
  /// Defaults to [MethodChannelTimeBase].
  static TimeBasePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TimeBasePlatform] when
  /// they register themselves.
  static set instance(TimeBasePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> startTimeQuizWork({
    required int notificationId,
    required bool notificationB,
    required List<String> notificationContent,
    required String notificationBtn,
}){
    return _instance.startTimeQuizWork(notificationId: notificationId, notificationB: notificationB, notificationContent: notificationContent, notificationBtn: notificationBtn);
  }

  Future<bool> requestPer()=>_instance.requestPer();
  Future<bool> checkHasPer()=>_instance.checkHasPer();

  Future<void> startTimeQuizService({
    required int serviceNotificationId,
    required bool notificationB,
    required String serviceNotificationTitle,
    required String serviceNotificationMoney,
})=> _instance.startTimeQuizService(serviceNotificationId: serviceNotificationId, notificationB: notificationB, serviceNotificationTitle: serviceNotificationTitle, serviceNotificationMoney: serviceNotificationMoney);

  Future<void> setNotificationCall(NotificationCall call){
    return _instance.setNotificationCall(call);
  }

  Future<int?> getLaunchNotificationId()=>_instance.getLaunchNotificationId();
}
