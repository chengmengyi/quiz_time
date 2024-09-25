import 'dart:convert';
import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:quiztime55/b/hep/heppppp.dart';
import 'package:quiztime55/b/hep/info_hep.dart';
import 'package:quiztime55/global/appd/qt_save.dart';
import 'package:synchronized/synchronized.dart';

const QtSaveKey<String> valueConfBean = QtSaveKey(key: "valueConf", de: "");


class ValueHep{
  factory ValueHep()=>_getInstance();
  static ValueHep get instance=>_getInstance();
  static ValueHep? _instance;
  static ValueHep _getInstance(){
    _instance??=ValueHep._internal();
    return _instance!;
  }

  final Lock _lock = Lock();

  ValueB? _valueB;

  ValueHep._internal();

  var floatDismissSecond=10,tba_console="1";

  loadQtData() async {
    if(valueConfBean.getV().isNotEmpty){
      _valueB=ValueB.fromJson(jsonDecode(valueConfBean.getV()));
    }else{
      await _lock.synchronized(() async {
        var s = await rootBundle.loadString("qtf/f2/value.txt");
        _valueB=ValueB.fromJson(jsonDecode(_decode(s)));
      });
    }
  }

  int getNewUserCoins()=>_valueB?.newPrize??0;

  double getQuizCoins()=>_getRandomValueByList(_valueB?.quizPrize??[]);

  double getFloatCoins()=>_getRandomValueByList(_valueB?.floatPrize??[]);

  double getBoxCoins()=>_getRandomValueByList(_valueB?.boxPrize??[]);

  double getSignCoins()=>_getRandomValueByList(_valueB?.checkPrize??[]);

  List<int> getCashMoneyList()=>_valueB?.eqRange??[800,1000,1500,2000];

  int getBoxAddMaxCoins(){
    var list = _valueB?.boxPrize??[];
    if(list.isEmpty){
      return 1;
    }
    var userCoins = InfoHep.instance.userCoins;
    if(userCoins>=(list.last.endNumber??800)){
      return list.last.prize?.last??1;
    }
    for (var value in list) {
      if(userCoins>=(value.firstNumber??0)&&userCoins<(value.endNumber??800)){
        return value.prize?.last??1;
      }
    }
    return 1;
  }

  Task getTaskByIndex(int index){
    try{
      return (_valueB?.task??[])[index];
    }catch(e){
      return Task(title: "quiz",data: 50,time: 1);
    }
  }

  Task getTaskByTitle(String title){
    try{
      var list = _valueB?.task??[];
      var indexWhere = list.indexWhere((value)=>value.title==title);
      return list[indexWhere];
    }catch(e){
      return Task(title: "quiz",data: 50,time: 1);
    }
  }

  double _getRandomValueByList(List<QuizPrize> list){
    if(list.isEmpty){
      return 1.0;
    }
    var userCoins = InfoHep.instance.userCoins;
    var last = list.last;
    if(userCoins>=(last.endNumber??800)){
      return _getMaxMin(last.prize?.first??10, last.prize?.last??20);
    }
    for (var value in list) {
      if(userCoins>=(value.firstNumber??0)&&userCoins<(value.endNumber??800)){
        return _getMaxMin(value.prize?.first??10, value.prize?.last??20);
      }
    }
    return 1.0;
  }

  int getWheelAddNum(){
    var p5 = _valueB?.wheel?.point5??10;
    var p10 = _valueB?.wheel?.point10??80;
    var p20 = _valueB?.wheel?.point20??5;
    var p50 = _valueB?.wheel?.point50??4;
    var next = Random().nextInt(100);
    if(next<p5){
      return 5;
    }
    if(next>=p5&&next<(p5+p10)){
      return 10;
    }
    if(next>=(p5+p10)&&next<(p5+p10+p20)){
      return 20;
    }
    if(next>=(p5+p10+p20)&&next<(p5+p10+p20+p50)){
      return 50;
    }
    return 80;
  }

  bool canShowAdByType(AdType type){
    // if(kDebugMode){
    //   return false;
    // }
    List<IntadPoint> list = type==AdType.inter?(_valueB?.intadPoint??[]):type==AdType.reward?(_valueB?.rvadPoint??[]):[];
    if(list.isEmpty){
      return false;
    }
    var userCoins = InfoHep.instance.userCoins;
    if(userCoins>=(list.last.endNumber??800)){
      return Random().nextInt(100)<(list.last.point??0);
    }
    for(var v in list){
      if(userCoins>=(v.firstNumber??0)&&userCoins<(v.endNumber??0)){
        return Random().nextInt(100)<(v.point??0);
      }
    }
    return false;
  }

  double _getMaxMin(min,max)=>(Random().nextDouble()*(max-min)+min).toStringAsFixed(2).toDou();

  String _decode(String st) {
    List<int> bytes = base64Decode(st.replaceAll(RegExp(r'\s|\n'), ''));
    String result = utf8.decode(bytes);
    return result.replaceFirst(RegExp(r'\s|\n'), '', result.length - 1);
  }

  int getNextCashNum(){
    var list = getCashMoneyList();
    for (var value in list) {
      if(InfoHep.instance.userCoins<value){
        return value;
      }
    }
    return list.last;
  }

  double getToCashEarnNum(){
    var nextCashNum = getNextCashNum();
    if(InfoHep.instance.userCoins>=nextCashNum){
      return 0;
    }
    var result = (Decimal.fromInt(nextCashNum)-Decimal.parse("${InfoHep.instance.userCoins}")).toDouble();
    if(result<=0){
      return 0;
    }
    return result;
  }

  getFirebaseConfig()async{
    var value = await FlutterCheckAdjustCloak.instance.getFirebaseStrValue("qt_number");
    if(value.isNotEmpty&&valueConfBean.getV().isEmpty){
      valueConfBean.putV(value);
      loadQtData();
    }
    var s = await FlutterCheckAdjustCloak.instance.getFirebaseStrValue("float_dis");
    if(s.isNotEmpty){
      floatDismissSecond=s.toint(10);
    }
    tba_console=await FlutterCheckAdjustCloak.instance.getFirebaseStrValue("tba_console");
  }
}


class ValueB {
  ValueB({
    this.eqRange,
    this.newPrize,
    this.intadPoint,
    this.rvadPoint,
    this.quizPrize,
    this.floatPrize,
    this.boxPrize,
    this.wheel,
    this.task,
    this.checkPrize,});

  ValueB.fromJson(dynamic json) {
    eqRange = json['eq_range'] != null ? json['eq_range'].cast<int>() : [];
    newPrize = json['new_prize'];
    if (json['intad_point'] != null) {
      intadPoint = [];
      json['intad_point'].forEach((v) {
        intadPoint?.add(IntadPoint.fromJson(v));
      });
    }
    if (json['rvad_point'] != null) {
      rvadPoint = [];
      json['rvad_point'].forEach((v) {
        rvadPoint?.add(IntadPoint.fromJson(v));
      });
    }
    if (json['quiz_prize'] != null) {
      quizPrize = [];
      json['quiz_prize'].forEach((v) {
        quizPrize?.add(QuizPrize.fromJson(v));
      });
    }
    if (json['float_prize'] != null) {
      floatPrize = [];
      json['float_prize'].forEach((v) {
        floatPrize?.add(QuizPrize.fromJson(v));
      });
    }
    if (json['box_prize'] != null) {
      boxPrize = [];
      json['box_prize'].forEach((v) {
        boxPrize?.add(QuizPrize.fromJson(v));
      });
    }
    wheel = json['wheel'] != null ? Wheel.fromJson(json['wheel']) : null;

    if (json['tixian_task'] != null) {
      task = [];
      json['tixian_task'].forEach((v) {
        task?.add(Task.fromJson(v));
      });
    }

    if (json['check_prize'] != null) {
      checkPrize = [];
      json['check_prize'].forEach((v) {
        checkPrize?.add(QuizPrize.fromJson(v));
      });
    }
  }
  List<int>? eqRange;
  int? newPrize;
  List<IntadPoint>? intadPoint;
  List<IntadPoint>? rvadPoint;
  List<QuizPrize>? quizPrize;
  List<QuizPrize>? floatPrize;
  List<QuizPrize>? boxPrize;
  Wheel? wheel;
  List<Task>? task;
  List<QuizPrize>? checkPrize;
}

class Task {
  Task({
    this.title,
    this.data,
    this.time,});

  Task.fromJson(dynamic json) {
    title = json['title'];
    data = json['data'];
    time = json['time'];
  }
  String? title;
  int? data;
  int? time;
}

class Wheel {
  Wheel({
    this.point5,
    this.point10,
    this.point20,
    this.point50,
    this.point80,
    this.iphonePoint,});

  Wheel.fromJson(dynamic json) {
    point5 = json['point_5'];
    point10 = json['point_10'];
    point20 = json['point_20'];
    point50 = json['point_50'];
    point80 = json['point_80'];
    iphonePoint = json['iphone_point'];
  }
  int? point5;
  int? point10;
  int? point20;
  int? point50;
  int? point80;
  int? iphonePoint;
}

class QuizPrize {
  QuizPrize({
    this.firstNumber,
    this.prize,
    this.endNumber,});

  QuizPrize.fromJson(dynamic json) {
    firstNumber = json['first_number'];
    prize = json['prize'] != null ? json['prize'].cast<int>() : [];
    endNumber = json['end_number'];
  }
  int? firstNumber;
  List<int>? prize;
  int? endNumber;

}

class IntadPoint {
  IntadPoint({
    this.firstNumber,
    this.point,
    this.endNumber,
  });

  IntadPoint.fromJson(dynamic json) {
    firstNumber = json['first_number'];
    point = json['point'];
    endNumber = json['end_number'];
  }
  int? firstNumber;
  int? point;
  int? endNumber;

}