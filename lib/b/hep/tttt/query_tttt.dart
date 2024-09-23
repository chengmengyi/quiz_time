import 'package:flutter_tba_info/flutter_tba_info.dart';

class QueryTTTT{
  String? contrary;
  String? hetty;

  createData()async{
    hetty=await FlutterTbaInfo.instance.getAndroidId();
  }

  Map<String,dynamic> toJson(String logId)=>{
    "contrary":logId,
    "hetty":hetty,
  };
}