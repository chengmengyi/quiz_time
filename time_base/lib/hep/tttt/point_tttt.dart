import 'package:time_base/hep/tttt/base_tttt.dart';
import 'package:time_base/hep/tttt/point_name.dart';

class PointTTTT{
  Future<Map<String,dynamic>> toJson(String logId,PointName pointName,Map<String,dynamic>? params)async{
    var tttt = BaseTttt();
    await tttt.createData(logId);
    var baseMap = tttt.toJson();
    baseMap["boulder"]=pointName.name;
    params?.forEach((key,value){
      baseMap["drought%$key"]=value;
    });
    return baseMap;
  }
}