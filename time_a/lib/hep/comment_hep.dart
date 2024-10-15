import 'package:time_a/hep/sql/sql_hep_a.dart';
import 'package:time_base/hep/heppppp.dart';
import 'package:time_base/hep/save/qt_save.dart';

const QtSaveKey<String> answer3LastShowTimerBean = QtSaveKey(key: "answer3LastShowTimerA", de: "");
const QtSaveKey<String> answer5LastShowTimerBean = QtSaveKey(key: "answer5LastShowTimerA", de: "");
const QtSaveKey<bool> alreadyCommentBean = QtSaveKey(key: "alreadyCommentA", de: false);

class CommentHep{
  factory CommentHep()=>_getInstance();
  static CommentHep get instance=>_getInstance();
  static CommentHep? _instance;
  static CommentHep _getInstance(){
    _instance??=CommentHep._internal();
    return _instance!;
  }

  CommentHep._internal();

  checkShowCommentDialog()async{
    if(alreadyCommentBean.getV()){
      return;
    }
    var todayStr = getTodayStr();
    var todayAnswerNum = await SqlHepA.instance.queryTodayAnswerNum();
    if(todayAnswerNum==3&&answer3LastShowTimerBean.getV()!=todayStr){
      _showCommentDialog();
      answer3LastShowTimerBean.putV(todayStr);
      return;
    }
    if(todayAnswerNum==5&&answer5LastShowTimerBean.getV()!=todayStr){
      _showCommentDialog();
      answer5LastShowTimerBean.putV(todayStr);
      return;
    }
  }

  _showCommentDialog(){
    // CommentDialog(
    //   call: (stars)async{
    //     alreadyCommentBean.putV(true);
    //     if(stars<3){
    //       CommentSuccessDialog().show();
    //     }else{
    //       // InfoHep.instance.addCoins(0.5);
    //       var instance = InAppReview.instance;
    //       var result = await instance.isAvailable();
    //       if(result){
    //         instance.requestReview();
    //       }
    //     }
    //   },
    // ).show();
  }
}