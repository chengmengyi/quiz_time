import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quiztime55/pro/pro_p.dart';
import 'package:time_a/hep/sign/sign_hep.dart';
import 'package:time_a/hep/value_hep.dart';
import 'package:time_b/hep/value_hep.dart';
import 'package:time_base/hep/ad/load_ad_hep.dart';
import 'package:time_base/hep/check_type/check_type_hep.dart';
import 'package:time_base/hep/save/qt_quiz_hep.dart';
import 'package:time_base/hep/sql/sql_hep.dart';
import 'package:time_base/hep/tttt/tttt_hep.dart';
import 'package:time_base/quiz_language/quiz_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  QtQuizHep.loadQtData();
  await SqlHep.instance.initDB();
  ValueHepA.instance.loadQtData();
  ValueHepB.instance.loadQtData();
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
            title: "QuizTime",
            theme: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              useMaterial3: true,
            ),
            home: const ProP(),
            debugShowCheckedModeBanner: false,
            translations: QuizTranslations(),
            locale: Get.deviceLocale,
            fallbackLocale: const Locale("en","US"),
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
