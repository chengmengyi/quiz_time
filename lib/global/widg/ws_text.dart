import 'package:flutter/cupertino.dart';

class QtText extends StatelessWidget {
  final String name;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;

  final TextAlign? textAlign;

  final List<Shadow>? shadows;
  final int? maxLines;

  const QtText(this.name,
      {
        super.key,
        required this.fontSize,
        required this.color,
        required this.fontWeight,
        this.shadows,
        this.textAlign,
        this.maxLines,
      });

  @override
  Widget build(BuildContext context) {
    var nn = name;
    if (fontWeight != FontWeight.w400 && fontWeight != FontWeight.w500 && fontWeight != FontWeight.w600) {
      nn = "Weight Error";
    }
    return Text(
      textAlign: textAlign,
      nn,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: "oirirj",
        color: color,
        fontWeight: fontWeight,
        height: 1.3,
        shadows: shadows,
      ),
    );
  }
}
