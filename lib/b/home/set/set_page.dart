import 'package:flutter/material.dart';
import 'package:quiztime55/global/widg/qt_image.dart';
import 'package:quiztime55/home/set/set_p.dart';

class SetPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        QtImage("hrerw0",w: double.infinity,h: double.infinity,),
        SafeArea(
          top: true,
          child: SetP(),
        ),

      ],
    ),
  );
}