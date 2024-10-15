import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_b/hep/call_listener/call_listener_hep.dart';
import 'package:time_b/hep/task/task_bean.dart';
import 'package:time_b/hep/task/task_hep.dart';
import 'package:time_base/hep/heppppp.dart';
import 'package:time_base/hep/tttt/point_name.dart';
import 'package:time_base/hep/tttt/tttt_hep.dart';
import 'package:time_base/quiz_language/local_text.dart';
import 'package:time_base/w/qt_image.dart';
import 'package:time_base/w/ws_text.dart';


class TaskGuideDialog extends StatelessWidget{
  int chooseMoney;
  TaskBean taskBean;
  TaskGuideDialog({
    required this.chooseMoney,
    required this.taskBean,
  });

  @override
  Widget build(BuildContext context){
    TTTTHep.instance.pointEvent(PointName.cash_task_pop,params: {"task_from":_getSourceFrom()});
    return WillPopScope(
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            margin: EdgeInsets.only(left: 20.w,right: 20.w),
            child: Stack(
              alignment: Alignment.center,
              children: [
                QtImage("nfeunfoe",w: double.infinity,h: 336.h,),
                Container(
                  margin: EdgeInsets.only(left: 24.w,right: 24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: (){
                              closeDialog();
                            },
                            child: QtImage("klmfle",w: 24.w,h: 24.w,),
                          )
                        ],
                      ),
                      QtText(LocalText.justOneStepAwayFromCashWithdrawal.tr, fontSize: 12.sp, color: const Color(0xffA36B21), fontWeight: FontWeight.w400),
                      SizedBox(height: 12.h,),
                      QtText("+${moneyDou2Str(chooseMoney.toDouble())}", fontSize: 32.sp, color: const Color(0xffF26805), fontWeight: FontWeight.w500),
                      SizedBox(height: 12.h,),
                      Container(
                        width: double.infinity,
                        height: 140.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xffE9BD96),
                          borderRadius: BorderRadius.circular(16.w),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            QtImage(_getIcon(),w: 80.w,h: 80.w,),
                            QtText("${taskBean.title}: ${taskBean.current}/${taskBean.total}", fontSize: 14.sp, color: const Color(0xff774607), fontWeight: FontWeight.w400),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h,),
                      InkWell(
                        onTap: (){
                          _clickBtn();
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            QtImage("btn",w: 220.w,h: 56.h,),
                            QtText(LocalText.go.tr, fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.w500)
                          ],
                        ),
                      )
                    ],
                  ),
                )
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

  _clickBtn(){
    TTTTHep.instance.pointEvent(PointName.cash_task_pop_c,params: {"task_from":_getSourceFrom()});
    closeDialog();
    if(taskBean.taskType==TaskType.sign){
      "Today's check-in is completed, please come back tomorrow！".toast();
      return;
    }
    CallListenerHep.instance.clickTask(taskBean.taskType);
  }

  String _getIcon(){
    switch(taskBean.taskType){
      case TaskType.sign: return "task_sign";
      case TaskType.spin: return "task_wheel";
      case TaskType.quiz: return "task_quiz";
      case TaskType.pop: return "task_pop";
      case TaskType.box: return "task_box";
      default: return "task_box";
    }
  }

  String _getSourceFrom(){
    switch(taskBean.taskType){
      case TaskType.sign: return "check";
      case TaskType.spin: return "wheel";
      case TaskType.quiz: return "quiz";
      case TaskType.pop: return "pop";
      case TaskType.box: return "box";
      default: return "box";
    }
  }
}