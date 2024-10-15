import 'package:flutter/material.dart';
import 'package:time_a/home/set/set_p.dart';
import 'package:time_base/w/qt_image.dart';

class SetPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        QtImage("hrerw0",w: double.infinity,h: double.infinity,),
        SafeArea(
          top: true,
          child: SetP(showBack: true,),
        ),

      ],
    ),
  );
}