import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_b/hep/call_listener/call_listener_hep.dart';
import 'package:time_b/hep/call_listener/click_task_listener.dart';
import 'package:time_b/hep/lifecycle_hep.dart';
import 'package:time_b/home/cash/cash_child.dart';
import 'package:time_b/home/quiz/quiz_child.dart';
import 'package:time_base/hep/heppppp.dart';
import 'package:time_base/hep/tttt/point_name.dart';
import 'package:time_base/hep/tttt/tttt_hep.dart';
import 'package:time_base/time_base.dart';
import 'package:time_base/w/qt_image.dart';

import '../hep/call_listener/change_home_tab_index_listener.dart';

class QuizHomeB extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _QuizHomeBState();
}

class _QuizHomeBState extends State<QuizHomeB> implements ClickTaskListener,ChangeHomeTabIndexListener{
  var tabIndex=0;
  List<Widget> pageList=[QuizChild(), CashChild()];

  @override
  void initState() {
    super.initState();
    TTTTHep.instance.pointEvent(PointName.quiz_page);
    CallListenerHep.instance.updateClickTaskListener(this);
    CallListenerHep.instance.updateChangeHomeTabIndexListener(this);
    LifecycleHep.instance.initListener();
    TTTTHep.instance.uploadLocalTbaData();
    TimeBase.instance.openData();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        QtImage(tabIndex==0?"qwfef":"fjeofnefm",w: double.infinity,h: double.infinity,),
        Stack(
          children: [
            IndexedStack(
              alignment: Alignment.topCenter,
              index: tabIndex,
              children: pageList,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _bottomWidget(),
            ),
            
            // Align(
            //   alignment: Alignment.bottomLeft,
            //   child: Column(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       TextButton(onPressed: (){
            //         FlutterMaxAd.instance.inittest();
            //       }, child: Text("init")),
            //       TextButton(onPressed: (){
            //         FlutterMaxAd.instance.loadtest();
            //       }, child: Text("load")),
            //       TextButton(onPressed: (){
            //         FlutterMaxAd.instance.tradtest();
            //       }, child: Text("trad")),
            //       TextButton(onPressed: (){
            //         FlutterMaxAd.instance.tradLoad();
            //       }, child: Text("load")),
            //       TextButton(onPressed: (){
            //         FlutterMaxAd.instance.tradShow();
            //       }, child: Text("show")),
            //       TextButton(onPressed: (){
            //         FlutterMaxAd.instance.initTopOn(strBase64Decode(toponId), strBase64Decode(toponKey));
            //       }, child: Text("topinit")),
            //       TextButton(onPressed: (){
            //         FlutterMaxAd.instance.loadTopon();
            //       }, child: Text("loadtopon")),
            //       TextButton(onPressed: (){
            //         FlutterMaxAd.instance.showTopon();
            //       }, child: Text("showtopon")),
            //     ],
            //   ),
            // )
          ],
        )
      ],
    ),
  );

  _bottomWidget()=>Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      InkWell(
        onTap: (){
          _clickBottom(0);
        },
        child: QtImage(tabIndex==0?"mfiev":"fmoefow",w: 108.w,h: 64.h,),
      ),
      SizedBox(width: 16.w,),
      InkWell(
        onTap: (){
          _clickBottom(1);
        },
        child: QtImage(tabIndex==1?"fjioefm":"fewjofjew",w: 108.w,h: 64.h,),
      ),
    ],
  );

  _clickBottom(index){
    if(tabIndex==index){
      return;
    }
    TTTTHep.instance.pointEvent(index==0?PointName.quiz_page:PointName.cash_page);
    setState(() {
      tabIndex=index;
    });
  }

  @override
  clickTask(String taskType) {
    _clickBottom(0);
  }

  @override
  showHomeIndex(int index) {
    _clickBottom(index);
  }
}