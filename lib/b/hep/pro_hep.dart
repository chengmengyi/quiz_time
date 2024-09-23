import 'package:flutter/material.dart';
import 'package:quiztime55/b/dia/incent.dart';
import 'package:quiztime55/b/dia/wheel.dart';
import 'package:quiztime55/b/hep/heppppp.dart';
import 'package:quiztime55/b/hep/info_hep.dart';
import 'package:quiztime55/b/hep/quiz_hep.dart';
import 'package:quiztime55/b/hep/sql/sql_hep.dart';
import 'package:quiztime55/b/hep/task/task_hep.dart';
import 'package:quiztime55/b/hep/tttt/point_name.dart';
import 'package:quiztime55/b/hep/tttt/tttt_hep.dart';
import 'package:quiztime55/b/hep/value_hep.dart';
import 'package:quiztime55/b/overlay/progress_box_over.dart';
import 'package:quiztime55/b/overlay/progress_wheel_over.dart';
import 'package:quiztime55/global/appd/qt_quiz_hep.dart';

class ProHep{
  factory ProHep()=>_getInstance();
  static ProHep get instance=>_getInstance();
  static ProHep? _instance;
  static ProHep _getInstance(){
    _instance??=ProHep._internal();
    return _instance!;
  }

  List<ProBean> progressList=[];
  OverlayEntry? _overlayEntry;

  ProHep._internal(){
    progressList.clear();
    var length = QtQuizHep.getQuizAllLength();
    for(int index=0;index<length;index++){
      progressList.add(_createProBean(index));
    }
  }

  ProBean _createProBean(index){
    var rightNum = QuizHep.instance.answerRightNum;
    if(index==0){
      return ProBean(index: index, color: false, proEnum: ProEnum.normal);
    }
    if(index==1){
      return ProBean(index: index, color: rightNum>index, proEnum: ProEnum.box);
    }
    if((index-7)%9==0){
      return ProBean(index: index, color: rightNum>index, proEnum: ProEnum.wheel);
    }
    if((index-1)%3==0){
      return ProBean(index: index, color: rightNum>index, proEnum: ProEnum.box);
    }
    return ProBean(index: index, color: false, proEnum: ProEnum.normal);
  }

  updateProgress(){
    progressList[QuizHep.instance.answerRightNum-1]=_createProBean(QuizHep.instance.answerRightNum-1);
    var indexWhere = progressList.indexWhere((value)=>value.showFinger);
    if(QuizHep.instance.answerRightNum==2||QuizHep.instance.answerRightNum==8){
      return;
    }
    if(indexWhere<0){
      for(var index=0;index<progressList.length;index++){
        progressList[index].showFinger=progressList[index].color&&!InfoHep.instance.checkProgressReceived(index);
      }
    }
  }

  bool showFirstBoxOverlay({required BuildContext context,required GlobalKey globalKey}){
    var proBean = progressList[1];
    if(proBean.color&&!InfoHep.instance.checkProgressReceived(1)){
      var renderBox = globalKey.currentContext!.findRenderObject() as RenderBox;
      var offset = renderBox.localToGlobal(Offset.zero);
      TTTTHep.instance.pointEvent(PointName.box_guide);
      showOverlay(
        context: context,
        widget: ProgressBoxOver(
          offset: offset,
          dismissOver: (){
            clickProgressItem(1,true);
          },
        ),
      );
      return true;
    }
    return false;
  }

  bool showFirstWheelOverlay({required BuildContext context,required GlobalKey globalKey}){
    var proBean = progressList[7];
    if(proBean.color&&!InfoHep.instance.checkProgressReceived(7)){
      var renderBox = globalKey.currentContext!.findRenderObject() as RenderBox;
      var offset = renderBox.localToGlobal(Offset.zero);
      TTTTHep.instance.pointEvent(PointName.wheel_guide);
      showOverlay(
        context: context,
        widget: ProgressWheelOver(
          offset: offset,
          dismissOver: (){
            clickProgressItem(7,false,from: WheelFrom.answer8Guide);
          },
        ),
      );
      return true;
    }
    return false;
  }

  clickProgressItem(int index,bool box,{WheelFrom from=WheelFrom.progress}){
    if(progressList[index].color){
      if(InfoHep.instance.checkProgressReceived(index)){
        (box?"Today’s treasure chest reward has been collected":"The wheel reward has been received").toast();
        return;
      }
      if(box){
        SqlHep.instance.updateTaskCompletedNumRecord(TaskType.box);
        Incent(
          incentFrom: IncentFrom.box,
          add: ValueHep.instance.getBoxCoins(),
          dismissCall: (){
            InfoHep.instance.updateProgressReceivedList(index);
          },
        ).show();
      }else{
        SqlHep.instance.updateTaskCompletedNumRecord(TaskType.spin);
        WheelDialog(
          wheelFrom: from,
          dismissDialog: (addNum){
            if(from==WheelFrom.answer8Guide){
              InfoHep.instance.updateProgressReceivedList(index);
              InfoHep.instance.addCoins(addNum);
            }
            if(from==WheelFrom.progress){
              Incent(
                add: addNum,
                incentFrom: IncentFrom.wheel,
                dismissCall: (){
                  InfoHep.instance.updateProgressReceivedList(index);
                },
              ).show();
            }
          },
        ).show();
      }
    }
  }

  showOverlay({required BuildContext context,required Widget widget}){
    _overlayEntry=OverlayEntry(builder: (_)=>widget);
    Overlay.of(context).insert(_overlayEntry!);
  }

  hideOverlay(){
    _overlayEntry?.remove();
    _overlayEntry=null;
  }
}

class ProBean{
  int index;
  bool color;
  ProEnum proEnum;
  bool showFinger;

  ProBean({
    required this.index,
    required this.color,
    required this.proEnum,
    this.showFinger=false,
  });
}

enum ProEnum{
  normal,box,wheel
}