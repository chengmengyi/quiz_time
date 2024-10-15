import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:time_base/hep/tttt/base_tttt.dart';

class InstallTTTT{
  String? menfolk;
  String? cluj;
  String? giveth;
  String? brindle;
  String? seagull;
  int? laze;
  int? richter;
  int? porphyry;
  int? depth;
  int? sumner;
  int? joyride;
  bool? succinct;

  createData()async{
    var referrerMap = await FlutterTbaInfo.instance.getReferrerMap();
    menfolk=referrerMap["build"];
    cluj=referrerMap["referrer_url"];
    giveth=referrerMap["install_version"];
    brindle=referrerMap["user_agent"];
    seagull="ragusan";
    laze=referrerMap["referrer_click_timestamp_seconds"];
    richter=referrerMap["install_begin_timestamp_seconds"];
    porphyry=referrerMap["referrer_click_timestamp_server_seconds"];
    depth=referrerMap["install_begin_timestamp_server_seconds"];
    sumner=referrerMap["install_first_seconds"];
    joyride=referrerMap["last_update_seconds"];
    succinct=referrerMap["google_play_instant"];
  }


  Future<Map<String,dynamic>> toJson(String logId) async{
    var base = BaseTttt();
    await base.createData(logId);
    var baseMap = base.toJson();
    baseMap["teddy"]={
      "menfolk":menfolk,
      "cluj":cluj,
      "giveth":giveth,
      "brindle":brindle,
      "seagull":seagull,
      "laze":laze,
      "richter":richter,
      "porphyry":porphyry,
      "depth":depth,
      "sumner":sumner,
      "joyride":joyride,
      "succinct":succinct,
    };
    return baseMap;
  }
}