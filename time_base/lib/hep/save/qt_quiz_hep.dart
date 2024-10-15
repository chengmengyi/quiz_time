import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:synchronized/synchronized.dart';
import 'package:time_base/hep/save/qt_str.dart';

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

  static loadQtData() async {
    switch(Get.deviceLocale?.countryCode??"US"){
      case "BR":
        _parseQuizByCountry("quiz_br.txt");
        break;
      case "VN":
        _parseQuizByCountry("quiz_vn.txt");
        break;
      case "ID":
        _parseQuizByCountry("quiz_id.txt");
        break;
      case "TH":
        _parseQuizByCountry("quiz_th.txt");
        break;
      case "RU":
        _parseQuizByCountry("quiz_ru.txt");
        break;
      default:
        await lock.synchronized(() async {
          var ds = await rootBundle.loadString("qtf/f2/data.txt");
          data = await compute(_loadData, ds);
          print(data);
        });
        break;
    }
  }

  static _parseQuizByCountry(String txt)async{
    await lock.synchronized(() async {
      var ds = await rootBundle.loadString("qtf/f2/$txt");
      var decode = jsonDecode(_decode(ds));
      var mathList=[];
      var historyList=[];
      var natureList=[];
      var scienceList=[];
      var animalList=[];
      for(var value in decode){
        var result = value["result"];
        var map={
          "qtq":value["name"],
          "qt_a":value["top"],
          "qt_b":value["bottom"],
          "qt_res":result=="top"?"a":"b"
        };
        switch(value["category"]){
          case "Math":
            mathList.add(map);
            break;
          case "History":
            historyList.add(map);
            break;
          case "Nature":
            natureList.add(map);
            break;
          case "Science":
            scienceList.add(map);
            break;
          case "Animal":
            animalList.add(map);
            break;
        }
      }
      data={"h":historyList,"n":natureList,"s":scienceList,"m":mathList,"a":animalList};
      print(data);
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

  static int getQuizAllLength(){
    if(null==data){
      return 0;
    }
    var l=0;
    data?.forEach((key,value){
      l+=(getItems(key)??[]).length;
    });
    return l;
  }
}
