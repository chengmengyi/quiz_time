import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:quiztime55/b/dia/get_coins.dart';
import 'package:quiztime55/b/hep/call_listener/call_listener_hep.dart';
import 'package:quiztime55/b/hep/heppppp.dart';
import 'package:quiztime55/b/hep/sql/pay_type.dart';
import 'package:quiztime55/b/hep/tttt/point_name.dart';
import 'package:quiztime55/b/hep/tttt/tttt_hep.dart';
import 'package:quiztime55/global/appd/qt_save.dart';

const QtSaveKey<double> coinsBean = QtSaveKey(key: "coinsBean", de: 0.0);
const QtSaveKey<String> progressReceivedBean = QtSaveKey(key: "progressReceived", de: "");
const QtSaveKey<bool> receivedBubbleBean = QtSaveKey(key: "receivedBubble", de: false);
const QtSaveKey<String> payTypeIndexBean = QtSaveKey(key: "payTypeIndex", de: "paypal");
const QtSaveKey<int> chooseMoneyIndexBean = QtSaveKey(key: "chooseMoneyIndex", de: 0);


const QtSaveKey<int> receivedCoinsStepsBean = QtSaveKey(key: "receivedCoinsSteps", de: 0);
const QtSaveKey<int> watchAdNumBean = QtSaveKey(key: "watchAdNumBean", de: 0);
const QtSaveKey<int> receivedAdNumStepsBean = QtSaveKey(key: "receivedAdNumSteps", de: 0);

class InfoHep{
  factory InfoHep()=>_getInstance();
  static InfoHep get instance=>_getInstance();
  static InfoHep? _instance;
  static InfoHep _getInstance(){
    _instance??=InfoHep._internal();
    return _instance!;
  }

  var userCoins=0.0;
  final List<String> _progressReceivedList=[];

  InfoHep._internal(){
    userCoins=coinsBean.getV();
    _initProgressReceivedList();
  }

  addCoins(double add){
    userCoins=(Decimal.parse("$add")+Decimal.parse("$userCoins")).toDouble();
    if(add>0){
      var v = receivedCoinsStepsBean.getV()+100;
      if(userCoins>=v){
        TTTTHep.instance.pointEvent(PointName.cash_money_detail,params: {"money_from":v});
        receivedCoinsStepsBean.putV(v);
      }

      GetCoinsDialog(
        addNum: add,
        dismissDialog: (){
          CallListenerHep.instance.showCoinsAnimator(userCoins);
        },
      ).show(barrierColor: Colors.transparent);
    }else{
      coinsBean.putV(userCoins);
    }
  }

  _initProgressReceivedList(){
    try{
      _progressReceivedList.clear();
      _progressReceivedList.addAll(progressReceivedBean.getV().split("|"));
    }catch(e){

    }
  }

  updateProgressReceivedList(int index){
    _progressReceivedList.add("$index");
    progressReceivedBean.putV(_progressReceivedList.join("|"));
  }

  bool checkProgressReceived(int index)=>_progressReceivedList.contains("$index");

  updateWatchAdNum(){
    watchAdNumBean.putV(watchAdNumBean.getV()+1);
    var v = receivedAdNumStepsBean.getV()+5;
    if(watchAdNumBean.getV()>=v){
      TTTTHep.instance.pointEvent(PointName.cash_ad_detail,params: {"ad_from":v});
      receivedAdNumStepsBean.putV(v);
    }
  }
}