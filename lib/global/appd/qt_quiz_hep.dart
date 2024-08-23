import 'package:quiztime55/global/appd/qt_str.dart';

class QtQuizHep {
  static const String QH_NK_N = "n";
  static const String QH_NK_H = "h";
  static const String QH_NK_S = "s";
  static const String QH_NK_M = "m";
  static const String QH_NK_A = "a";

  static String getKeyName(String nk) {
    if (nk == QH_NK_N) {
      return gQtStr.agtew_n;
    } else if (nk == QH_NK_H) {
      return gQtStr.agtew_h;
    } else if (nk == QH_NK_S) {
      return gQtStr.agtew_s;
    } else if (nk == QH_NK_M) {
      return gQtStr.agtew_m;
    } else if (nk == QH_NK_A) {
      return gQtStr.agtew_a;
    }

    return "-";
  }

//TODO 将题库整合为一个json，按key分类,在开屏页使用compute解析JSON
}
