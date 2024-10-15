
import 'package:time_b/hep/call_listener/change_home_tab_index_listener.dart';
import 'package:time_b/hep/call_listener/click_task_listener.dart';
import 'package:time_b/hep/call_listener/show_coins_animator_listener.dart';
import 'package:time_b/hep/call_listener/update_task_listener.dart';

class CallListenerHep{
  factory CallListenerHep()=>_getInstance();
  static CallListenerHep get instance=>_getInstance();
  static CallListenerHep? _instance;
  static CallListenerHep _getInstance(){
    _instance??=CallListenerHep._internal();
    return _instance!;
  }

  final List<ClickTaskListener> _taskListenerList=[];
  final List<UpdateTaskListener> _updateTaskListenerList=[];
  final List<ChangeHomeTabIndexListener> _changeHomeTabIndexListenerList=[];
  final List<ShowCoinsAnimatorListener> _showCoinsAnimatorListenerList=[];

  CallListenerHep._internal();

  clickTask(String taskType){
    for (var value in _taskListenerList) {
      value.clickTask(taskType);
    }
  }

  updateClickTaskListener(ClickTaskListener l){
    if(_taskListenerList.contains(l)){
      _taskListenerList.remove(l);
    }else{
      _taskListenerList.add(l);
    }
  }

  updateTaskProgressListener(UpdateTaskListener l){
    if(_updateTaskListenerList.contains(l)){
      _updateTaskListenerList.remove(l);
    }else{
      _updateTaskListenerList.add(l);
    }
  }

  updateTaskProgress(){
    for (var value in _updateTaskListenerList) {
      value.updateTask();
    }
  }

  updateChangeHomeTabIndexListener(ChangeHomeTabIndexListener l){
    if(_changeHomeTabIndexListenerList.contains(l)){
      _changeHomeTabIndexListenerList.remove(l);
    }else{
      _changeHomeTabIndexListenerList.add(l);
    }
  }

  changeHomeTab(int index){
    for (var value in _changeHomeTabIndexListenerList) {
      value.showHomeIndex(index);
    }
  }

  updateShowCoinsAnimatorListener(ShowCoinsAnimatorListener l){
    if(_showCoinsAnimatorListenerList.contains(l)){
      _showCoinsAnimatorListenerList.remove(l);
    }else{
      _showCoinsAnimatorListenerList.add(l);
    }
  }

  showCoinsAnimator(double totalCoinsNum){
    for (var value in _showCoinsAnimatorListenerList) {
      value.showAnimator(totalCoinsNum);
    }
  }
}