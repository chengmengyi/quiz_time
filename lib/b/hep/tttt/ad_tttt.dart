import 'package:flutter_max_ad/ad/ad_bean/max_ad_bean.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/export.dart';
import 'package:quiztime55/b/hep/ad/ad_pppp.dart';
import 'package:quiztime55/b/hep/tttt/base_tttt.dart';

class AdTTTT{
  Future<Map<String,dynamic>> toJson(String logId,MaxAd? maxAd,MaxAdInfoBean? maxInfoBean,AdPPPP adPPPP,AdType adFFFF)async{
    var baseTttt = BaseTttt();
    await baseTttt.createData(logId);
    var baseMap = baseTttt.toJson();
    baseMap["kneecap"]={
      "glacial":(maxAd?.revenue??0)*1000000,
      "xerox":"USD",
      "chic":maxAd?.networkName??"",
      "quote":maxInfoBean?.plat??"",
      "deport":maxInfoBean?.id??"",
      "methyl":adPPPP.name,
      "booky":adFFFF==AdType.reward?"rv":"rv",
      "freshen":maxAd?.revenuePrecision??"",
    };
    return baseMap;
  }
}