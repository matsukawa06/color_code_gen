import 'package:color_code_gen/models/favorit_store.dart';
import 'package:color_code_gen/presentation/controller/color_controller.dart';
import 'package:color_code_gen/presentation/ui/color_picker.dart';
import 'package:color_code_gen/repository/favorit_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///
/// カラー選択ページのProvider
///
final colorSearchProvider = ChangeNotifierProvider(
  (ref) => ColorSearchProvider(ref),
);

class ColorSearchProvider extends ChangeNotifier {
  ColorSearchProvider(this.ref);
  final Ref ref;
  late FavoritStore favoritStore;

  ///
  /// お気に入りアイコンクリック時
  ///
  onPressedFavoritIcon() async {
    final repository = ref.watch(favoritRepository);
    final controller = CircleColorPickerController();
    if (ref.watch(colorController).isFavorit) {
      // 新規追加
      var favorit = FavoritStore(
        title: '',
        colorCode: controller.color.value,
        sortNo: await repository.getListCount(),
      );
      final insertedId = await repository.insert(favorit);
    } else {
      // 削除
    }

    notifyListeners();
  }
}
