import 'package:shared_preferences/shared_preferences.dart';

///
/// SharedPreferencesを使用する共通クラス
///
class Shared {
  ///
  /// ローカル設定を保存する
  ///
  Future saveIntValue(String key, int value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  Future saveBoolValue(String key, bool value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  Future saveStringValue(String key, String value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }
}
