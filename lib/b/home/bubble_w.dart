import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiztime55/b/hep/ad_hep.dart';
import 'package:quiztime55/b/hep/info_hep.dart';
import 'package:quiztime55/b/hep/value_hep.dart';
import 'package:quiztime55/global/widg/qt_image.dart';
import 'package:quiztime55/global/widg/ws_text.dart';

class BubbleW extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _BubbleWState();
}
class _BubbleWState extends State<BubbleW>{
  late Timer _timer;
  GlobalKey globalKey=GlobalKey();
  double addNum=ValueHep.instance.getFloatCoins();
  var you=true,xia=true,cx=0.0,cy=0.0,show=true;

  @override
  void initState() {
    super.initState();
    Future((){
      _startTimer();
    });
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: double.infinity,
    key: globalKey,
    child: Stack(
      children: [
        Positioned(
          top: cy,
          left: cx,
          child: Offstage(
            offstage: !show,
            child: InkWell(
              onTap: (){
                _clickBubble();
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  QtImage("joome",w: 68.w,h: 68.w,),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      QtImage("money3",w: 44.w,h: 44.w,),
                      QtText(
                        "\$$addNum",
                        fontSize: 14.sp,
                        color: Color(0xffFFBB19),
                        fontWeight: FontWeight.w500,
                        shadows: [Shadow(color: const Color(0xFF774607), blurRadius: 1.w, offset: Offset(0, 2.w))],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ],
    ),
  );

  _startTimer(){
    var size = globalKey.currentContext?.size;
    var sWidth=(size?.width??760.w)-68.w;
    var sHeight=(size?.height??360.w)-68.w;
    _timer=Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if(you){
        cx++;
        if(xia){
          cy++;
          if(cy>=sHeight){
            xia=false;
          }
        }else{
          cy--;
          if(cy<=0){
            xia=true;
          }
        }
        if(cx>=sWidth){
          you=false;
        }
      }else{
        cx--;
        if(xia){
          cy++;
          if(cy>=sHeight){
            xia=false;
          }
        }else{
          cy--;
          if(cy<=0){
            xia=true;
          }
        }
        if(cx<=0){
          you=true;
        }
      }
      setState(() {});
    });
  }

  _clickBubble(){
    setState(() {
      show=false;
    });
    if(!receivedBubbleBean.getV()){
      InfoHep.instance.addCoins(addNum);
      receivedBubbleBean.putV(true);
      _delayShowBubble();
      return;
    }
    AdHep.instance.showAd(
      adType: AdType.reward,
      hiddenAd: (){
        InfoHep.instance.addCoins(addNum);
        _delayShowBubble();
      },
      showFail: (){
        _delayShowBubble();
      },
    );
  }

  _delayShowBubble(){
    Future.delayed(Duration(seconds: InfoHep.instance.bubbleShowTime),(){
      setState(() {
        addNum=ValueHep.instance.getFloatCoins();
        show=true;
      });
    });
  }
}