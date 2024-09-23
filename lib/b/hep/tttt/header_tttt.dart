import 'package:flutter_tba_info/flutter_tba_info.dart';

class HeaderTTTT{
  String? passbook;
  String? dragoon;
  int? onondaga;

  createData()async{
    passbook=await FlutterTbaInfo.instance.getOsVersion();
    dragoon=await FlutterTbaInfo.instance.getManufacturer();
    onondaga=DateTime.now().millisecondsSinceEpoch;
  }

  Map<String,dynamic> toJson()=>{
    "passbook":passbook,
    "dragoon":dragoon,
    "onondaga":onondaga,
  };
}