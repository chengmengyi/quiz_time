import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quiztime55/b/hep/call_listener/call_listener_hep.dart';
import 'package:quiztime55/b/hep/call_listener/show_coins_animator_listener.dart';
import 'package:quiztime55/b/hep/info_hep.dart';

class CoinsAnimatorWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CoinsAnimatorWidget> with TickerProviderStateMixin implements ShowCoinsAnimatorListener{
  var showCoinsAnimator=false,totalCoinsNum=0.0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    CallListenerHep.instance.updateShowCoinsAnimatorListener(this);
    _animationController=AnimationController(vsync: this,duration: const Duration(milliseconds: 1000))..addListener((){
      if(_animationController.value>=0.8){
        _animationController.stop();
        setState(() {
          showCoinsAnimator=false;
        });
        coinsBean.putV(totalCoinsNum);
      }
    });
  }

  @override
  Widget build(BuildContext context) => Offstage(
    offstage: !showCoinsAnimator,
    child: Lottie.asset("qtf/f4/zhichao.json",controller: _animationController),
  );

  @override
  showAnimator(double totalCoinsNum) {
    this.totalCoinsNum=totalCoinsNum;
    setState(() {
      showCoinsAnimator=true;
    });
    _animationController..reset()..forward();
  }
}