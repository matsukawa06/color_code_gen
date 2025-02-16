import 'package:color_code_gen/models/favorit_store.dart';
import 'package:color_code_gen/repository/favorit_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///
/// お気に入り用の状態クラス
///
final favoritController = ChangeNotifierProvider(
  (ref) => FavoritController(ref),
);

class FavoritController extends ChangeNotifier {
  FavoritController(this.ref);
  final Ref ref;

  // リスト
  List<FavoritStore> favoritlist = [];

  ///
  /// お気に入りリストの初期化
  ///
  Future<void> initialize() async {
    favoritlist = await ref.read(favoritRepository).getFavoritList();
    notifyListeners();
  }

  ///
  /// お気に入りの削除
  ///
  Future<void> delete(int colorCode) async {
    ref.read(favoritRepository).delete(colorCode);
    notifyListeners();
  }
}
