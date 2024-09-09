import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

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

extension ShowDialog on Widget{
  show(){
    Get.dialog(
        this,
        barrierColor: Colors.black.withOpacity(0.8),
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
