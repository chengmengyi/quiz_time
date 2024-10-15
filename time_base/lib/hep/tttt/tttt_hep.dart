import 'package:flutter_check_adjust_cloak/dio/dio_manager.dart';
import 'package:flutter_max_ad/ad/ad_bean/max_ad_bean.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/export.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:time_base/hep/check_type/check_type_hep.dart';
import 'package:time_base/hep/heppppp.dart';
import 'package:time_base/hep/save/qt_save.dart';
import 'package:time_base/hep/sql/sql_hep.dart';
import 'package:time_base/hep/tttt/ad_pppp.dart';
import 'package:time_base/hep/tttt/ad_tttt.dart';
import 'package:time_base/hep/tttt/base_tttt.dart';
import 'package:time_base/hep/tttt/header_tttt.dart';
import 'package:time_base/hep/tttt/install_tttt.dart';
import 'package:time_base/hep/tttt/point_name.dart';
import 'package:time_base/hep/tttt/point_tttt.dart';
import 'package:time_base/hep/tttt/query_tttt.dart';

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
      }else{
        SqlHep.instance.insertTbaData(sessionMap);
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
      }else{
        SqlHep.instance.insertTbaData(adMap);
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
      }else{
        SqlHep.instance.insertTbaData(pointMap);
      }
    }
  }

  uploadLocalTbaData()async{
    var list = await SqlHep.instance.queryTbaData();
    if(list.isNotEmpty){
      if(tba_console=="0"){
        SqlHep.instance.clearTbaTableData();
        return;
      }
      var logId = await FlutterTbaInfo.instance.getLogId();
      var headerMap = await _getHeaderMap();
      headerMap["Content-Encoding"]="gzip";
      var path = await _getPath(logId);
      var dioResult = await DioManager.instance.requestListPost(url: path, list: list,headerMap: headerMap);
      FlutterMaxAd.instance.printDebug("request tba event:upload local data--->result:${dioResult.success}--->params:$list");
      if(dioResult.success){
        SqlHep.instance.clearTbaTableData();
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