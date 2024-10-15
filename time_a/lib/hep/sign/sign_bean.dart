class SignBean{
  String? signTimer;
  SignBean({
    required this.signTimer,
});
  Map<String,dynamic> toJson()=>{
    "signTimer":signTimer
  };


  SignBean.fromJson(dynamic json) {
    signTimer = json['signTimer'];
  }

  @override
  String toString() {
    return 'SignBean{signTimer: $signTimer}';
  }
}