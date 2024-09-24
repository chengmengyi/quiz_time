import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiztime55/b/hep/call_listener/call_listener_hep.dart';
import 'package:quiztime55/b/hep/call_listener/click_task_listener.dart';
import 'package:quiztime55/b/hep/lifecycle_hep.dart';
import 'package:quiztime55/b/hep/notifi/notifi_hep.dart';
import 'package:quiztime55/b/hep/tttt/point_name.dart';
import 'package:quiztime55/b/hep/tttt/tttt_hep.dart';
import 'package:quiztime55/b/home/cash/cash_child.dart';
import 'package:quiztime55/b/home/quiz/quiz_child.dart';
import 'package:quiztime55/global/widg/qt_image.dart';

import '../hep/call_listener/change_home_tab_index_listener.dart';

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> implements ClickTaskListener,ChangeHomeTabIndexListener{
  var tabIndex=0;
  List<Widget> pageList=[QuizChild(), CashChild()];

  @override
  void initState() {
    super.initState();
    TTTTHep.instance.pointEvent(PointName.quiz_page);
    CallListenerHep.instance.updateClickTaskListener(this);
    CallListenerHep.instance.updateChangeHomeTabIndexListener(this);
    LifecycleHep.instance.initListener();
    NotifiHep.instance.showNotifi();
    _checkFromNotifi();
    TTTTHep.instance.uploadLocalTbaData();
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

  _checkFromNotifi(){
    Future(()async{
      var details = await NotifiHep.instance.getNotificationAppLaunchDetails();
      if(details?.didNotificationLaunchApp==true&&details?.notificationResponse?.id==NotifiId.pay){
        _clickBottom(1);
      }
    });
  }
}