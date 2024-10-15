class TaskRecord{
  String? payType;
  int? chooseMoney;
  String? taskType;
  int? completedNum;
  int? totalNum;
  int? signedNum;
  int? signTotalNum;
  String? cardsNum;
  TaskRecord({
    required this.payType,
    required this.chooseMoney,
    required this.taskType,
    required this.completedNum,
    required this.totalNum,
    required this.signedNum,
    required this.signTotalNum,
    required this.cardsNum,
  });

  Map<String,dynamic> toJson()=>{
    "payType":payType,
    "chooseMoney":chooseMoney,
    "taskType":taskType,
    "completedNum":completedNum,
    "totalNum":totalNum,
    "signedNum":signedNum,
    "signTotalNum":signTotalNum,
    "cardsNum":cardsNum,
  };


  TaskRecord.fromJson(dynamic json) {
    payType = json['payType'];
    chooseMoney = json['chooseMoney'];
    taskType = json['taskType'];
    completedNum = json['completedNum'];
    totalNum = json['totalNum'];
    signedNum = json['signedNum'];
    signTotalNum = json['signTotalNum'];
    cardsNum = json['cardsNum'];
  }

  @override
  String toString() {
    return 'TaskRecord{payType: $payType, chooseMoney: $chooseMoney, taskType: $taskType, completedNum: $completedNum, totalNum: $totalNum, signedNum: $signedNum, signTotalNum: $signTotalNum, cardsNum: $cardsNum}';
  }
}