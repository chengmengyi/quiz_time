import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_a/dia/cash_success.dart';
import 'package:time_a/dia/input_card.dart';
import 'package:time_a/dia/no_money.dart';
import 'package:time_a/dia/task_guide.dart';
import 'package:time_a/hep/call_listener/call_listener_hep.dart';
import 'package:time_a/hep/call_listener/update_task_listener.dart';
import 'package:time_a/hep/info_hep.dart';
import 'package:time_a/hep/sign/sign_hep.dart';
import 'package:time_a/hep/sql/sql_hep_a.dart';
import 'package:time_a/hep/task/task_bean.dart';
import 'package:time_a/hep/task/task_hep.dart';
import 'package:time_a/hep/value_hep.dart';
import 'package:time_a/home/cash/pay_type_bean.dart';
import 'package:time_a/home/finger_w.dart';
import 'package:time_base/hep/heppppp.dart';
import 'package:time_base/hep/sql/pay_type.dart';
import 'package:time_base/quiz_language/local_text.dart';
import 'package:time_base/w/qt_image.dart';
import 'package:time_base/w/ws_text.dart';


class CashChild extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _CashChildState();
}

class _CashChildState extends State<CashChild> implements UpdateTaskListener{
  var completedTask=false,showCashBtnFinger=false;
  var selectedPayType=payTypeIndexBean.getV().toPayType(),chooseMoneyIndex=chooseMoneyIndexBean.getV();
  List<int> moneyList=ValueHepA.instance.getCashMoneyList();
  List<TaskBean> taskList=[];
  List<PayTypeBean> payTypeList=[];

  @override
  void initState() {
    super.initState();
    _initPayTypeList();
    CallListenerHep.instance.updateTaskProgressListener(this);
    SignHep.instance.sign();
    coinsBean.listen((v){
      setState(() {});
      _checkShowCashFinger();
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
        LocalText.myBalance.tr,
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
                child: QtText(LocalText.winning100.tr, fontSize: 12.sp, color: Colors.black, fontWeight: FontWeight.w400,),
              ),
            ),
            Positioned(
              top: 8.h,
              right: 12.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      QtImage("moneya",w: 28.w,h: 28.w,),
                      SizedBox(width: 2.w,),
                      QtText(formatCoins(InfoHep.instance.userCoins), fontSize: 24.sp, color: Colors.white, fontWeight: FontWeight.w500,)
                    ],
                  ),
                  QtText("=${moneyDou2Str(coinsBean.getV()/ValueHepA.instance.getConversion())}", fontSize: 24.sp, color: Colors.white, fontWeight: FontWeight.w500,)
                ],
              ),
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
            _checkShowCashFinger();
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
        LocalText.chooseWithdrawAmount.tr,
        fontSize: 16.sp,
        color: const Color(0xff955B17),
        fontWeight: FontWeight.w500,
      ),
      SizedBox(height: 8.h,),
      // _chooseMoneyLargeWidget(),
      _chooseMoneySmallWidget(context),
    ],
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
              _checkShowCashFinger();
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
                    moneyDou2Str(moneyList[index]/ValueHepA.instance.getConversion()),
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
                QtText(LocalText.completeTaskSpeedUpWithdrawals.tr, fontSize: 10.sp, color: const Color(0xff774607), fontWeight: FontWeight.w500,),
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
          QtText(LocalText.trueAndReliable.tr, fontSize: 12.sp, color: const Color(0xffA36B21), fontWeight: FontWeight.w400,),
        ],
      ),
      SizedBox(height: 8.h,),
      InkWell(
        onTap: (){
          _clickCashBtn();
        },
        child: SizedBox(
          width: 220.w,
          height: 56.h,
          child: Stack(
            children: [
              QtImage("btn",w: 220.w,h: 56.h,),
              Align(
                alignment: Alignment.center,
                child: QtText(completedTask?LocalText.successful.tr:LocalText.withdraw.tr, fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.w500,),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Visibility(
                  visible: showCashBtnFinger,
                  child: FingerW(width: 40.w,height: 40.w,),
                ),
              )
            ],
          ),
        ),
      ),
      SizedBox(height: 8.h,),
      QtText(LocalText.tipsCashWillArrive.tr, fontSize: 10.sp, color: const Color(0xffA36B21), fontWeight: FontWeight.w400,textAlign: TextAlign.center,)
    ],
  );

  _clickCashBtn()async{
    var chooseMoney = moneyList[chooseMoneyIndex];
    if(completedTask){
      CashSuccessDialog(chooseMoney: chooseMoney).show();
      return;
    }
    var cashTaskList = await SqlHepA.instance.queryTaskRecordByPayTypeAndChooseMoney(selectedPayType, chooseMoney);
    if(cashTaskList.isNotEmpty){
      _showTaskDialog();
      return;
    }

    if(InfoHep.instance.userCoins<chooseMoney){
      NoMoneyDialog().show();
      return;
    }
    InputCardDialog(
      chooseMoney: chooseMoney,
      call: (card)async{
        var result = await SqlHepA.instance.insertTaskRecord(selectedPayType, chooseMoney, card);
        if(result){
          InfoHep.instance.addCoins(-(chooseMoney.toDouble()));
          await _initTaskList();
          _showTaskDialog();
        }
      },
    ).show();
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
    if(v==PayType.zalo.name){
      return "bg_zalo";
    }
    if(v==PayType.ovo.name){
      return "bg_ovo";
    }
    if(v==PayType.dana.name){
      return "bg_dana";
    }
    if(v==PayType.truemoney.name){
      return "bg_true";
    }
    if(v==PayType.gcash.name){
      return "bg_gcash";
    }
    if(v==PayType.coins.name){
      return "bg_coins";
    }
    if(v==PayType.yoomoney.name){
      return "bg_yoo";
    }
    if(v==PayType.momo.name){
      return "bg_momo";
    }
    if(v==PayType.pix.name){
      return "bg_pix";
    }
    if(v==PayType.pagbank.name){
      return "bg_pag";
    }
    return "bg_paypal";
  }

  @override
  updateTask() {
    _initTaskList();
  }

  _checkShowCashFinger()async{
    var chooseMoney = moneyList[chooseMoneyIndex];
    if(InfoHep.instance.userCoins<chooseMoney){
      if(showCashBtnFinger){
        setState(() {
          showCashBtnFinger=false;
        });
      }
      return;
    }
    var list = await SqlHepA.instance.queryTaskRecordByPayTypeAndChooseMoney(selectedPayType, chooseMoney);
    setState(() {
      showCashBtnFinger=list.isEmpty;
    });
  }

  _initPayTypeList(){
    switch(Get.deviceLocale?.countryCode??"US"){
      case "BR":
        payTypeList=[
          PayTypeBean(payType: PayType.pix, icon: "pix_large"),
          PayTypeBean(payType: PayType.pagbank, icon: "pag_large"),
        ];
        break;
      case "VN":
        payTypeList=[
          PayTypeBean(payType: PayType.zalo, icon: "zalo_large"),
          PayTypeBean(payType: PayType.momo, icon: "momo_large"),
        ];
        break;
      case "ID":
        payTypeList=[
          PayTypeBean(payType: PayType.ovo, icon: "ovo_large"),
          PayTypeBean(payType: PayType.dana, icon: "dana_large"),
        ];
        break;
      case "TH":
        payTypeList=[
          PayTypeBean(payType: PayType.truemoney, icon: "truemoney_large"),
        ];
        break;
      case "RU":
        payTypeList=[
          PayTypeBean(payType: PayType.yoomoney, icon: "yoy_large"),
        ];
        break;
      case "PH":
        payTypeList=[
          PayTypeBean(payType: PayType.gcash, icon: "gcash_large"),
          PayTypeBean(payType: PayType.coins, icon: "coins_large"),
        ];
        break;
      default:
        payTypeList=[
          PayTypeBean(payType: PayType.paypal, icon: "paypal_large"),
          PayTypeBean(payType: PayType.amazon, icon: "ama_large"),
          PayTypeBean(payType: PayType.gp, icon: "gp_large"),
          PayTypeBean(payType: PayType.mastercard, icon: "mas_large"),
          PayTypeBean(payType: PayType.cashApp, icon: "cash_large"),
          PayTypeBean(payType: PayType.webMoney, icon: "web_large"),
        ];
        break;
    }

    var indexWhere = payTypeList.indexWhere((value)=>value.payType==selectedPayType);
    if(indexWhere<0){
      selectedPayType=payTypeList.first.payType;
      payTypeIndexBean.putV(selectedPayType.name);
    }
  }
}