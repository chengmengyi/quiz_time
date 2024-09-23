import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quiztime55/b/hep/ad/load_ad_hep.dart';
import 'package:quiztime55/b/hep/check_type/check_type_hep.dart';
import 'package:quiztime55/b/hep/sign/sign_hep.dart';
import 'package:quiztime55/b/hep/sql/sql_hep.dart';
import 'package:quiztime55/b/hep/tttt/tttt_hep.dart';
import 'package:quiztime55/b/hep/value_hep.dart';
import 'package:quiztime55/global/appd/qt_save.dart';
import 'package:quiztime55/pro/pro_p.dart';

import 'global/appd/qt_quiz_hep.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  initDay();

  QtQuizHep.loadQtData();
  await SqlHep.instance.initDB();
  ValueHep.instance.loadQtData();
  SignHep.instance.initSignList();
  CheckTypeHep.instance.checkType();
  LoadAdHep.instance.loadAd();
  TTTTHep.instance.installEvent();
  TTTTHep.instance.sessionEvent();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 760),
        builder: (context, child) {
          return GetMaterialApp(
            title: "QuizTime Pro",
            theme: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              useMaterial3: true,
            ),
            home: const ProP(),
            debugShowCheckedModeBanner: false,
            builder: (context,widget)=>Material(
              child: InkWell(
                onTap: (){
                  var node = FocusScope.of(context);
                  if(!node.hasPrimaryFocus&&node.focusedChild!=null){
                    FocusManager.instance.primaryFocus?.unfocus();
                  }
                },
                child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: widget!
                ),
              ),
            ),
          );
        });
  }
}
