//
// テーマ変更用の状態クラス
//
import 'package:color_code_gen/common/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeController = ChangeNotifierProvider<ThemeController>(
  (ref) => ThemeController(),
);

class ThemeController extends ChangeNotifier {
  // SharedPreferences用のキー文字列
  final String _keyIsDark = 'isDark';
  // final String _keyMainColor = 'mainColor';

  // ダークモード関連
  ThemeMode mode = ThemeMode.light;
  bool isDark = false;
  // フォントカラー（ダークモード、ライトモードで切り替え）
  Color fontColor = Colors.black;

  // コンストラクタ
  ThemeController() {
    _getShaed();
  }

  // 端末保存情報の取得
  Future _getShaed() async {
    var prefs = await SharedPreferences.getInstance();
    // ダークモード
    isDark = prefs.getBool(_keyIsDark) ?? false;
    _lightOrDarkSetting();
  }

  // トグルでダークモードを切り替える関数を定義する
  brightnessToggle() {
    isDark = !isDark;
    _lightOrDarkSetting();
    // SharedPreferencesに保存
    Shared().saveBoolValue(_keyIsDark, isDark);
    notifyListeners();
  }

  // ダークモードでの設定内容
  _lightOrDarkSetting() {
    mode = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}
