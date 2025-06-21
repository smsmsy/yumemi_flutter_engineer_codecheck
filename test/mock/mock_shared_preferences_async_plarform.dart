import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_platform_interface/types.dart';

/// SharedPreferencesAsyncPlatformのモック実装
final class MockSharedPreferencesAsyncPlatform
    extends SharedPreferencesAsyncPlatform {
  final Map<String, Object?> _store = {};

  @override
  Future<void> setInt(
    String key,
    int value,
    SharedPreferencesOptions options,
  ) async {
    _store[key] = value;
  }

  @override
  Future<int?> getInt(String key, SharedPreferencesOptions options) async {
    return _store[key] as int?;
  }

  @override
  Future<void> clear(
    ClearPreferencesParameters parameters,
    SharedPreferencesOptions options,
  ) {
    // TODO: implement clear
    throw UnimplementedError();
  }

  @override
  Future<bool?> getBool(String key, SharedPreferencesOptions options) {
    // TODO: implement getBool
    throw UnimplementedError();
  }

  @override
  Future<double?> getDouble(String key, SharedPreferencesOptions options) {
    // TODO: implement getDouble
    throw UnimplementedError();
  }

  @override
  Future<Set<String>> getKeys(
    GetPreferencesParameters parameters,
    SharedPreferencesOptions options,
  ) {
    // TODO: implement getKeys
    throw UnimplementedError();
  }

  @override
  Future<Map<String, Object>> getPreferences(
    GetPreferencesParameters parameters,
    SharedPreferencesOptions options,
  ) {
    // TODO: implement getPreferences
    throw UnimplementedError();
  }

  @override
  Future<String?> getString(String key, SharedPreferencesOptions options) {
    // TODO: implement getString
    throw UnimplementedError();
  }

  @override
  Future<List<String>?> getStringList(
    String key,
    SharedPreferencesOptions options,
  ) {
    // TODO: implement getStringList
    throw UnimplementedError();
  }

  @override
  Future<void> setBool(
    String key,
    bool value,
    SharedPreferencesOptions options,
  ) {
    // TODO: implement setBool
    throw UnimplementedError();
  }

  @override
  Future<void> setDouble(
    String key,
    double value,
    SharedPreferencesOptions options,
  ) {
    // TODO: implement setDouble
    throw UnimplementedError();
  }

  @override
  Future<void> setString(
    String key,
    String value,
    SharedPreferencesOptions options,
  ) {
    // TODO: implement setString
    throw UnimplementedError();
  }

  @override
  Future<void> setStringList(
    String key,
    List<String> value,
    SharedPreferencesOptions options,
  ) {
    // TODO: implement setStringList
    throw UnimplementedError();
  }
}
