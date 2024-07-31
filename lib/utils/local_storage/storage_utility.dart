import 'package:get_storage/get_storage.dart';

class TLocalStorage {
  static final TLocalStorage _instance = TLocalStorage._internal();

  factory TLocalStorage() {
    return _instance;
  }

  TLocalStorage._internal();

  final _storage = GetStorage();

  // save data method
  Future<void> saveData<T>(String key, T value) async {
    await _storage.write(key, value);
  }

  // read data method
  T? readData<T>(String key) {
    return _storage.read<T>(key);
  }

  // remove data method
  Future<void> removeData<T>(String key, T value) async {
    await _storage.remove(key);
  }

  // Clear all data method
  Future<void> clearAll() async {
    await _storage.erase();
  }
}