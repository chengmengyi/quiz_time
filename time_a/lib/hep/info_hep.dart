import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:time_a/dia/get_coins.dart';
import 'package:time_a/hep/call_listener/call_listener_hep.dart';
import 'package:time_base/hep/heppppp.dart';
import 'package:time_base/hep/save/qt_save.dart';

const QtSaveKey<double> coinsBean = QtSaveKey(key: "coinsBeanA", de: 0.0);
const QtSaveKey<String> progressReceivedBean = QtSaveKey(key: "progressReceivedA", de: "");
const QtSaveKey<bool> receivedBubbleBean = QtSaveKey(key: "receivedBubbleA", de: false);
const QtSaveKey<String> payTypeIndexBean = QtSaveKey(key: "payTypeIndexA", de: "paypal");
const QtSaveKey<int> chooseMoneyIndexBean = QtSaveKey(key: "chooseMoneyIndexA", de: 0);


const QtSaveKey<int> receivedCoinsStepsBean = QtSaveKey(key: "receivedCoinsStepsA", de: 0);
const QtSaveKey<int> watchAdNumBean = QtSaveKey(key: "watchAdNumBeanA", de: 0);
const QtSaveKey<int> receivedAdNumStepsBean = QtSaveKey(key: "receivedAdNumStepsA", de: 0);

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
      receivedAdNumStepsBean.putV(v);
    }
  }
}