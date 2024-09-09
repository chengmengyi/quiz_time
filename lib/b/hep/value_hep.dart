import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:quiztime55/b/hep/heppppp.dart';
import 'package:quiztime55/b/hep/info_hep.dart';
import 'package:synchronized/synchronized.dart';

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

  loadQtData() async {
    await _lock.synchronized(() async {
      var s = await rootBundle.loadString("qtf/f2/value.txt");
      _valueB=ValueB.fromJson(jsonDecode(_decode(s)));
    });
  }

  int getNewUserCoins()=>_valueB?.newPrize??0;

  double getQuizCoins()=>_getRandomValueByList(_valueB?.quizPrize??[]);

  double getFloatCoins()=>_getRandomValueByList(_valueB?.floatPrize??[]);

  double getBoxCoins()=>_getRandomValueByList(_valueB?.boxPrize??[]);

  double getSignCoins()=>_getRandomValueByList(_valueB?.checkPrize??[]);

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

  double _getMaxMin(min,max)=>(Random().nextDouble()*(max-min)+min).toStringAsFixed(2).toDou();

  String _decode(String st) {
    List<int> bytes = base64Decode(st.replaceAll(RegExp(r'\s|\n'), ''));
    String result = utf8.decode(bytes);
    return result.replaceFirst(RegExp(r'\s|\n'), '', result.length - 1);
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
    task = json['task'] != null ? Task.fromJson(json['task']) : null;
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
  Task? task;
  List<QuizPrize>? checkPrize;
}

class Task {
  Task({
    this.video,
    this.box,
    this.wheel,
    this.float,
    this.check,});

  Task.fromJson(dynamic json) {
    video = json['video'];
    box = json['box'];
    wheel = json['wheel'];
    float = json['float'];
    check = json['check'];
  }
  int? video;
  int? box;
  int? wheel;
  int? float;
  int? check;
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