import 'package:quiztime55/b/hep/sql/pay_type.dart';
import 'package:quiztime55/b/hep/sql/sql_hep.dart';
import 'package:quiztime55/b/hep/sql/task_record.dart';
import 'package:quiztime55/b/hep/task/task_bean.dart';
import 'package:quiztime55/b/hep/value_hep.dart';

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
    var list = await SqlHep.instance.queryTaskRecordByPayTypeAndChooseMoney(payType,chooseMoney);
    if(list.isEmpty){
      return [];
    }
    var taskRecord = list.first;
    var currentTaskTypeIndex = _taskTypeList.indexWhere((value)=>value==taskRecord.taskType);
    if((taskRecord.completedNum??0)<(taskRecord.totalNum??0)||(taskRecord.signedNum??0)<(taskRecord.signTotalNum??0)||currentTaskTypeIndex==_taskTypeList.length-1){
      List<TaskBean> taskList=[];
      taskList.add(TaskBean(title: _getTaskTitleByType(taskRecord), current: taskRecord.completedNum??0, total: taskRecord.totalNum??0, taskType: taskRecord.taskType??""));
      taskList.add(TaskBean(title: "Sign in for ${taskRecord.signTotalNum??0} days", current: taskRecord.signedNum??0, total: taskRecord.signTotalNum??0, taskType: TaskType.sign));
      return taskList;
    }else{
      var nextTaskType = _taskTypeList[currentTaskTypeIndex+1];
      var newTaskRecord = await SqlHep.instance.refreshTaskRecordByTaskType(payType, chooseMoney, nextTaskType);
      if(null==newTaskRecord){
        return [];
      }
      List<TaskBean> taskList=[];
      taskList.add(TaskBean(title: _getTaskTitleByType(newTaskRecord), current: newTaskRecord.completedNum??0, total: newTaskRecord.totalNum??0, taskType: newTaskRecord.taskType??""));
      taskList.add(TaskBean(title: "Sign in for ${newTaskRecord.signTotalNum??0} days", current: newTaskRecord.signedNum??0, total: newTaskRecord.signTotalNum??0, taskType: TaskType.sign));
      return taskList;
    }
  }

  String _getTaskTitleByType(TaskRecord taskRecord){
    var data = ValueHep.instance.getTaskByTitle(taskRecord.taskType??"").data;
    switch(taskRecord.taskType){
      case TaskType.quiz: return "Answer $data question correctly";
      case TaskType.box: return "Open $data Gift Box";
      case TaskType.spin: return "Play $data Spins";
      case TaskType.pop: return "Collect $data Cash Pops";
      default: return "";
    }
  }
}