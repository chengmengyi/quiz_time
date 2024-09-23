import 'package:flutter_check_adjust_cloak/dio/dio_manager.dart';
import 'package:flutter_max_ad/ad/ad_bean/max_ad_bean.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/export.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:quiztime55/b/hep/ad/ad_pppp.dart';
import 'package:quiztime55/b/hep/heppppp.dart';
import 'package:quiztime55/b/hep/tttt/ad_tttt.dart';
import 'package:quiztime55/b/hep/tttt/base_tttt.dart';
import 'package:quiztime55/b/hep/tttt/header_tttt.dart';
import 'package:quiztime55/b/hep/tttt/install_tttt.dart';
import 'package:quiztime55/b/hep/tttt/point_name.dart';
import 'package:quiztime55/b/hep/tttt/point_tttt.dart';
import 'package:quiztime55/b/hep/tttt/query_tttt.dart';
import 'package:quiztime55/global/appd/qt_save.dart';

const QtSaveKey<bool> installEventBean = QtSaveKey(key: "installEvent", de: false);

class TTTTHep{
  factory TTTTHep()=>_getInstance();
  static TTTTHep get instance=>_getInstance();
  static TTTTHep? _instance;
  static TTTTHep _getInstance(){
    _instance??=TTTTHep._internal();
    return _instance!;
  }

  TTTTHep._internal();

  installEvent({bool tryAgain=true})async{
    if(installEventBean.getV()){
      return;
    }
    var logId = await FlutterTbaInfo.instance.getLogId();
    var installMap = await _getInstallMap(logId);
    var headerMap = await _getHeaderMap();
    var path = await _getPath(logId);
    FlutterMaxAd.instance.printDebug("request tba event:install--->params:$installMap");
    var result = await DioManager.instance.requestPost(
      url: path,
      dataMap: installMap,
      headerMap: headerMap
    );
    FlutterMaxAd.instance.printDebug("request tba event:install--->result:${result.success}--->params:$installMap");
    if(result.success){
      installEventBean.putV(true);
    }else{
      Future.delayed(const Duration(milliseconds: 2000),(){
        if(tryAgain){
          installEvent(tryAgain: false);
        }
      });
    }
  }

  sessionEvent({bool tryAgain=true})async{
    var logId = await FlutterTbaInfo.instance.getLogId();
    var sessionMap = await _getSessionMap(logId);
    var headerMap = await _getHeaderMap();
    var path = await _getPath(logId);
    FlutterMaxAd.instance.printDebug("request tba event:session--->params:$sessionMap");
    var result = await DioManager.instance.requestPost(
        url: path,
        dataMap: sessionMap,
        headerMap: headerMap
    );
    FlutterMaxAd.instance.printDebug("request tba event:session--->result:${result.success}--->params:$sessionMap");
    if(!result.success){
      if(tryAgain){
        Future.delayed(const Duration(milliseconds: 2000),(){
          sessionEvent(tryAgain: false);
        });
      }
    }
  }

  adEvent(MaxAd? maxAd,MaxAdInfoBean? maxInfoBean,AdPPPP adPPPP,AdType adFFFF,{bool tryAgain=true})async{
    var logId = await FlutterTbaInfo.instance.getLogId();
    var adMap = await AdTTTT().toJson(logId, maxAd, maxInfoBean, adPPPP, adFFFF);
    var headerMap = await _getHeaderMap();
    var path = await _getPath(logId);
    FlutterMaxAd.instance.printDebug("request tba event:ad--->params:$adMap");
    var result = await DioManager.instance.requestPost(
        url: path,
        dataMap: adMap,
        headerMap: headerMap
    );
    FlutterMaxAd.instance.printDebug("request tba event:ad--->result:${result.success}--->params:$adMap");
    if(!result.success){
      if(tryAgain){
        Future.delayed(const Duration(milliseconds: 2000),(){
          adEvent(maxAd, maxInfoBean, adPPPP, adFFFF,tryAgain: false);
        });
      }
    }
  }

  pointEvent(PointName pointName,{Map<String,dynamic>? params,bool tryAgain=true})async{
    var logId = await FlutterTbaInfo.instance.getLogId();
    var pointMap = await PointTTTT().toJson(logId, pointName, params);
    var headerMap = await _getHeaderMap();
    var path = await _getPath(logId);
    FlutterMaxAd.instance.printDebug("request tba event:point--->params:$pointMap");
    var result = await DioManager.instance.requestPost(
        url: path,
        dataMap: pointMap,
        headerMap: headerMap
    );
    FlutterMaxAd.instance.printDebug("request tba event:point--->result:${result.success}--->params:$pointMap");
    if(!result.success){
      if(tryAgain){
        Future.delayed(const Duration(milliseconds: 2000),(){
          pointEvent(pointName,params: params,tryAgain: false);
        });
      }
    }
  }

  Future<Map<String,dynamic>> _getSessionMap(String logId)async{
    var base = BaseTttt();
    await base.createData(logId);
    var baseMap = base.toJson();
    baseMap["barbital"]={};
    return baseMap;
  }

  Future<Map<String,dynamic>> _getInstallMap(String logId)async{
    var installTTTT = InstallTTTT();
    await installTTTT.createData();
    return installTTTT.toJson(logId);
  }

  Future<Map<String,dynamic>> _getHeaderMap()async{
    var tttt = HeaderTTTT();
    await tttt.createData();
    return tttt.toJson();
  }

  Future<String> _getPath(String logId)async{
    var tttt = QueryTTTT();
    await tttt.createData();
    var map = tttt.toJson(logId);
    StringBuffer stringBuffer=StringBuffer();
    map.forEach((key,value){
      stringBuffer.write("$key=$value&");
    });
    return "$tbaUrl?${stringBuffer.toString().substring(0,stringBuffer.toString().length-1)}";
  }
}