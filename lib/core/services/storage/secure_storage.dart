import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _secureStore;

  SecureStorageService(FlutterSecureStorage store) : _secureStore = store;

  Future<void> writeData(String key, String value) async {
    try {
      await _secureStore.write(key: key, value: value);
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> readData(String key) async {
    try {
      final value = await _secureStore.read(key: key);
      return value;
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteData(String key) async {
    try {
      await _secureStore.delete(key: key);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearStore() async => await _secureStore.deleteAll();
}
