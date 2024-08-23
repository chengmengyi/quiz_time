import 'package:flutter/material.dart';

getBgDecorationImage(String name) => DecorationImage(image: AssetImage("qtf/f1/$name.webp"), fit: BoxFit.fill);

getMaterialRoute(Widget page) => MaterialPageRoute(
      settings: const RouteSettings(),
      builder: (context) => page,
    );
