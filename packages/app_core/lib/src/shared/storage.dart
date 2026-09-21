import 'package:shared_preferences/shared_preferences.dart';

/// Key-value persistence.
///
/// An interface rather than a direct `SharedPreferences` call so a test can
/// pass a fake without touching platform channels, and so swapping the backing
/// store later is one class instead of a grep.
abstract interface class Storage {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

/// [Storage] backed by `shared_preferences`.
///
/// Use this for non-sensitive values only. Tokens and credentials belong in
/// secure storage.
class PreferencesStorage implements Storage {
  const PreferencesStorage();

  @override
  Future<String?> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  @override
  Future<void> write(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  @override
  Future<void> delete(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
