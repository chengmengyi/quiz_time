import 'package:flutter/cupertino.dart';

class QtImage extends StatelessWidget {
  final String name;
  final double? w;
  final double? h;

  const QtImage(this.name, {super.key, this.w, this.h});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "qtf/f1/$name.webp",
      fit: BoxFit.fill,
      width: w,
      height: h,
    );
  }
}
