import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:time_b/hep/ad/adjust_event_conf_bean.dart';
import 'package:time_base/hep/check_type/check_type_hep.dart';
import 'package:time_base/hep/heppppp.dart';
import 'package:time_base/hep/save/qt_save.dart';
import 'package:time_base/hep/tttt/point_name.dart';
import 'package:time_base/hep/tttt/tttt_hep.dart';

const QtSaveKey<double> revenueCount = QtSaveKey(key: "revenueCountB", de: 0.0);
const QtSaveKey<int> adShowNumCount = QtSaveKey(key: "adShowNumCountB", de: 0);
const QtSaveKey<String> firstLaunchTimer = QtSaveKey(key: "firstLaunchTimerB", de: "");

class AdjustEventHep{
  factory AdjustEventHep()=>_getInstance();
  static AdjustEventHep get instance=>_getInstance();
  static AdjustEventHep? _instance;
  static AdjustEventHep _getInstance(){
    _instance??=AdjustEventHep._internal();
    return _instance!;
  }

  AdjustEventHep._internal();

  final Lock _lock = Lock();
  var _revenueCount=0.0,_adShowNumCount=0,_firstLaunchTimer="";
  AdjustEventConfBean? _adjustEventConfBean;

  initConf()async{
    _revenueCount=revenueCount.getV();
    _adShowNumCount=adShowNumCount.getV();

    _firstLaunchTimer = firstLaunchTimer.getV();
    if(_firstLaunchTimer.isEmpty){
      _firstLaunchTimer=getTodayStr();
      firstLaunchTimer.putV(_firstLaunchTimer);
    }

    await _lock.synchronized(() async {
      var adjustValue = await rootBundle.loadString("qtf/f2/adjust.txt");
      _adjustEventConfBean=AdjustEventConfBean.fromJson(jsonDecode(strBase64Decode(adjustValue)));
    });
    kwaiEventB.listen((v){
      _adjustEventConfBean=AdjustEventConfBean.fromJson(jsonDecode(v));
    });
  }

  countAdRevenueAndShowNum(MaxAd? maxAd){
    _revenueCount=(Decimal.fromJson("$_revenueCount")+Decimal.parse("${maxAd?.revenue??0.0}")).toDouble();
    _adShowNumCount++;
    if(_firstLaunchTimer==getTodayStr()){
      _trackRevenueEvent("qau2eb",PointName.qt_ltv0,_adjustEventConfBean?.qtLtv0??0.2);
      _trackRevenueEvent("q8vh12",PointName.qt_ltv0_other,_adjustEventConfBean?.qtLtv0Other??0.15);
    }

    _trackAdShowNumEvent("t0n2zn", PointName.qt_pv, _adjustEventConfBean?.qtPv??8);
    _trackAdShowNumEvent("lnyqy8", PointName.qt_pv_other, _adjustEventConfBean?.qtPvOther??5);
  }

  _trackRevenueEvent(String token,PointName name,double actionValue){
    if(_revenueCount>=actionValue){
      AdjustEvent adjustEvent=AdjustEvent(token);
      adjustEvent.addPartnerParameter("kwai_key_event_action_type", "4");
      adjustEvent.addPartnerParameter("kwai_key_event_action_value", "$actionValue");
      Adjust.trackEvent(adjustEvent);
      TTTTHep.instance.pointEvent(name,params: {"kwai_key_event_action_type":"4","kwai_key_event_action_value":"$actionValue"});
    }
  }

  _trackAdShowNumEvent(String token,PointName name,double actionValue){
    if(_adShowNumCount>=actionValue){
      AdjustEvent adjustEvent=AdjustEvent(token);
      adjustEvent.addPartnerParameter("kwai_key_event_action_type", "1");
      adjustEvent.addPartnerParameter("kwai_key_event_action_value", "$actionValue");
      Adjust.trackEvent(adjustEvent);
      TTTTHep.instance.pointEvent(name,params: {"kwai_key_event_action_type":"1","kwai_key_event_action_value":"$actionValue"});
    }
  }
}