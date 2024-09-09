import 'package:quiztime55/b/hep/heppppp.dart';
import 'package:quiztime55/global/appd/qt_save.dart';

class NewUserGuideStep{
  static const String rightAnswerFinger="rightAnswerFinger";
  static const String cashDialog="cashDialog";
  static const String completed="completed";
}

class OldUserGuideStep{
  static const String oldUserDialog="oldUserDialog";
  static const String wheelDialog="wheelDialog";
  static const String signIncentDialog="signIncentDialog";
  static const String wheelIncentDialog="wheelIncentDialog";
  static const String completed="completed";
}

abstract class GuideListener{
  showRightAnswerFinger();
  showCashGuideDialog();
  showBubble();
  showOldUserDialog();
  showWheelDialog();
  showWheelIncentDialog(double addNum);
  showSignIncentDialog();
}

const QtSaveKey<String> newGuideBean = QtSaveKey(key: "newGuide", de: NewUserGuideStep.rightAnswerFinger);
const QtSaveKey<String> newGuideCompletedTimerBean = QtSaveKey(key: "newGuideCompletedTimer", de: "");
const QtSaveKey<String> oldGuideBean = QtSaveKey(key: "oldGuide", de: "");
const QtSaveKey<double> oldGuideWheelAddNumBean = QtSaveKey(key: "oldGuideWheelAddNumBean", de: 0.0);

class GuideHep {
  factory GuideHep()=>_getInstance();
  static GuideHep get instance=>_getInstance();
  static GuideHep? _instance;
  static GuideHep _getInstance(){
    _instance??=GuideHep._internal();
    return _instance!;
  }

  GuideHep._internal();
  GuideListener? _guideListener;

  setGuideListener(GuideListener l){
    _guideListener=l;
  }

  showGuide(){
    switch(newGuideBean.getV()){
      case NewUserGuideStep.rightAnswerFinger:
        _guideListener?.showRightAnswerFinger();
        break;
      case NewUserGuideStep.cashDialog:
        _guideListener?.showCashGuideDialog();
        break;
      case NewUserGuideStep.completed:
        _guideListener?.showBubble();
        if(newGuideCompletedTimerBean.getV()==getTodayStr()){
          return;
        }
        _checkOldGuide();
        break;
    }
  }

  _checkOldGuide(){
    switch(_getTodayOldGuideStep()){
      case OldUserGuideStep.oldUserDialog:
        _guideListener?.showOldUserDialog();
        break;
      case OldUserGuideStep.wheelDialog:
        _guideListener?.showWheelDialog();
        break;
      case OldUserGuideStep.wheelIncentDialog:
        _guideListener?.showWheelIncentDialog(oldGuideWheelAddNumBean.getV());
        break;
      case OldUserGuideStep.signIncentDialog:
        _guideListener?.showSignIncentDialog();
        break;
    }
  }

  updateNewGuide(String step){
    newGuideBean.putV(step);
    if(step==NewUserGuideStep.completed){
      newGuideCompletedTimerBean.putV(getTodayStr());
    }
    showGuide();
  }

  updateOldGuide(String step,{double? addNum}){
    oldGuideBean.putV("${getTodayStr()}_$step");
    if(step==OldUserGuideStep.wheelIncentDialog){
      oldGuideWheelAddNumBean.putV(addNum??0.0);
    }
    showGuide();
  }

  String _getTodayOldGuideStep(){
    try{
      var v = oldGuideBean.getV();
      var list = v.split("_");
      if(list.length==2&&list.first==getTodayStr()){
        return list.last;
      }
      return OldUserGuideStep.oldUserDialog;
    }catch(e){
      return OldUserGuideStep.completed;
    }
  }
}
