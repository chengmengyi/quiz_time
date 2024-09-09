import 'package:flutter/material.dart';

extension DPop on Widget {
  Future dPop(BuildContext context,{Color? barrierColor}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: barrierColor??Colors.black.withOpacity(0.8),
        builder: (context) {
          var dialog = Dialog(insetPadding: EdgeInsets.zero, backgroundColor: Colors.transparent, child: this);
          return PopScope(canPop: false, child: dialog);
        });
  }
}
