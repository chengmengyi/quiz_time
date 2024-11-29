
import 'package:time_base/hep/heppppp.dart';

class AdjustEventConfBean {
  AdjustEventConfBean({
      this.qtLtv0, 
      this.qtPv, 
      this.qtLtv0Other, 
      this.qtPvOther,});

  AdjustEventConfBean.fromJson(dynamic json) {
    qtLtv0 = json['qt_ltv0'].toString().toDou();
    qtPv = json['qt_pv'].toString().toDou();
    qtLtv0Other = json['qt_ltv0_other'].toString().toDou();
    qtPvOther = json['qt_pv_other'].toString().toDou();
  }
  double? qtLtv0;
  double? qtPv;
  double? qtLtv0Other;
  double? qtPvOther;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['qt_ltv0'] = qtLtv0;
    map['qt_pv'] = qtPv;
    map['qt_ltv0_other'] = qtLtv0Other;
    map['qt_pv_other'] = qtPvOther;
    return map;
  }

}