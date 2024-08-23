import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

final GetStorage _save = GetStorage();

const QtSaveKey<int> curK = QtSaveKey(key: "curK", de: 0);
const QtSaveKey<int> levelK = QtSaveKey(key: "levelK", de: 1);

//--
const QtSaveKey<int> freK = QtSaveKey(key: "freK", de: 5);

class QtSaveKey<T> {
  final String key;
  final T _de;

  const QtSaveKey({required this.key, required T de}) : _de = de;

  T def() => _de;

  putV(T v) {
    _save.write(key, v);
  }

  T getV() {
    return _save.read<T>(key) ?? _de;
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
      freK.putV(freK.def());
    }
  }
}
