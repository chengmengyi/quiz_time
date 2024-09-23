import 'package:in_app_review/in_app_review.dart';
import 'package:quiztime55/b/dia/comment/comment.dart';
import 'package:quiztime55/b/dia/comment/comment_success.dart';
import 'package:quiztime55/b/hep/heppppp.dart';
import 'package:quiztime55/b/hep/info_hep.dart';
import 'package:quiztime55/b/hep/sql/sql_hep.dart';
import 'package:quiztime55/global/appd/qt_save.dart';

const QtSaveKey<String> answer3LastShowTimerBean = QtSaveKey(key: "answer3LastShowTimer", de: "");
const QtSaveKey<String> answer5LastShowTimerBean = QtSaveKey(key: "answer5LastShowTimer", de: "");
const QtSaveKey<bool> alreadyCommentBean = QtSaveKey(key: "alreadyComment", de: false);

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
    var todayAnswerNum = await SqlHep.instance.queryTodayAnswerNum();
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
    CommentDialog(
      call: (stars)async{
        alreadyCommentBean.putV(true);
        if(stars<3){
          CommentSuccessDialog().show();
        }else{
          InfoHep.instance.addCoins(0.5);
          var instance = InAppReview.instance;
          var result = await instance.isAvailable();
          if(result){
            instance.requestReview();
          }
        }
      },
    ).show();
  }
}