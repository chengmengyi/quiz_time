import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'time_a_platform_interface.dart';

/// An implementation of [Time_aPlatform] that uses method channels.
class MethodChannelTime_a extends Time_aPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('time_a');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
