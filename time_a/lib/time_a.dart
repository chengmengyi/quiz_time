
import 'time_a_platform_interface.dart';

class Time_a {
  Future<String?> getPlatformVersion() {
    return Time_aPlatform.instance.getPlatformVersion();
  }
}
