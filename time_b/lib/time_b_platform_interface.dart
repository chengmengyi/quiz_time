import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'time_b_method_channel.dart';

abstract class Time_bPlatform extends PlatformInterface {
  /// Constructs a Time_bPlatform.
  Time_bPlatform() : super(token: _token);

  static final Object _token = Object();

  static Time_bPlatform _instance = MethodChannelTime_b();

  /// The default instance of [Time_bPlatform] to use.
  ///
  /// Defaults to [MethodChannelTime_b].
  static Time_bPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [Time_bPlatform] when
  /// they register themselves.
  static set instance(Time_bPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
