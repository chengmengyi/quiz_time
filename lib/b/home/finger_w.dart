import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiztime55/global/widg/qt_image.dart';

class FingerW extends StatelessWidget{
  double? width;
  double? height;
  FingerW({this.width,this.height});

  @override
  Widget build(BuildContext context) => QtImage("gewgew",w: width??52.w,h: height??52.w,);
}