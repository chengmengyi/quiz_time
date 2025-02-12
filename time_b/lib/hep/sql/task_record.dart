class TaskRecord{
  String? payType;
  int? chooseMoney;
  String? taskType;
  int? completedNum;
  int? totalNum;
  int? taskIndex;
  String? cardsNum;
  TaskRecord({
    required this.payType,
    required this.chooseMoney,
    required this.taskType,
    required this.completedNum,
    required this.totalNum,
    required this.taskIndex,
    required this.cardsNum,
  });

  Map<String,dynamic> toJson()=>{
    "payType":payType,
    "chooseMoney":chooseMoney,
    "taskType":taskType,
    "completedNum":completedNum,
    "totalNum":totalNum,
    "taskIndex":taskIndex,
    "cardsNum":cardsNum,
  };


  TaskRecord.fromJson(dynamic json) {
    payType = json['payType'];
    chooseMoney = json['chooseMoney'];
    taskType = json['taskType'];
    completedNum = json['completedNum'];
    totalNum = json['totalNum'];
    taskIndex = json['taskIndex'];
    cardsNum = json['cardsNum'];
  }
}