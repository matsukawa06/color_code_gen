import 'package:color_code_gen/common/common_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///
/// カラー用の状態クラス
///
final colorController = ChangeNotifierProvider(
  (ref) => ColorController(ref),
);

class ColorController extends ChangeNotifier {
  ColorController(this.ref);
  final Ref ref;

  // カラー指定タイプ
  String colorCodeTypeSelected = ColorCodeType.hex.name;

  // カラー指定タイプ変更
  void changeColorCodeType(String color) {
    colorCodeTypeSelected = color;
    notifyListeners();
  }
}
