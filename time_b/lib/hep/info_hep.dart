import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:time_b/dia/get_coins.dart';
import 'package:time_b/hep/call_listener/call_listener_hep.dart';
import 'package:time_b/hep/value_hep.dart';
import 'package:time_base/hep/heppppp.dart';
import 'package:time_base/hep/notification/notification_hep.dart';
import 'package:time_base/hep/save/qt_save.dart';
import 'package:time_base/hep/tttt/point_name.dart';
import 'package:time_base/hep/tttt/tttt_hep.dart';

const QtSaveKey<double> coinsBean = QtSaveKey(key: "coinsBeanB", de: 0.0);
const QtSaveKey<String> progressReceivedBean = QtSaveKey(key: "progressReceivedB", de: "");
const QtSaveKey<bool> receivedBubbleBean = QtSaveKey(key: "receivedBubbleB", de: false);
const QtSaveKey<String> payTypeIndexBean = QtSaveKey(key: "payTypeIndexB", de: "paypal");
const QtSaveKey<int> chooseMoneyIndexBean = QtSaveKey(key: "chooseMoneyIndexB", de: 0);


const QtSaveKey<int> receivedCoinsStepsBean = QtSaveKey(key: "receivedCoinsStepsB", de: 0);
const QtSaveKey<int> watchAdNumBean = QtSaveKey(key: "watchAdNumBeanB", de: 0);
const QtSaveKey<int> receivedAdNumStepsBean = QtSaveKey(key: "receivedAdNumStepsB", de: 0);

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
      NotificationHep.instance.updateForegroundData(userCoins);
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