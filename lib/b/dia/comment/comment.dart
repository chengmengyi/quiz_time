import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiztime55/b/hep/heppppp.dart';
import 'package:quiztime55/b/home/finger_w.dart';
import 'package:quiztime55/global/widg/qt_image.dart';
import 'package:quiztime55/global/widg/ws_text.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CommentDialog extends StatefulWidget{
  Function(int) call;
  CommentDialog({required this.call});

  @override
  State<StatefulWidget> createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog>{
  var chooseIndex=-1;

  @override
  Widget build(BuildContext context)=>WillPopScope(
    child: Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          margin: EdgeInsets.only(left: 8.w,right: 8.w),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              QtImage("fefegsfd",w: double.infinity,h: 392.h,),
              Container(
                margin: EdgeInsets.only(top: 24.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    QtText("Give us a good review", fontSize: 24.sp, color: const Color(0xffFFFDF5), fontWeight: FontWeight.w600,),
                    SizedBox(height: 36.h,),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.w),
                      child: QtImage("fwfdsfsdf",w: 100.w,h: 100.h,),
                    ),
                    SizedBox(height: 12.h,),
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 36.w,right: 36.w),
                          child: StaggeredGridView.countBuilder(
                            itemCount: 5,
                            crossAxisCount: 5,
                            shrinkWrap: true,
                            mainAxisSpacing: 8.w,
                            crossAxisSpacing: 8.w,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(0),
                            itemBuilder: (context,index)=>InkWell(
                              onTap: (){
                                _clickItem(index);
                              },
                              child: QtImage(chooseIndex>=index?"fefewf":"wfewfewf",w: double.infinity,h: 48.h,),
                            ),
                            staggeredTileBuilder: (index)=>const StaggeredTile.fit(1),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.only(top: 24.h),
                            child: InkWell(
                              onTap: (){
                                _clickItem(4);
                              },
                              child: FingerW(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        QtText("complete reviews earn 5000", fontSize: 14.sp, color: const Color(0xffA36B21), fontWeight: FontWeight.w400,),
                        SizedBox(width: 4.w,),
                        QtImage("fmiowfow",w: 20.w,h: 20.w,)
                      ],
                    ),
                    SizedBox(height: 12.h,),
                    InkWell(
                      onTap: (){
                        _clickItem(4);
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          QtImage("btn",w: 220.w,h: 56.h,),
                          QtText("Give 5 Stars", fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.w500,),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  onTap: (){
                    closeDialog();
                  },
                  child: QtImage("icon_close",w: 40.w,h: 40.w,),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    onWillPop: ()async{
      return false;
    },
  );

  _clickItem(index){
    setState(() {
      chooseIndex=index;
    });
    Future.delayed(const Duration(milliseconds: 800),(){
      closeDialog();
      widget.call.call(index);
    });
  }
}