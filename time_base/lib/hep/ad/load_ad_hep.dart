import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_max_ad/ad/ad_bean/max_ad_bean.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:synchronized/synchronized.dart';
import 'package:time_base/hep/check_type/check_type_hep.dart';
import 'package:time_base/hep/heppppp.dart';


class LoadAdHep{
  factory LoadAdHep()=>_getInstance();
  static LoadAdHep get instance=>_getInstance();
  static LoadAdHep? _instance;
  static LoadAdHep _getInstance(){
    _instance??=LoadAdHep._internal();
    return _instance!;
  }

  LoadAdHep._internal();

  final Lock _lock = Lock();

  loadAd()async{
    _getAdStr((ad){
      var json = jsonDecode(ad);
      FlutterMaxAd.instance.initMax(
        maxKey: strBase64Decode(maxKeyBase64),
        maxAdBean: _getMaxAd(json),
        logFacebookPurchase: true,
        topOnAppId: strBase64Decode(toponId),
        topOnAppKey: strBase64Decode(toponKey),
      );
    });
  }
  
  _getAdStr(Function(String ad) call)async{
    var v = localAdBean.getV();
    if(v.isNotEmpty){
      call.call(v);
      return;
    }
    await _lock.synchronized(() async {
      var localAd = await rootBundle.loadString("qtf/f2/ad.txt");
      call.call(strBase64Decode(localAd));
    });
  }

  List<MaxAdInfoBean> _getAdListByType(json,adLocationName){
    try{
      List<MaxAdInfoBean> adList=[];
      for(var value in json){
        var type = value["daxvnlhf"];
        var bean = MaxAdInfoBean(
            id: value["cxdresza"],
            plat: value["qetuoljg"],
            adType: type=="interstitial"?AdType.inter:type=="native"?AdType.native:AdType.reward,
            expire: value["fhiursnj"],
            sort: value["osnenhfq"],
            adLocationName: adLocationName
        );
        adList.add(bean);
      }
      return adList;
    }catch(e){
      return [];
    }
  }

  resetMaxInfo(){
    _getAdStr((ad){
      var json = jsonDecode(ad);
      FlutterMaxAd.instance.setMaxAdInfo(_getMaxAd(json));
    });
  }

  MaxAdBean _getMaxAd(json){
    var intAd1 = _getAdListByType(json["kztym_int_one"], "kztym_int_one");
    var intAd2 = _getAdListByType(json["kztym_int_two"], "kztym_int_two");
    var rvAd1 = _getAdListByType(json["kztym_rv_one"], "kztym_rv_one");
    var rvAd2 = _getAdListByType(json["kztym_rv_two"], "kztym_rv_two");
    return MaxAdBean(
      maxShowNum: json["mlpokjiu"],
      maxClickNum: json["hnbvgytf"],
      firstRewardedAdList: rvAd1,
      secondRewardedAdList:rvAd2,
      firstInterAdList: intAd1,
      secondInterAdList: intAd2,
    );
  }
}