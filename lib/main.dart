import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quiztime55/global/appd/qt_save.dart';
import 'package:quiztime55/pro/pro_p.dart';

import 'global/appd/qt_quiz_hep.dart';

void main() async {
  await GetStorage.init();
  initDay();

  QtQuizHep.loadQtData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 760),
        builder: (context, child) {
          return MaterialApp(
            theme: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              useMaterial3: true,
            ),
            home: const ProP(),
          );
        });
  }
}
