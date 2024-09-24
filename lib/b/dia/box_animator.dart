import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quiztime55/b/hep/heppppp.dart';

class BoxAnimatorDialog extends StatefulWidget{
  Function() dismiss;
  BoxAnimatorDialog({required this.dismiss});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<BoxAnimatorDialog>{

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2300),(){
      closeDialog();
      widget.dismiss.call();
    });
  }

  @override
  Widget build(BuildContext context)=>WillPopScope(
    child: Material(
      type: MaterialType.transparency,
      child: Center(
        child: Lottie.asset("qtf/f4/kai.json",repeat: false),
      ),
    ),
    onWillPop: ()async{
      return false;
    },
  );
}