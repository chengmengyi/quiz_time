import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiztime55/b/dia/cash_guide.dart';
import 'package:quiztime55/b/dia/incent.dart';
import 'package:quiztime55/b/dia/old_user.dart';
import 'package:quiztime55/b/dia/sign_incent.dart';
import 'package:quiztime55/b/dia/wheel.dart';
import 'package:quiztime55/b/dia/wheel_incent.dart';
import 'package:quiztime55/b/hep/guide_hep.dart';
import 'package:quiztime55/b/hep/heppppp.dart';
import 'package:quiztime55/b/hep/pro_hep.dart';
import 'package:quiztime55/b/hep/quiz_hep.dart';
import 'package:quiztime55/b/hep/value_hep.dart';
import 'package:quiztime55/b/home/bubble_w.dart';
import 'package:quiztime55/b/home/finger_w.dart';
import 'package:quiztime55/b/home/top_coins_w.dart';
import 'package:quiztime55/global/pop/d_pop.dart';
import 'package:quiztime55/global/widg/qt_image.dart';
import 'package:quiztime55/global/widg/ws_text.dart';

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> implements GuideListener{
  var _quizResult=-1,_showBubble=false;
  final GlobalKey _answerAGlobalKey=GlobalKey();
  final GlobalKey _answerBGlobalKey=GlobalKey();
  final GlobalKey _firstProgressBoxGlobalKey=GlobalKey();
  final GlobalKey _firstProgressWheelGlobalKey=GlobalKey();
  Offset? _rightAnswerOffset;
  Map<String, dynamic>? _quizMap={};
  Timer? _rightAnswerTimer;

  @override
  void initState() {
    super.initState();
    _initCurQuizMap();
    answerRightBean.listen((v){
      _updateProgressList();
    });
    GuideHep.instance.setGuideListener(this);
    Future((){
      GuideHep.instance.showGuide();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        const QtImage("qwfef",w: double.infinity,h: double.infinity,),
        SafeArea(
          top: true,
          child: Column(
            children: [
              _topWidget(),
              SizedBox(height: 10.h,),
              _progressWidget(),
              Expanded(
                child: _contentWidget(context),
              ),
              _bottomWidget(),
            ],
          ),
        ),
        _fingerWidget(),
        _showBubble?BubbleW():Container(),
      ],
    ),
  );

  _topWidget()=>Row(
    children: [
      SizedBox(width: 12.w,),
      TopCoinsW(),
      const Spacer(),
      InkWell(
        child: QtImage("gewrger",w: 24.w,h: 24.w,),
      ),
      SizedBox(width: 12.w,),
    ],
  );

  _progressWidget()=>SizedBox(
    width: double.infinity,
    height: 68.h,
    child: Stack(
      children: [
        QtImage("ffasfdsf",w: double.infinity,h: 68.h,),
        Container(
          width: double.infinity,
          height: 50.h,
          margin: EdgeInsets.only(left: 25.w,right: 25.w,top: 8.h ),
          child: ListView.builder(
            itemCount: ProHep.instance.progressList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context,index){
              var proBean = ProHep.instance.progressList[index];
              return SizedBox(
                key: index==1?_firstProgressBoxGlobalKey:index==7?_firstProgressWheelGlobalKey:null,
                child: _getProgressItemWidget(proBean,index),
              );
            },
          ),
        )
      ],
    ),
  );

  _getProgressItemWidget(ProBean proBean,index){
    var last = index==ProHep.instance.progressList.length-1;
    switch(proBean.proEnum){
      case ProEnum.normal: return _normalProgressWidget(index,last);
      case ProEnum.box:
        if(proBean.color){
          return _colorProgressWidget(index,true,proBean.showFinger);
        }else{
          return _greyProgressWidget(index,true);
        }
      case ProEnum.wheel:
        if(proBean.color){
          return _colorProgressWidget(index,false,proBean.showFinger);
        }else{
          return _greyProgressWidget(index,false);
        }
    }
  }

  _normalProgressWidget(index,last)=>Container(
    width: 10.w,
    height: 32.h,
    alignment: Alignment.topLeft,
    child: Container(
      width: 10.w,
      height: 16.h,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.only(left: index==0?2.w:0),
      decoration: BoxDecoration(
        color: const Color(0xffAF621E),
        borderRadius: BorderRadius.only(
          topLeft: index==0?Radius.circular(8.w):Radius.zero,
          bottomLeft: index==0?Radius.circular(8.w):Radius.zero,
          topRight: last?Radius.circular(8.w):Radius.zero,
          bottomRight: last?Radius.circular(8.w):Radius.zero,
        ),
      ),
      child: Container(
        width: 10.w,
        height: QuizHep.instance.answerRightNum>index?12.h:0,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffFFF3C8),Color(0xffFFE142)],
          ),
          borderRadius: BorderRadius.only(
            topLeft: index==0?Radius.circular(6.w):Radius.zero,
            bottomLeft: index==0?Radius.circular(6.w):Radius.zero,
            topRight: last?Radius.circular(6.w):Radius.zero,
            bottomRight: last?Radius.circular(6.w):Radius.zero,
          ),
        ),
      ),
    ),
  );

  _greyProgressWidget(index,box)=>SizedBox(
    width: 50.w,
    height: 50.h,
    child: Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: 50.w,
          height: 16.h,
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(top: 8.h),
          decoration: const BoxDecoration(
            color: Color(0xffAF621E),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QtImage(box?"wwdwf":"wfjewf",w: 32.w,h: 32.h,),
            QtText("${index+1}", fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.w500),
          ],
        )
      ],
    ),
  );

  _colorProgressWidget(index,box,showFinger)=>InkWell(
    onTap: (){
      ProHep.instance.clickProgressItem(index, box);
    },
    child: SizedBox(
      width: 50.w,
      height: 50.h,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: 50.w,
            height: 16.h,
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 8.h),
            decoration: const BoxDecoration(
              color: Color(0xffAF621E),
            ),
            child: Container(
              width: 50.w,
              height: 12.h,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xffFFF3C8),Color(0xffFFE142)],
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QtImage(box?"fswfsfew":"erefetet",w: 32.w,h: 32.h,),
              QtText("${index+1}", fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.w500),
            ],
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Offstage(
              offstage: !showFinger,
              child: FingerW(width: 40.w,height: 40.w,),
            ),
          )
        ],
      ),
    ),
  );

  _contentWidget(BuildContext context)=>Stack(
    alignment: Alignment.topCenter,
    children: [
      const QtImage("fwefewd",w: double.infinity,fit: BoxFit.fitWidth,),
      Container(
        margin: EdgeInsets.only(top: 20.h),
        child: InkWell(
          onTap: (){
            test();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              QtImage("fwefweg",w: 240.w,h: 48.h,),
              QtText(
                "History",
                fontSize: 16.sp,
                color: const Color(0xffFFF1CD),
                fontWeight: FontWeight.w600,
                shadows: [Shadow(color: const Color(0xFFD03938), blurRadius: 1.w, offset: Offset(0, 2.w))],
              ),
            ],
          ),
        ),
      ),
      Container(
        width: double.infinity,
        height: 200.h,
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 50.w,right: 50.w,top: 92.h),
        child: QtText(
          _quizMap?["qtq"]??"",
          fontSize: 16.sp,
          color: const Color(0xff774607),
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.center,
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _answerItemWidget(0),
            SizedBox(height: 20.h,),
            _answerItemWidget(1),
            SizedBox(height: 78.h,)
          ],
        ),
      )
    ],
  );

  _answerItemWidget(index){
    var bg="answer_normal",icon="";
    if(index==_quizResult){
      var qt_res = _quizMap?["qt_res"];
      if((_quizResult==0&&qt_res=="a")||(_quizResult==1&&qt_res=="b")){
        icon="gou";
        bg="answer_right";
      }else{
        icon="cha";
        bg="answer_fail";
      }
    }
    return InkWell(
      onTap: (){
        _clickAnswer(index,context);
      },
      child: SizedBox(
        width: 240.w,
        height: 44.h,
        key: index==0?_answerAGlobalKey:_answerBGlobalKey,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            QtImage(
              bg,
              w: 240.w,
              h: 44.h,
            ),
            Row(
              children: [
                SizedBox(width: 16.w,),
                Expanded(
                  child: QtText(
                    "${index==0?"A":"B"}.${_quizMap?[index==0?"qt_a":"qt_b"]}",
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    maxLines: 2,
                  ),
                ),
                icon.isEmpty?const SizedBox():QtImage(icon,w: 24.w,h: 24.h,),
                SizedBox(width: 16.w,),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  _bottomWidget()=>Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      QtImage("mfiev",w: 108.w,h: 64.h,),
      SizedBox(width: 16.w,),
      QtImage("fewjofjew",w: 108.w,h: 64.h,),
    ],
  );

  _fingerWidget()=>null==_rightAnswerOffset?
  Container():
  Container(
    margin: EdgeInsets.only(top: (_rightAnswerOffset?.dy??0)+22.h,left: (_rightAnswerOffset?.dx??0)+200.w),
    child: FingerW(),
  );

  _initCurQuizMap(){
    _quizMap=QuizHep.instance.getCurQuizMap();
    _delayShowRightAnswerFinger();
  }

  _clickAnswer(index,context){
    if(_quizResult!=-1){
      return;
    }
    _stopRightAnswerTimer();
    var qt_res = _quizMap?["qt_res"];
    setState(() {
      _rightAnswerOffset=null;
      _quizResult=index;
    });
    var result = (_quizResult==0&&qt_res=="a")||(_quizResult==1&&qt_res=="b");
    if(result){
      QuizHep.instance.updateAnswerRight();
    }
    Future.delayed(const Duration(milliseconds: 800),(){
      _quizResult=-1;
      if(result){
        if(newGuideBean.getV()==NewUserGuideStep.rightAnswerFinger){
          _toNextQuiz();
          GuideHep.instance.updateNewGuide(NewUserGuideStep.cashDialog);
          return;
        }
        if(ProHep.instance.showFirstBoxOverlay(context: context,globalKey: _firstProgressBoxGlobalKey)){
          _toNextQuiz();
          return;
        }
        if(ProHep.instance.showFirstWheelOverlay(context: context,globalKey: _firstProgressWheelGlobalKey)){
          _toNextQuiz();
          return;
        }
        Incent(
          add: ValueHep.instance.getQuizCoins(),
          dismissCall: (){
            _toNextQuiz();
          },
        ).dPop(context);
        return;
      }
      _toNextQuiz();
    });
  }

  _toNextQuiz(){
    QuizHep.instance.updateNextQuiz();
    setState(() {
      _initCurQuizMap();
    });
  }

  _updateProgressList(){
    setState(() {
      ProHep.instance.updateProgress();
    });
  }

  @override
  showCashGuideDialog() {
    CashGuide(
      dismissDialog: (toCash){
        GuideHep.instance.updateNewGuide(NewUserGuideStep.completed);
        if(toCash){

        }
      },
    ).show();
  }

  @override
  showRightAnswerFinger() {
    var globalKey = _quizMap?["qt_res"]=="a"?_answerAGlobalKey:_answerBGlobalKey;
    var renderBox = globalKey.currentContext!.findRenderObject() as RenderBox;
    setState(() {
      _rightAnswerOffset=renderBox.localToGlobal(Offset.zero);
    });
  }

  @override
  showBubble() {
    setState(() {
      _showBubble=true;
    });
  }

  @override
  showOldUserDialog() {
    OldUser(
      dismissDialog: (spin){
        GuideHep.instance.updateOldGuide(spin?OldUserGuideStep.wheelDialog:OldUserGuideStep.signIncentDialog);
      },
    ).show();
  }

  @override
  showWheelDialog() {
    WheelDialog(
      wheelFrom: WheelFrom.oldUser,
      dismissDialog: (addNum){
        GuideHep.instance.updateOldGuide(OldUserGuideStep.wheelIncentDialog,addNum: addNum);
      },
    ).show();
  }

  @override
  showWheelIncentDialog(double addNum) {
    WheelIncent(
      wheelAddNum: addNum,
      dismissDialog: (){
        GuideHep.instance.updateOldGuide(OldUserGuideStep.completed);
      },
    ).show();
  }

  @override
  showSignIncentDialog() {
    SignIncent(
      dismissDialog: (){
        GuideHep.instance.updateOldGuide(OldUserGuideStep.completed);
      },
    ).show();
  }

  _delayShowRightAnswerFinger(){
    _rightAnswerTimer=Timer(const Duration(milliseconds: 5000),(){
      _stopRightAnswerTimer();
      if(newGuideBean.getV()!=NewUserGuideStep.rightAnswerFinger){
        showRightAnswerFinger();
      }
    });
  }

  _stopRightAnswerTimer(){
    _rightAnswerTimer?.cancel();
    _rightAnswerTimer=null;
  }

  test(){
    if(!kDebugMode){
      return;
    }
    // GuideHep.instance.showGuide();
    // showOldUserDialog();
    // ProHep.instance.showFirstBoxOverlay(context: context);
    ProHep.instance.showFirstWheelOverlay(context: context,globalKey: _firstProgressWheelGlobalKey);
  }
}