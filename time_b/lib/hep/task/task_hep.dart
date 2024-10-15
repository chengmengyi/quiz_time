

import 'package:time_b/hep/sql/sql_hep_b.dart';
import 'package:time_b/hep/sql/task_record.dart';
import 'package:time_b/hep/task/task_bean.dart';
import 'package:time_b/hep/value_hep.dart';
import 'package:time_base/hep/heppppp.dart';
import 'package:time_base/hep/sql/pay_type.dart';
import 'package:time_base/quiz_language/local_text.dart';

class TaskType{
  static const String quiz="quiz";
  static const String box="box";
  static const String spin="spin";
  static const String pop="pop";
  static const String sign="sign";
}

class TaskHep{
  factory TaskHep()=>_getInstance();
  static TaskHep get instance=>_getInstance();
  static TaskHep? _instance;
  static TaskHep _getInstance(){
    _instance??=TaskHep._internal();
    return _instance!;
  }
  TaskHep._internal();

  final List<String> _taskTypeList=[TaskType.quiz,TaskType.box,TaskType.spin,TaskType.pop];

  Future<List<TaskBean>> getTaskListByPayTypeAndChooseMoney(PayType payType,int chooseMoney)async{
    //list only one
    var list = await SqlHepB.instance.queryTaskRecordByPayTypeAndChooseMoney(payType,chooseMoney);
    if(list.isEmpty){
      return [];
    }
    var taskRecord = list.first;
    var currentTaskTypeIndex = _taskTypeList.indexWhere((value)=>value==taskRecord.taskType);
    if((taskRecord.completedNum??0)<(taskRecord.totalNum??0)||(taskRecord.signedNum??0)<(taskRecord.signTotalNum??0)||currentTaskTypeIndex==_taskTypeList.length-1){
      List<TaskBean> taskList=[];
      taskList.add(TaskBean(title: _getTaskTitleByType(taskRecord), current: taskRecord.completedNum??0, total: taskRecord.totalNum??0, taskType: taskRecord.taskType??""));
      taskList.add(TaskBean(title: LocalText.signInFor10Days.tr.tihuan(taskRecord.signTotalNum??0), current: taskRecord.signedNum??0, total: taskRecord.signTotalNum??0, taskType: TaskType.sign));
      return taskList;
    }else{
      var nextTaskType = _taskTypeList[currentTaskTypeIndex+1];
      var newTaskRecord = await SqlHepB.instance.refreshTaskRecordByTaskType(payType, chooseMoney, nextTaskType);
      if(null==newTaskRecord){
        return [];
      }
      List<TaskBean> taskList=[];
      taskList.add(TaskBean(title: _getTaskTitleByType(newTaskRecord), current: newTaskRecord.completedNum??0, total: newTaskRecord.totalNum??0, taskType: newTaskRecord.taskType??""));
      taskList.add(TaskBean(title: LocalText.signInFor10Days.tr.tihuan(newTaskRecord.signTotalNum??0), current: newTaskRecord.signedNum??0, total: newTaskRecord.signTotalNum??0, taskType: TaskType.sign));
      return taskList;
    }
  }

  String _getTaskTitleByType(TaskRecord taskRecord){
    var data = ValueHepB.instance.getTaskByTitle(taskRecord.taskType??"").data;
    switch(taskRecord.taskType){
      case TaskType.quiz: return LocalText.answer10QuestionCorrectly.tr.tihuan(data);
      case TaskType.box: return LocalText.open10GiftBox.tr.tihuan(data);
      case TaskType.spin: return LocalText.play10Spins.tr.tihuan(data);
      case TaskType.pop: return LocalText.collect10CashPops.tr.tihuan(data);
      default: return "";
    }
  }
}