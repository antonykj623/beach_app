import 'package:flutter/services.dart';

class NativeStorage {
  static const platform =
  MethodChannel('com.example.app/storage');

  /// Save data
  static Future<void> setValue(
      String key, String value) async {
    await platform.invokeMethod('setValue', {
      "key": key,
      "value": value,
    });
  }

  /// Get data
  static Future<String?> getValue(String key) async {
    final result = await platform.invokeMethod(
      'getValue',
      {"key": key},
    );
    return result;
  }
}