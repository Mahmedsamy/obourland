import 'package:shared_preferences/shared_preferences.dart';


class CacheHelper {
  static SharedPreferences? _prefs;


  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }


  static Future<bool> saveData({required String key, required dynamic value}) async {
    if (value is String) return _prefs!.setString(key, value);
    if (value is int) return _prefs!.setInt(key, value);
    if (value is bool) return _prefs!.setBool(key, value);
    return _prefs!.setString(key, value.toString());
  }


  static dynamic getData({required String key}) {
    return _prefs!.get(key);
  }


  static Future<bool> removeData({required String key}) async {
    return _prefs!.remove(key);
  }
}