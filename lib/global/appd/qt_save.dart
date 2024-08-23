import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

final GetStorage _save = GetStorage();

const QtSaveKey<int> aa = QtSaveKey(key: "aa", de: 0);

class QtSaveKey<T> {
  final String key;
  final T de;

  const QtSaveKey({required this.key, required this.de});

  T def() => de;

  putV(T v) {
    _save.write(key, v);
  }

  T getV() {
    return _save.read<T>(key) ?? de;
  }

  addV(int operate) {
    var v = getV();
    if (v is int) {
      _save.write(key, v + operate);
    }
  }

  Function() listen(ValueSetter call) => _save.listenKey(key, call);
}

const QtSaveKey<String> _day = QtSaveKey(key: "dayRecode", de: "-");

initDay() {
  if (_day.getV() == "-") {
    _day.putV(DateFormat.yMd().format(DateTime.now()));
  } else {
    var newDay = DateFormat.yMd().format(DateTime.now());
    if (newDay != _day.getV()) {
      _day.putV(newDay);
    }
  }
}
