
import 'package:time_b/hep/sql/sql_hep_b.dart';
import 'package:time_b/hep/task/task_hep.dart';
import 'package:time_base/hep/heppppp.dart';
import 'package:time_base/hep/save/qt_quiz_hep.dart';
import 'package:time_base/hep/save/qt_save.dart';
import 'package:time_base/quiz_language/local_text.dart';

const QtSaveKey<String> currentCategoryBean = QtSaveKey(key: "currentCategoryB", de: QtQuizHep.QH_NK_M);
const QtSaveKey<int> currentQuizIndexBean = QtSaveKey(key: "currentQuizIndexB", de: 0);
const QtSaveKey<int> answerRightBean = QtSaveKey(key: "answerRightBeanB", de: 0);

class QuizHep{
  factory QuizHep()=>_getInstance();
  static QuizHep get instance=>_getInstance();
  static QuizHep? _instance;
  static QuizHep _getInstance(){
    _instance??=QuizHep._internal();
    return _instance!;
  }

  var currentCat=QtQuizHep.QH_NK_M,currentIndex=0,answerRightNum=0;

  QuizHep._internal(){
    currentCat=currentCategoryBean.getV();
    currentIndex=currentQuizIndexBean.getV();
    answerRightNum=answerRightBean.getV();
  }

  Map<String, dynamic>? getCurQuizMap()=>QtQuizHep.getItems(currentCat)?[currentIndex];

  updateNextQuiz(){
    currentIndex++;
    if(currentIndex>=(QtQuizHep.getItems(currentCat)??[]).length){
      currentIndex=0;
      switch(currentCat){
        case QtQuizHep.QH_NK_M:
          currentCat=QtQuizHep.QH_NK_A;
          currentCategoryBean.putV(QtQuizHep.QH_NK_A);
          break;
        case QtQuizHep.QH_NK_A:
          currentCat=QtQuizHep.QH_NK_N;
          currentCategoryBean.putV(QtQuizHep.QH_NK_N);
          break;
        case QtQuizHep.QH_NK_N:
          currentCat=QtQuizHep.QH_NK_S;
          currentCategoryBean.putV(QtQuizHep.QH_NK_S);
          break;
        case QtQuizHep.QH_NK_S:
          currentCat=QtQuizHep.QH_NK_H;
          currentCategoryBean.putV(QtQuizHep.QH_NK_H);
          break;
        case QtQuizHep.QH_NK_H:
          currentCat=QtQuizHep.QH_NK_M;
          currentCategoryBean.putV(QtQuizHep.QH_NK_M);
          break;
      }
    }
    currentQuizIndexBean.putV(currentIndex);
  }

  String getCatStr(){
    switch(currentCat){
      case QtQuizHep.QH_NK_M: return LocalText.math.tr;
      case QtQuizHep.QH_NK_A: return LocalText.animal.tr;
      case QtQuizHep.QH_NK_N: return LocalText.nature.tr;
      case QtQuizHep.QH_NK_S: return LocalText.science.tr;
      case QtQuizHep.QH_NK_H: return LocalText.history.tr;
      default: return "";
    }
  }

  updateAnswerRight(){
    answerRightNum++;
    answerRightBean.putV(answerRightNum);
    SqlHepB.instance.updateTaskCompletedNumRecord(TaskType.quiz);
  }
}