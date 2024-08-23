import 'package:flutter/cupertino.dart';

class QtText extends StatelessWidget {
  final String name;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;

  const QtText(this.name, {super.key, required this.fontSize, required this.color, required this.fontWeight});

  @override
  Widget build(BuildContext context) {
    var nn = name;
    if (fontWeight != FontWeight.w400 && fontWeight != FontWeight.w500 && fontWeight != FontWeight.w600) {
      nn = "Weight Error";
    }
    return Text(nn, style: TextStyle(fontSize: fontSize, fontFamily: "oirirj", color: color, fontWeight: fontWeight));
  }
}
