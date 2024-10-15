import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'time_b_platform_interface.dart';

/// An implementation of [Time_bPlatform] that uses method channels.
class MethodChannelTime_b extends Time_bPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('time_b');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
