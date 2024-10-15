import 'dart:convert';
import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_base/hep/sql/pay_type.dart';



export 'package:flutter_screenutil/flutter_screenutil.dart';
export 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
export 'package:decimal/decimal.dart';
export 'package:get/get.dart';
export 'package:adjust_sdk/adjust.dart';
export 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
export 'package:url_launcher/url_launcher.dart';
export 'package:flutter_tba_info/flutter_tba_info.dart';
export 'package:flutter_max_ad/flutter_max_ad.dart';
export 'package:flutter_max_ad/ad/ad_type.dart';

const String adjustToken="t1x2a22x1kow";
const String maxKeyBase64="TVdKemhuRVB0S3F4TEtSTEFsVnJUeVFmTzJWeFdaV3RWeF9TelRXQ19NZ29aTDdrVEtOdDl0M01fT2dJWjI0bkJYUlh4VmQ5b2dRRXA3NjE2VFdmM0M=";
const String tbaUrl="https://lipstick.quizrightanswer.com/habitant/simper/argive";
const String cloakUrl="https://doctrine.quizrightanswer.com/further/tyler";
const String toponId="YTY3MDhlMDAwNzIxYjQ=";
const String toponKey="YTQ3N2FjMWRiZjE1N2Q5MWM2MTY3MGEwMjJlYmU0YWU3";


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

double douAdd(double d1,double d2)=>(Decimal.parse("$d1")+Decimal.parse("$d2")).toDouble();

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
    if(this==PayType.pix.name){
      return PayType.pix;
    }
    if(this==PayType.pagbank.name){
      return PayType.pagbank;
    }
    if(this==PayType.zalo.name){
      return PayType.zalo;
    }
    if(this==PayType.momo.name){
      return PayType.momo;
    }
    if(this==PayType.ovo.name){
      return PayType.ovo;
    }
    if(this==PayType.dana.name){
      return PayType.dana;
    }
    if(this==PayType.truemoney.name){
      return PayType.truemoney;
    }
    if(this==PayType.gcash.name){
      return PayType.gcash;
    }
    if(this==PayType.coins.name){
      return PayType.coins;
    }
    if(this==PayType.yoomoney.name){
      return PayType.yoomoney;
    }
    return PayType.paypal;
  }
}

String strBase64Decode(String st) {
  List<int> bytes = base64Decode(st.replaceAll(RegExp(r'\s|\n'), ''));
  String result = utf8.decode(bytes);
  return result.replaceFirst(RegExp(r'\s|\n'), '', result.length - 1);
}

getBgDecorationImage(String name) => DecorationImage(image: AssetImage("qtf/f1/$name.webp"), fit: BoxFit.fill);

getMaterialRoute(Widget page) => MaterialPageRoute(
  settings: const RouteSettings(),
  builder: (context) => page,
);

int getMoneyByCountryAndConversion(int coins,int conversion){
  var money = coins/conversion;
  var d = money*getRate();
  return d.toInt();
}

String getMoneyCode(){
  var code = Get.deviceLocale?.countryCode??"US";
  switch(code){
    case "BR": return "R\$";
    case "VN": return "₫";
    case "ID": return "Rp";
    case "TH": return "฿";
    case "RU": return "₽";
    case "PH": return "₱";
    default: return "\$";
  }
}

int getRate(){
  var code = Get.deviceLocale?.countryCode??"US";
  switch(code){
    case "BR": return 10;
    case "VN": return 10000;
    case "ID": return 10000;
    case "TH": return 10;
    case "PH": return 100;
    case "RU": return 100;
    default: return 1;
  }
}

extension Tihuan on String{
  String tihuan(value){
    return this.replaceAll("tihuan", "$value");
  }
}

String formatCoins(double coins){
  var format = NumberFormat.currency(
    locale: Get.deviceLocale?.toString(),
    symbol: "",
  ).format(coins);
  return format;
}

String moneyDou2Str(double money){
  var decimal = (Decimal.fromInt(getRate())*Decimal.parse("$money")).toDouble();
  var format = NumberFormat.currency(
    locale: Get.deviceLocale?.toString(),
    symbol: "",
  ).format(decimal);
  var code = Get.deviceLocale?.countryCode??"US";
  if(code=="RU"||code=="VN"){
    return "$format${getMoneyCode()}";
  }
  return "${getMoneyCode()}$format";
}