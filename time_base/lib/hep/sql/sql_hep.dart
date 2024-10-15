import 'dart:convert';
import 'package:sqflite/sqflite.dart';

class TableName{

  //a包数据库
  static const String task="task";
  static const String sign="sign";
  static const String everyDayAnswerNum="everyDayAnswerNum";
  //b包数据库
  static const String taskB="taskB";
  static const String signB="signB";
  static const String everyDayAnswerNumB="everyDayAnswerNumB";

  //tba数据库
  static const String tbaData="tbaData";
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
    await createDB();
  }

  insertTbaData(Map<String,dynamic> map)async{
    var db = await createDB();
    db.insert(TableName.tbaData, {"data":jsonEncode(map)});
  }

  Future<List> queryTbaData()async{
    var db = await createDB();
    var list = await db.query(TableName.tbaData);
    if(list.isEmpty){
      return [];
    }
    List result=[];
    for (var value in list) {
      result.add(jsonDecode(value["data"] as String));
    }
    return result;
  }

  clearTbaTableData()async{
    var db = await createDB();
    db.delete(TableName.tbaData);
  }

  Future<Database> createDB() async => await openDatabase(
    "quiz.db",
    version: 2,
    onCreate: (db,version)async{
      db.execute('CREATE TABLE ${TableName.sign} (id INTEGER PRIMARY KEY AUTOINCREMENT, signTimer TEXT)');
      db.execute('CREATE TABLE ${TableName.task} (id INTEGER PRIMARY KEY AUTOINCREMENT, payType TEXT, chooseMoney INTEGER, taskType TEXT, completedNum INTEGER, totalNum INTEGER, signedNum INTEGER, signTotalNum INTEGER, cardsNum TEXT)');
      db.execute('CREATE TABLE ${TableName.everyDayAnswerNum} (id INTEGER PRIMARY KEY AUTOINCREMENT, timer TEXT, answerNum INTEGER)');
      db.execute('CREATE TABLE ${TableName.tbaData} (id INTEGER PRIMARY KEY AUTOINCREMENT, data TEXT)');

      _createTableB(db);
      },
    onUpgrade: (db,oldVersion,newVersion){
      if(newVersion==2){
        _createTableB(db);
      }
    }
  );

  _createTableB(Database db){
    db.execute('CREATE TABLE ${TableName.signB} (id INTEGER PRIMARY KEY AUTOINCREMENT, signTimer TEXT)');
    db.execute('CREATE TABLE ${TableName.taskB} (id INTEGER PRIMARY KEY AUTOINCREMENT, payType TEXT, chooseMoney INTEGER, taskType TEXT, completedNum INTEGER, totalNum INTEGER, signedNum INTEGER, signTotalNum INTEGER, cardsNum TEXT)');
    db.execute('CREATE TABLE ${TableName.everyDayAnswerNumB} (id INTEGER PRIMARY KEY AUTOINCREMENT, timer TEXT, answerNum INTEGER)');
  }

  // test()async{
  //   var db = await _openDB();
  //   var list = await db.query(TableName.everyDayAnswerNum,where: '"timer" = ?',whereArgs: [getTodayStr()]);
  //   var first = list.first;
  //   first["timer"]=getTodayStr();
  // }
}
