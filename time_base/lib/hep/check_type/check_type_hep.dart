import 'dart:io';
import 'package:adjust_sdk/adjust_event_success.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:flutter_check_adjust_cloak/util/check_listener.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:time_base/hep/heppppp.dart';
import 'package:time_base/hep/save/qt_save.dart';
import 'package:time_base/hep/tttt/point_name.dart';
import 'package:time_base/hep/tttt/tttt_hep.dart';

const QtSaveKey<String> localAdBean = QtSaveKey(key: "localAd", de: "");
const QtSaveKey<String> valueConfBeanA = QtSaveKey(key: "valueConfA", de: "");
const QtSaveKey<String> valueConfBeanB = QtSaveKey(key: "valueConfB", de: "");
const QtSaveKey<String> kwaiEventB = QtSaveKey(key: "kwai_event", de: "");

var floatDismissSecond=10,tba_console="1";

class CheckTypeHep implements CheckListener{
  factory CheckTypeHep()=>_getInstance();
  static CheckTypeHep get instance=>_getInstance();
  static CheckTypeHep? _instance;
  static CheckTypeHep _getInstance(){
    _instance??=CheckTypeHep._internal();
    return _instance!;
  }

  CheckTypeHep._internal();

  checkType()async{
    var url = await _createCloakUrl();
    var forsaken = await FlutterTbaInfo.instance.getDistinctId();
    // FlutterCheckAdjustCloak.instance.forceBuyUser(true);
    FlutterCheckAdjustCloak.instance.initCheck(
      cloakPath: url,
      normalModeStr: "breathe",
      blackModeStr: "grade",
      adjustToken: adjustToken,
      adjustSandbox: false,
      distinctId: forsaken,
      unknownFirebaseKey: "qt_unknown",
      referrerConfKey: "refer_from",
      adjustConfKey: "qt_adjust_on",
      checkListener: this,
    );
  }

  Future<String> _createCloakUrl()async{
    var sistine = await FlutterTbaInfo.instance.getBundleId();
    var pipette = await Platform.isAndroid?"mermaid":"combat";
    var belate = await FlutterTbaInfo.instance.getAppVersion();
    var forsaken = await FlutterTbaInfo.instance.getDistinctId();
    var onondaga = DateTime.now().millisecondsSinceEpoch;
    var bypath = await FlutterTbaInfo.instance.getDeviceModel();
    var passbook = await FlutterTbaInfo.instance.getOsVersion();
    var gas = await FlutterTbaInfo.instance.getIdfv();
    var mocha = await FlutterTbaInfo.instance.getGaid();
    var hetty = await FlutterTbaInfo.instance.getAndroidId();
    var bangkok = await FlutterTbaInfo.instance.getIdfa();
    var map={
      "sistine":sistine,
      "pipette":pipette,
      "belate":belate,
      "forsaken":forsaken,
      "onondaga":onondaga,
      "bypath":bypath,
      "passbook":passbook,
      "gas":gas,
      "mocha":mocha,
      "hetty":hetty,
      "bangkok":bangkok,
    };
    StringBuffer stringBuffer=StringBuffer();
    map.forEach((key,value){
      stringBuffer.write("$key=$value&");
    });
    return "$cloakUrl?${stringBuffer.toString().substring(0,stringBuffer.toString().length-1)}";
  }

  @override
  adjustChangeToBuyUser() {
    TTTTHep.instance.pointEvent(PointName.organic_to_buy);
  }

  @override
  adjustEventCall(AdjustEventSuccess eventSuccessData) {

  }

  @override
  adjustResultCall(String network) {
    TTTTHep.instance.pointEvent(PointName.adjust_suc,params: {"adj_user":FlutterCheckAdjustCloak.instance.localAdjustIsBuyUser()==true?"1":"0"});
  }

  @override
  beforeRequestAdjust() {

  }

  @override
  firstRequestCloak() {
    TTTTHep.instance.pointEvent(PointName.cloak_req);
  }

  @override
  firstRequestCloakSuccess() {
    TTTTHep.instance.pointEvent(PointName.cloak_suc,params: {"cloak_user":FlutterCheckAdjustCloak.instance.localCloakIsNormalUser()==true?"1":"0"});
  }

  @override
  initFirebaseSuccess() {
    _getFirebaseConf();
  }

  _getFirebaseConf()async{
    var ad = await FlutterCheckAdjustCloak.instance.getFirebaseStrValue("kztym_ad_config");
    if(ad.isNotEmpty){
      localAdBean.putV(ad);
    }
    var small = await FlutterCheckAdjustCloak.instance.getFirebaseStrValue("qt_a_number");
    if(small.isNotEmpty&&valueConfBeanA.getV().isEmpty){
      valueConfBeanA.putV(small);
    }
    var large = await FlutterCheckAdjustCloak.instance.getFirebaseStrValue("qt_b_number");
    if(large.isNotEmpty&&valueConfBeanB.getV().isEmpty){
      valueConfBeanB.putV(large);
    }
    var s = await FlutterCheckAdjustCloak.instance.getFirebaseStrValue("float_dis");
    if(s.isNotEmpty){
      floatDismissSecond=s.toint(10);
    }
    tba_console=await FlutterCheckAdjustCloak.instance.getFirebaseStrValue("tba_console");

    var kwai_event = await FlutterCheckAdjustCloak.instance.getFirebaseStrValue("kwai_event");
    if(kwai_event.isNotEmpty){
      kwaiEventB.putV(kwai_event);
    }
  }
  
  @override
  startRequestAdjust() {
    TTTTHep.instance.pointEvent(PointName.adjust_req);
  }
}