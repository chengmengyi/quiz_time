import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class FingerW extends StatelessWidget{
  double? width;
  double? height;
  FingerW({this.width,this.height});

  @override
  Widget build(BuildContext context) => Lottie.asset("qtf/f4/yindao.json",width: 52.w,height: 52.w);
  // Widget build(BuildContext context) => QtImage("gewgew",w: width??52.w,h: height??52.w,);
}