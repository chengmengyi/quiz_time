import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:quiztime55/global/appd/qt_save.dart';
import 'package:quiztime55/global/appd/qt_str.dart';
import 'package:synchronized/synchronized.dart';

// {
// "qtq": "What is the layer of Earth's atmosphere that contains the ozone layer?",
// "qt_a": "Troposphere",
// "qt_b": "Stratosphere",
// "qt_res": "b"
// }
class QtQuizHep {
  static const String QH_NK_N = "n";
  static const String QH_NK_H = "h";
  static const String QH_NK_S = "s";
  static const String QH_NK_M = "m";
  static const String QH_NK_A = "a";

  static const QtSaveKey<String> qtCurK = QtSaveKey(key: "qtCurK", de: QtQuizHep.QH_NK_N);

  static Map<String, dynamic>? data;

  static Lock lock = Lock();

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

  static QtSaveKey getKeyPosSave(String nk) {
    return QtSaveKey(key: "qtKey$nk", de: 0);
  }

  static loadQtData() async {
    await lock.synchronized(() async {
      if (data == null) {
        var ds = await rootBundle.loadString("qtf/f2/data.txt");
        data = await compute(_loadData, ds);
      }
    });
  }

  static Map<String, dynamic> _loadData(String data) {
    return jsonDecode(_decode(data));
  }

  static String _decode(String st) {
    List<int> bytes = base64Decode(st.replaceAll(RegExp(r'\s|\n'), ''));
    String result = utf8.decode(bytes);
    return result.replaceFirst(RegExp(r'\s|\n'), '', result.length - 1);
  }

  static List<Map<String, dynamic>>? getItems(String nk) {
    if (data == null) return null;
    return List.from(data![nk]);
  }

  static String checkNext() {
    if (getKeyPosSave(QtQuizHep.QH_NK_N).getV() < (getItems(QtQuizHep.QH_NK_N)?.length ?? 0)) {
      return QtQuizHep.QH_NK_N;
    } else if (getKeyPosSave(QtQuizHep.QH_NK_H).getV() < (getItems(QtQuizHep.QH_NK_H)?.length ?? 0)) {
      return QtQuizHep.QH_NK_H;
    } else if (getKeyPosSave(QtQuizHep.QH_NK_S).getV() < (getItems(QtQuizHep.QH_NK_S)?.length ?? 0)) {
      return QtQuizHep.QH_NK_S;
    } else if (getKeyPosSave(QtQuizHep.QH_NK_M).getV() < (getItems(QtQuizHep.QH_NK_M)?.length ?? 0)) {
      return QtQuizHep.QH_NK_M;
    } else if (getKeyPosSave(QtQuizHep.QH_NK_A).getV() < (getItems(QtQuizHep.QH_NK_A)?.length ?? 0)) {
      return QtQuizHep.QH_NK_A;
    } else {
      getKeyPosSave(QtQuizHep.QH_NK_N).putV(0);
      getKeyPosSave(QtQuizHep.QH_NK_H).putV(0);
      getKeyPosSave(QtQuizHep.QH_NK_S).putV(0);
      getKeyPosSave(QtQuizHep.QH_NK_M).putV(0);
      getKeyPosSave(QtQuizHep.QH_NK_A).putV(0);
      return QtQuizHep.QH_NK_N;
    }
  }
}
