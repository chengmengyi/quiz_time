import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

final GetStorage _save = GetStorage();

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

