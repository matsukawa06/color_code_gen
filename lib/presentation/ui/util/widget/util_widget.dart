import 'package:flutter/material.dart';

///
/// Widget間のスペース（マージン）をSpaceBoxで調整する
///
class SpaceBox extends SizedBox {
  const SpaceBox({super.key, double super.width = 8, double super.height = 8});

  const SpaceBox.width({super.key, double value = 8}) : super(width: value);
  const SpaceBox.height(int i, {super.key, double value = 8}) : super(height: value);
}
