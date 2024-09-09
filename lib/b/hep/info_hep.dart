import 'package:decimal/decimal.dart';
import 'package:quiztime55/global/appd/qt_save.dart';

const QtSaveKey<double> coinsBean = QtSaveKey(key: "coinsBean", de: 0.0);
const QtSaveKey<String> progressReceivedBean = QtSaveKey(key: "progressReceived", de: "");
const QtSaveKey<bool> receivedBubbleBean = QtSaveKey(key: "receivedBubble", de: false);

class InfoHep{
  factory InfoHep()=>_getInstance();
  static InfoHep get instance=>_getInstance();
  static InfoHep? _instance;
  static InfoHep _getInstance(){
    _instance??=InfoHep._internal();
    return _instance!;
  }

  var userCoins=0.0,bubbleShowTime=10;
  final List<String> _progressReceivedList=[];

  InfoHep._internal(){
    userCoins=coinsBean.getV();
    _initProgressReceivedList();
  }

  addCoins(double add){
    userCoins=(Decimal.parse("$add")+Decimal.parse("$userCoins")).toDouble();
    coinsBean.putV(userCoins);
  }

  _initProgressReceivedList(){
    try{
      _progressReceivedList.clear();
      _progressReceivedList.addAll(progressReceivedBean.getV().split("|"));
    }catch(e){

    }
  }

  updateProgressReceivedList(int index){
    _progressReceivedList.add("$index");
    progressReceivedBean.putV(_progressReceivedList.join("|"));
  }

  bool checkProgressReceived(int index)=>_progressReceivedList.contains("$index");
}