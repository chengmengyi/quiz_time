import 'package:flutter/cupertino.dart';
import 'package:quiztime55/global/appd/qt_save.dart';

class QtCur {
  static int cur = curK.getV();

  static putCur(int c) {
    cur += c;
    curK.putV(cur);
  }

  static Function() curLis(ValueSetter l) => curK.listen(l);
}
