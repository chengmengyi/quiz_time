

import 'package:time_a/hep/sign/sign_bean.dart';
import 'package:time_a/hep/sql/sql_hep_a.dart';
import 'package:time_base/hep/heppppp.dart';

class SignHep{
  factory SignHep()=>_getInstance();
  static SignHep get instance=>_getInstance();
  static SignHep? _instance;
  static SignHep _getInstance(){
    _instance??=SignHep._internal();
    return _instance!;
  }

  SignHep._internal();
  final List<SignBean> _signList=[];

  initSignList()async{
    var signData = await SqlHepA.instance.querySignData();
    _signList.clear();
    for(var value in signData){
      _signList.add(SignBean.fromJson(value));
    }
  }

  bool checkTodaySigned() {
    var indexWhere = _signList.indexWhere((value)=>value.signTimer==getTodayStr());
    return indexWhere>=0;
  }

  sign(){
    if(checkTodaySigned()){
      return;
    }
    var bean = SignBean(signTimer: getTodayStr());
    _signList.add(bean);
    SqlHepA.instance.insertSignData(bean);
  }

  test(){
    var bean = SignBean(signTimer: "14-20 2024");
    _signList.add(bean);
    SqlHepA.instance.insertSignData(bean);
  }
}