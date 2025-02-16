import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoritPageProvider = ChangeNotifierProvider(
  (ref) => FavoritPageProvider(ref),
);

class FavoritPageProvider extends ChangeNotifier {
  FavoritPageProvider(this.ref);
  final Ref ref;

  ///
  /// 初期設定
  ///
  initialize() async {}
}
