import 'package:quiztime55/b/hep/call_listener/call_listener_hep.dart';
import 'package:quiztime55/b/hep/comment_hep.dart';
import 'package:quiztime55/b/hep/heppppp.dart';
import 'package:quiztime55/b/hep/sign/sign_bean.dart';
import 'package:quiztime55/b/hep/sql/pay_type.dart';
import 'package:quiztime55/b/hep/sql/task_record.dart';
import 'package:quiztime55/b/hep/value_hep.dart';
import 'package:sqflite/sqflite.dart';

class TableName{
  static const String task="task";
  static const String sign="sign";
  static const String everyDayAnswerNum="everyDayAnswerNum";
}

class SqlHep {
  factory SqlHep()=>_getInstance();
  static SqlHep get instance=>_getInstance();
  static SqlHep? _instance;
  static SqlHep _getInstance(){
    _instance??=SqlHep._internal();
    return _instance!;
  }
  SqlHep._internal();
  
  Future<void> initDB()async{
    await _openDB();
  }

  Future<bool> checkFirstCash(PayType payType,int chooseMoney)async{
    var result = await queryTaskRecordByPayTypeAndChooseMoney(payType, chooseMoney);
    return result.isEmpty;
  }

  Future<bool> insertTaskRecord(PayType payType,int chooseMoney,String cards)async{
    var firstCash = await checkFirstCash(payType, chooseMoney);
    if(!firstCash){
      return false;
    }
    var db = await _openDB();
    var task = ValueHep.instance.getTaskByIndex(0);
    var id = await db.insert(TableName.task, TaskRecord(payType: payType.name, chooseMoney: chooseMoney, taskType: task.title??"", completedNum: 0, totalNum: task.data??0, signedNum: 0, signTotalNum: task.time??0, cardsNum: cards).toJson());
    return id>0;
  }


  Future<TaskRecord?> refreshTaskRecordByTaskType(PayType payType,int chooseMoney,String nextTaskType)async{
    var db = await _openDB();
    var resultList = await db.query(TableName.task,where: '"payType" = ? AND "chooseMoney" = ?',whereArgs: [payType.name,chooseMoney]);
    if(resultList.isEmpty){
      return null;
    }
    var map = resultList.first;
    var id = map["id"];
    var newMap = Map<String,Object>.from(map);
    var task = ValueHep.instance.getTaskByTitle(nextTaskType);
    newMap["taskType"]=nextTaskType;
    newMap["completedNum"]=0;
    newMap["totalNum"]=task.data??0;
    newMap["signedNum"]=0;
    newMap["signTotalNum"]=task.time??0;
    await db.update(TableName.task, newMap,where: "id = ?",whereArgs: [id]);
    return TaskRecord.fromJson(newMap);
  }

  updateTaskCompletedNumRecord(String taskType)async{
    var db = await _openDB();
    var resultList = await db.query(TableName.task,where: '"taskType" = ? AND completedNum < totalNum',whereArgs: [taskType]);
    var resultNum=0;
    for (var value in resultList) {
      var id = value["id"];
      var completedNum = value["completedNum"] as int;
      var newMap = Map<String,Object>.from(value);
      newMap["completedNum"]=completedNum+1;
      await db.update(TableName.task, newMap,where: "id = ?",whereArgs: [id]);
      resultNum++;
      if(resultNum==resultList.length){
        CallListenerHep.instance.updateTaskProgress();
      }
    }
  }

  Future<List<TaskRecord>> queryTaskRecordByPayTypeAndChooseMoney(PayType payType,int chooseMoney)async{
    var db = await _openDB();
    var resultList = await db.query(TableName.task,where: '"payType" = ? AND "chooseMoney" = ?',whereArgs: [payType.name,chooseMoney]);
    List<TaskRecord> taskList=[];
    for(var value in resultList){
      taskList.add(TaskRecord.fromJson(value));
    }
    return taskList;
  }

  Future<List<Map<String, Object?>>> querySignData()async{
    var db = await _openDB();
    return await db.query(TableName.sign);
  }

  insertSignData(SignBean bean)async{
    var db = await _openDB();
    var resultList = await db.query(TableName.task,where: 'signedNum < signTotalNum');
    if(resultList.isNotEmpty){
      db.insert(TableName.sign, bean.toJson());
      var resultNum=0;
      for (var value in resultList) {
        var id = value["id"];
        var signedNum = value["signedNum"] as int;
        var newMap = Map<String,Object>.from(value);
        newMap["signedNum"]=signedNum+1;
        await db.update(TableName.task, newMap,where: "id = ?",whereArgs: [id]);
        resultNum++;
        if(resultNum==resultList.length){
          CallListenerHep.instance.updateTaskProgress();
        }
      }
    }else{
      CallListenerHep.instance.updateTaskProgress();
    }
  }

  Future<bool> checkStartCashTask()async{
    var db = await _openDB();
    var list = await db.query(TableName.task,);
    return list.isNotEmpty;
  }

  Future<int> queryTodayAnswerNum()async{
    var db = await _openDB();
    var list = await db.query(TableName.everyDayAnswerNum,where: '"timer" = ?',whereArgs: [getTodayStr()]);
    if(list.isNotEmpty){
      return (list.first["answerNum"]??0) as int;
    }
    return 0;
  }

  updateTodayAnswerNum()async{
    var db = await _openDB();
    var list = await db.query(TableName.everyDayAnswerNum,where: '"timer" = ?',whereArgs: [getTodayStr()]);
    if(list.isEmpty){
      db.insert(TableName.everyDayAnswerNum, {"timer":getTodayStr(),"answerNum":1});
    }else{
      var value = list.first;
      var id = value["id"];
      var signedNum = value["answerNum"] as int;
      var newMap = Map<String,Object>.from(value);
      newMap["answerNum"]=signedNum+1;
      await db.update(TableName.everyDayAnswerNum, newMap,where: "id = ?",whereArgs: [id]);
      CommentHep.instance.checkShowCommentDialog();
    }
  }

  Future<Database> _openDB() async => await openDatabase(
    "quiz.db",
    version: 1,
    onCreate: (db,version)async{
      db.execute('CREATE TABLE ${TableName.sign} (id INTEGER PRIMARY KEY AUTOINCREMENT, signTimer TEXT)');
      db.execute('CREATE TABLE ${TableName.task} (id INTEGER PRIMARY KEY AUTOINCREMENT, payType TEXT, chooseMoney INTEGER, taskType TEXT, completedNum INTEGER, totalNum INTEGER, signedNum INTEGER, signTotalNum INTEGER, cardsNum TEXT)');
      db.execute('CREATE TABLE ${TableName.everyDayAnswerNum} (id INTEGER PRIMARY KEY AUTOINCREMENT, timer TEXT, answerNum INTEGER)');
    },
    // onUpgrade: (db,oldVersion,newVersion){
    //   if(newVersion==4){
    //     db.execute('CREATE TABLE ${TableName.sign} (id INTEGER PRIMARY KEY AUTOINCREMENT, signTimer TEXT)');
    //   }
    // }
  );

  test()async{
    var db = await _openDB();
    var list = await db.query(TableName.everyDayAnswerNum,where: '"timer" = ?',whereArgs: [getTodayStr()]);
    var first = list.first;
    first["timer"]=getTodayStr();
  }
}
