import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:quiztime55/b/hep/heppppp.dart';
import 'package:quiztime55/global/widg/qt_image.dart';
import 'package:quiztime55/global/widg/ws_text.dart';

class GetCoinsDialog extends StatefulWidget{
  double addNum;
  Function() dismissDialog;
  GetCoinsDialog({required this.addNum,required this.dismissDialog});

  @override
  State<StatefulWidget> createState() => _GetCoinsDialogState();
}

class _GetCoinsDialogState extends State<GetCoinsDialog>{

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500),(){
      closeDialog();
      widget.dismissDialog.call();
    });
  }

  @override
  Widget build(BuildContext context)=>WillPopScope(
    child: Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 20.w,right: 20.w),
          padding: EdgeInsets.only(top: 20.w,bottom: 20.w),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(24.w),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QtText(
                "Congratulation",
                fontSize: 32.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                shadows: [Shadow(color: const Color(0xFFCA780A), blurRadius: 1.w, offset: Offset(0, 2.w))],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Lottie.asset("qtf/f4/xuanguang.json",width: 200.w,height: 200.w),
                  QtImage("money1", w: 160.w, h: 160.w),
                ],
              ),
              QtText(
                "+\$${widget.addNum}",
                fontSize: 32.sp,
                color: const Color(0xffFFBB19),
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    ),
    onWillPop: ()async{
      return false;
    },
  );

}