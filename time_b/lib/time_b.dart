
import 'time_b_platform_interface.dart';

class Time_b {
  Future<String?> getPlatformVersion() {
    return Time_bPlatform.instance.getPlatformVersion();
  }
}
