class QtEvent {
  static const String quizNk = "quizNk";

  static final Map<String, List<Function(dynamic value)>> _map = {};

  static Function() listen(String key, Function(dynamic value) f) {
    var list = _map[key] ??= [];
    list.add(f);

    return () {
      list.remove(f);
    };
  }

  static send(String key, [dynamic value]) {
    var list = _map[key] ??= [];
    for (var f in list) {
      f.call(value);
    }
  }
}