import 'dart:io';

import 'package:flutter_tba_info/flutter_tba_info.dart';

class BaseTttt{
  String? frizzy;
  String? eleventh;
  String? hetty;
  int? onondaga;
  String? forsaken;
  String? dragoon;
  String? contrary;
  String? tort;
  String? belate;
  String? monogamy;
  String? pipette;
  String? opossum;
  String? gas;
  String? sistine;
  String? passbook;
  String? bypath;
  String? mocha;
  String? bangkok;

  createData(String logId)async{
    frizzy=await FlutterTbaInfo.instance.getSystemLanguage();
    eleventh=await FlutterTbaInfo.instance.getOsCountry();
    hetty=await FlutterTbaInfo.instance.getAndroidId();
    onondaga=DateTime.now().millisecondsSinceEpoch;
    forsaken=await FlutterTbaInfo.instance.getDistinctId();
    dragoon=await FlutterTbaInfo.instance.getManufacturer();
    contrary=logId;
    tort=await FlutterTbaInfo.instance.getBrand();
    belate=await FlutterTbaInfo.instance.getAppVersion();
    monogamy=await FlutterTbaInfo.instance.getOperator();
    pipette=Platform.isAndroid?"mermaid":"combat";
    opossum=await FlutterTbaInfo.instance.getNetworkType();
    gas=await FlutterTbaInfo.instance.getIdfv();
    sistine=await FlutterTbaInfo.instance.getBundleId();
    passbook=await FlutterTbaInfo.instance.getOsVersion();
    bypath=await FlutterTbaInfo.instance.getDeviceModel();
    mocha=await FlutterTbaInfo.instance.getGaid();
    bangkok=await FlutterTbaInfo.instance.getIdfa();
  }

  Map<String,dynamic> toJson()=>{
    "frizzy":frizzy,
    "eleventh":eleventh,
    "hetty":hetty,
    "onondaga":onondaga,
    "forsaken":forsaken,
    "dragoon":dragoon,
    "contrary":contrary,
    "tort":tort,
    "belate":belate,
    "monogamy":monogamy,
    "pipette":pipette,
    "opossum":opossum,
    "gas":gas,
    "sistine":sistine,
    "passbook":passbook,
    "bypath":bypath,
    "mocha":mocha,
    "bangkok":bangkok,
  };
}