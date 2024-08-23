import 'package:flutter/cupertino.dart';

var gQtStr = QtStr();

String qtRepAs(String s, String as) {
  var rets = "";
  for (var e in s.characters) {
    if (e == "#") {
      rets += as;
    } else {
      rets += e;
    }
  }
  return rets;
}

class QtStr {
  String afwe = "Setting";
  String jrooe = "Privacy Policy";
  String hrew = "Term Of User";
  String btnr = "Contact Us";
  String hew = "Answer Is Right!";
  String gawr = "Get Reward";
  String nrew = "Continue";
  String nrer = "Sorry,Wrong Answer";
  String gaw = "OK";
  String hhew = "Answer Again";
  String nrree = "Congratulations";
  String hreh = "Upgrade To Level #";
  String hreww = "Do You Want Yo Continue The Challenge?";
  String hawwe = "Number Of Questions You Can Answer Today Has Reached The Limit. Please Try Again Tomorrow.";
  String heew = "Category";
}
