import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'time_a_method_channel.dart';

abstract class Time_aPlatform extends PlatformInterface {
  /// Constructs a Time_aPlatform.
  Time_aPlatform() : super(token: _token);

  static final Object _token = Object();

  static Time_aPlatform _instance = MethodChannelTime_a();

  /// The default instance of [Time_aPlatform] to use.
  ///
  /// Defaults to [MethodChannelTime_a].
  static Time_aPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [Time_aPlatform] when
  /// they register themselves.
  static set instance(Time_aPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
