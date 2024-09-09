import 'package:flutter/cupertino.dart';

class QtImage extends StatelessWidget {
  final String name;
  final double? w;
  final double? h;
  final BoxFit? fit;

  const QtImage(this.name, {super.key, this.w, this.h,this.fit});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "qtf/f1/$name.webp",
      fit: fit??BoxFit.fill,
      width: w,
      height: h,
    );
  }
}
