// services/storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  static const _emailKey = 'saved_email';
  static const _rememberMeKey = 'remember_me';
  static const _driverIdKey = 'driver_id';
  static const _routeIdKey = 'route_id';
  static const _poIdKey = 'po_id';
  static const _sequenceIdKey = 'sequence_id';

  // Token management
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // Remember Me functionality
  static Future<void> saveRememberMe(bool value, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, value);
    if (value) {
      await prefs.setString(_emailKey, email);
    } else {
      await prefs.remove(_emailKey);
    }
  }

  static Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  static Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  static Future<void> clearSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emailKey);
    await prefs.remove(_rememberMeKey);
    await deleteToken();
  }

  /// Driver ID functions
  static Future<void> saveDriverId(int driverId) async {
    await _storage.write(key: _driverIdKey, value: driverId.toString());
  }

  static Future<int?> getDriverId() async {
    String? driverIdString = await _storage.read(key: _driverIdKey);
    if (driverIdString != null) {
      return int.tryParse(driverIdString);
    }
    return null;
  }

  static Future<void> deleteDriverId() async {
    await _storage.delete(key: _driverIdKey);
  }

  /// Route ID functions
  static Future<void> saveRouteId(int routeId) async {
    await _storage.write(key: _routeIdKey, value: routeId.toString());
  }

  static Future<int?> getRouteId() async {
    String? routeIdString = await _storage.read(key: _routeIdKey);
    if (routeIdString != null) {
      return int.tryParse(routeIdString);
    }
    return null;
  }

  static Future<void> deleteRouteId() async {
    await _storage.delete(key: _routeIdKey);
  }

  /// PO ID functions
  static Future<void> savePoId(int poId) async {
    await _storage.write(key: _poIdKey, value: poId.toString());
  }

  static Future<int?> getPoId() async {
    String? poIdString = await _storage.read(key: _poIdKey);
    if (poIdString != null) {
      return int.tryParse(poIdString);
    }
    return null;
  }

  static Future<void> deletePoId() async {
    await _storage.delete(key: _poIdKey);
  }

  /// Sequence ID functions
  static Future<void> saveSequenceId(int sequenceId) async {
    await _storage.write(key: _sequenceIdKey, value: sequenceId.toString());
  }

  static Future<int?> getSequenceId() async {
    String? sequenceIdString = await _storage.read(key: _sequenceIdKey);
    if (sequenceIdString != null) {
      return int.tryParse(sequenceIdString);
    }
    return null;
  }

  static Future<void> deleteSequenceId() async {
    await _storage.delete(key: _sequenceIdKey);
  }
}