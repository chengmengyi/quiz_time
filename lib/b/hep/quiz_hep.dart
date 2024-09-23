import 'package:quiztime55/b/hep/sql/sql_hep.dart';
import 'package:quiztime55/b/hep/task/task_hep.dart';
import 'package:quiztime55/global/appd/qt_quiz_hep.dart';
import 'package:quiztime55/global/appd/qt_save.dart';

const QtSaveKey<String> currentCategoryBean = QtSaveKey(key: "currentCategory", de: QtQuizHep.QH_NK_M);
const QtSaveKey<int> currentQuizIndexBean = QtSaveKey(key: "currentQuizIndex", de: 0);
const QtSaveKey<int> answerRightBean = QtSaveKey(key: "answerRightBean", de: 0);

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

  updateAnswerRight(){
    answerRightNum++;
    answerRightBean.putV(answerRightNum);
    SqlHep.instance.updateTaskCompletedNumRecord(TaskType.quiz);
  }
}