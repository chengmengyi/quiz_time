import 'package:flutter/cupertino.dart';

var gQtStr = QtStr();

String wstrAssembly(String s, String as) {
  var rets = "";
  for (var e in s.characters) {
    if (e == "#") {
      rets += as;
    } else {
      rets += e;
    }
  }
  return rets;
}

class QtStr {
  String afwe = "";
}
