import 'dart:convert';
import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:quiztime55/b/hep/sql/pay_type.dart';



const String adjustToken="3r5rp9ktzv5s";
const String maxKeyBase64="TVdKemhuRVB0S3F4TEtSTEFsVnJUeVFmTzJWeFdaV3RWeF9TelRXQ19NZ29aTDdrVEtOdDl0M01fT2dJWjI0bkJYUlh4VmQ5b2dRRXA3NjE2VFdmM0M=";
const String tbaUrl="https://play.quizrightanswer.com/fission/swig";
const String cloakUrl="https://joke.quizrightanswer.com/effort/phoneme/clerk";


extension Str2Dou on String{
  double toDou(){
    try{
      return double.parse(this);
    }catch(e){
      return 0.0;
    }
  }
}

extension Doux2 on double{
  double tox2()=>(Decimal.parse("$this")*Decimal.fromInt(2)).toDouble();
}

double douAdd(double d1,double d2)=>(Decimal.parse("$d1")*Decimal.parse("$d2")).toDouble();

String getTodayStr(){
  var time = DateTime.now();
  return "${time.month}-${time.day} ${time.year}";
}

extension RanIntList on List<int>{
  int getRandom()=>this[Random().nextInt(length)];
}


extension RanStrList on List<String>{
  String getRandom()=>this[Random().nextInt(length)];
}

extension Str2Int on String{
  int toint(int defaultNum){
    try{
      return int.parse(this);
    }catch(e){
      return defaultNum;
    }
  }
}

extension ShowDialog on Widget{
  show({Color? barrierColor}){
    Get.dialog(
        this,
        barrierColor: barrierColor??Colors.black.withOpacity(0.8),
        barrierDismissible: false,
        useSafeArea: true
    );
  }
}

extension Toast on String{
  toast(){
    if(isEmpty){
      return;
    }
    Fluttertoast.showToast(
      msg: this,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black45,
      textColor: Colors.white,
      fontSize: 16.sp
    );
  }
}

closeDialog(){
  Get.back();
}

extension Str2PayType on String{
  //  paypal,amazon,gp,mastercard,cashApp,webMoney,
  PayType toPayType(){
    if(this==PayType.paypal.name){
      return PayType.paypal;
    }
    if(this==PayType.amazon.name){
      return PayType.amazon;
    }
    if(this==PayType.gp.name){
      return PayType.gp;
    }
    if(this==PayType.mastercard.name){
      return PayType.mastercard;
    }
    if(this==PayType.cashApp.name){
      return PayType.cashApp;
    }
    if(this==PayType.webMoney.name){
      return PayType.webMoney;
    }
    return PayType.paypal;
  }
}

String strBase64Decode(String st) {
  List<int> bytes = base64Decode(st.replaceAll(RegExp(r'\s|\n'), ''));
  String result = utf8.decode(bytes);
  return result.replaceFirst(RegExp(r'\s|\n'), '', result.length - 1);
}
