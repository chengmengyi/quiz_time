import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiztime55/b/dia/cash_success.dart';
import 'package:quiztime55/b/dia/input_card.dart';
import 'package:quiztime55/b/dia/no_money.dart';
import 'package:quiztime55/b/dia/task_guide.dart';
import 'package:quiztime55/b/hep/call_listener/call_listener_hep.dart';
import 'package:quiztime55/b/hep/call_listener/update_task_listener.dart';
import 'package:quiztime55/b/hep/heppppp.dart';
import 'package:quiztime55/b/hep/info_hep.dart';
import 'package:quiztime55/b/hep/sign/sign_hep.dart';
import 'package:quiztime55/b/hep/sql/pay_type.dart';
import 'package:quiztime55/b/hep/sql/sql_hep.dart';
import 'package:quiztime55/b/hep/task/task_bean.dart';
import 'package:quiztime55/b/hep/task/task_hep.dart';
import 'package:quiztime55/b/hep/tttt/point_name.dart';
import 'package:quiztime55/b/hep/tttt/tttt_hep.dart';
import 'package:quiztime55/b/hep/value_hep.dart';
import 'package:quiztime55/b/home/cash/pay_type_bean.dart';
import 'package:quiztime55/global/widg/qt_image.dart';
import 'package:quiztime55/global/widg/ws_text.dart';

class CashChild extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _CashChildState();
}

class _CashChildState extends State<CashChild> implements UpdateTaskListener{
  var completedTask=false;
  var selectedPayType=payTypeIndexBean.getV().toPayType(),chooseMoneyIndex=chooseMoneyIndexBean.getV();
  List<int> moneyList=ValueHep.instance.getCashMoneyList();
  List<TaskBean> taskList=[];
  List<PayTypeBean> payTypeList=[
    PayTypeBean(payType: PayType.paypal, icon: "paypal_large"),
    PayTypeBean(payType: PayType.amazon, icon: "ama_large"),
    PayTypeBean(payType: PayType.gp, icon: "gp_large"),
    PayTypeBean(payType: PayType.mastercard, icon: "mas_large"),
    PayTypeBean(payType: PayType.cashApp, icon: "cash_large"),
    PayTypeBean(payType: PayType.webMoney, icon: "web_large"),
  ];

  @override
  void initState() {
    super.initState();
    CallListenerHep.instance.updateTaskProgressListener(this);
    SignHep.instance.sign();
    coinsBean.listen((v){
      setState(() {});
    });
    Future((){
      _initTaskList();
    });
  }

  @override
  Widget build(BuildContext context) =>SafeArea(
    top: true,
    bottom: false,
    child: Column(
      children: [
        _payListWidget(),
        Expanded(
          child: Stack(
            children: [
              const QtImage("jnmnwkmf",w: double.infinity,h: double.infinity,),
              Container(
                padding: EdgeInsets.only(left: 20.w,right: 20.w,top: 34.h,bottom: 104.h),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _myMoneyWidget(),
                      SizedBox(height: 16.h,),
                      _chooseMoneyWidget(context),
                      SizedBox(height: 26.h,),
                      _btnWidget(),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    ),
  );

  _myMoneyWidget()=>Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      QtText(
        "My Balance",
        fontSize: 16.sp,
        color: const Color(0xff955B17),
        fontWeight: FontWeight.w500,
      ),
      SizedBox(height: 8.h,),
      SizedBox(
        width: double.infinity,
        height: 112.h,
        child: Stack(
          children: [
            QtImage(_getPayTypeBg(),w: double.infinity,h: 112.h,),
            Positioned(
              top: 16.h,
              child: Container(
                padding: EdgeInsets.only(left: 4.w,right: 4.w,top: 3.h,bottom: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12.w),
                    bottomRight: Radius.circular(12.w),
                  )
                ),
                child: QtText("100% Winning", fontSize: 12.sp, color: Colors.black, fontWeight: FontWeight.w400,),
              ),
            ),
            Positioned(
              top: 8.h,
              right: 12.w,
              child: QtText("\$${InfoHep.instance.userCoins}", fontSize: 32.sp, color: Colors.white, fontWeight: FontWeight.w500,),
            )
          ],
        ),
      )
    ],
  );

  _payListWidget()=>SizedBox(
    width: double.infinity,
    height: 48.h,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: payTypeList.length,
      itemBuilder: (context,index){
        var bean = payTypeList[index];
        var selected = selectedPayType==bean.payType;
        return InkWell(
          onTap: (){
            setState(() {
              selectedPayType=bean.payType;
              payTypeIndexBean.putV(selectedPayType.name);
            });
            _initTaskList();
          },
          child: Container(
            width: selected?128.w:108.w,
            height: 48.h,
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(left: 8.w),
            child: QtImage(bean.icon,w: selected?128.w:108.w,h: selected?48.h:36.h,),
          ),
        );
      },
    ),
  );

  _chooseMoneyWidget(BuildContext context)=>Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      QtText(
        "Choose Withdraw Amount",
        fontSize: 16.sp,
        color: const Color(0xff955B17),
        fontWeight: FontWeight.w500,
      ),
      SizedBox(height: 8.h,),
      // _chooseMoneyLargeWidget(),
      _chooseMoneySmallWidget(context),
    ],
  );

  _chooseMoneyLargeWidget()=>SizedBox(
    width: double.infinity,
    height: 200.h,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: moneyList.length,
      itemBuilder: (context,index)=>InkWell(
        onTap: (){
          setState(() {
            chooseMoneyIndex=index;
          });
          chooseMoneyIndexBean.putV(chooseMoneyIndex);
        },
        child: Container(
          margin: EdgeInsets.only(right: 12.w),
          child: Stack(
            alignment: Alignment.center,
            children: [
              QtImage(chooseMoneyIndex==index?"hkjio":"nonkm",w: 152.w,h: 200.h,),
              QtText(
                "\$${moneyList[index]}",
                fontSize: 24.sp,
                color: chooseMoneyIndex==index?const Color(0xffFF7A00):const Color(0xffA77E42),
                fontWeight: FontWeight.w500,
              )
            ],
          ),
        ),
      ),
    ),
  );

  _chooseMoneySmallWidget(BuildContext context)=>Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        width: double.infinity,
        height: 80.h,
        child: ListView.builder(
          itemCount: moneyList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context,index)=>InkWell(
            onTap: (){
              setState(() {
                chooseMoneyIndex=index;
              });
              _initTaskList();
            },
            child: Container(
              width: 140.w,
              height: 80.h,
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 12.w),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  QtImage(
                    chooseMoneyIndex==index?"jiofjmo":"miomoeg",
                    w: 140.w,
                    h: chooseMoneyIndex==index?80.h:60.h,
                  ),
                  QtText(
                    "\$${moneyList[index]}",
                    fontSize: 24.sp,
                    color: chooseMoneyIndex==index?const Color(0xffFF7A00):const Color(0xffA77E42),
                    fontWeight: FontWeight.w500,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      SizedBox(height: 6.h,),
      _taskWidget(context),
    ],
  );

  _taskWidget(BuildContext context)=>Offstage(
    offstage: taskList.isEmpty,
    child: Container(
      width: double.infinity,
      height: 126.h,
      decoration: BoxDecoration(
          color: const Color(0xffD6A56C),
          borderRadius: BorderRadius.circular(16.w)
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Stack(
              alignment: Alignment.center,
              children: [
                QtImage("fju9ej",w: 260.w,h: 32.h,),
                QtText("Complete tasks，Speed up withdrawals", fontSize: 10.sp, color: const Color(0xff774607), fontWeight: FontWeight.w500,),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 42.h),
              padding: EdgeInsets.only(left: 12.w,right: 12.w),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: ListView.builder(
                  itemCount: taskList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context,index){
                    var bean = taskList[index];
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: QtText(
                                    bean.title,
                                    fontSize: 14.sp,
                                    color: const Color(0xff774607),
                                    fontWeight: FontWeight.w400,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                QtText(
                                  "(${bean.current}/${bean.total})",
                                  fontSize: 14.sp,
                                  color: const Color(0xff774607).withOpacity(0.6),
                                  fontWeight: FontWeight.w400,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 10.w,),
                          QtImage(bean.current>=bean.total?"mepfpef":"fnewfmow",w: 24.w,h: 24.w,),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );

  _btnWidget()=>Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          QtImage("jioegm",w: 16.w,h: 16.w,),
          SizedBox(width: 4.w,),
          QtText("True And Reliable", fontSize: 12.sp, color: const Color(0xffA36B21), fontWeight: FontWeight.w400,),
        ],
      ),
      SizedBox(height: 8.h,),
      InkWell(
        onTap: (){
          _clickCashBtn();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            QtImage("btn",w: 220.w,h: 56.h,),
            QtText(completedTask?"Successful":"Withdraw", fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.w500,)
          ],
        ),
      ),
      SizedBox(height: 8.h,),
      QtText("Tips：Cash will arrive in your account within 24 hours as soon as possible", fontSize: 10.sp, color: const Color(0xffA36B21), fontWeight: FontWeight.w400,textAlign: TextAlign.center,)
    ],
  );

  _clickCashBtn()async{
    TTTTHep.instance.pointEvent(PointName.cash_page_c);
    var chooseMoney = moneyList[chooseMoneyIndex];
    if(completedTask){
      CashSuccessDialog(chooseMoney: chooseMoney).show();
      return;
    }
    if(InfoHep.instance.userCoins<chooseMoney){
      TTTTHep.instance.pointEvent(PointName.cash_not_pop);
      NoMoneyDialog().show();
      return;
    }
    var firstCash = await SqlHep.instance.checkFirstCash(selectedPayType, chooseMoney);
    if(firstCash){
      InputCardDialog(
        chooseMoney: chooseMoney,
        call: (card)async{
          var result = await SqlHep.instance.insertTaskRecord(selectedPayType, chooseMoney, card);
          if(result){
            InfoHep.instance.addCoins(-(chooseMoney.toDouble()));
            await _initTaskList();
            _showTaskDialog();
          }
        },
      ).show();
      return;
    }
    _showTaskDialog();
  }

  _showTaskDialog(){
    var indexWhere = taskList.indexWhere((value)=>value.current<value.total);
    if(indexWhere>=0){
      var taskBean = taskList[indexWhere];
      TaskGuideDialog(
        chooseMoney: moneyList[chooseMoneyIndex],
        taskBean: taskBean,
      ).show();
      return;
    }
    TTTTHep.instance.pointEvent(PointName.cash_suc_pop);
    CashSuccessDialog(chooseMoney: moneyList[chooseMoneyIndex]).show();
  }

  Future<void> _initTaskList()async{
    var list = await TaskHep.instance.getTaskListByPayTypeAndChooseMoney(selectedPayType, moneyList[chooseMoneyIndex]);
    taskList.clear();
    taskList.addAll(list);
    completedTask=_checkHasCompletedTask();
    setState(() {});
  }

  bool _checkHasCompletedTask(){
    if(taskList.isEmpty){
      return false;
    }
    for (var value in taskList) {
      if(value.current<value.total){
        return false;
      }
    }
    return true;
  }

  String _getPayTypeBg(){
    var v = payTypeIndexBean.getV();
    if(v==PayType.paypal.name){
      return "bg_paypal";
    }
    if(v==PayType.amazon.name){
      return "bg_ama";
    }
    if(v==PayType.gp.name){
      return "bg_gp";
    }
    if(v==PayType.mastercard.name){
      return "bg_mas";
    }
    if(v==PayType.cashApp.name){
      return "bg_cash";
    }
    if(v==PayType.webMoney.name){
      return "bg_web";
    }
    return "bg_paypal";
  }

  @override
  updateTask() {
    _initTaskList();
  }
}