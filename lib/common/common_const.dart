import 'package:color_code_gen/presentation/ui/color_search/color_search_page.dart';
import 'package:color_code_gen/presentation/ui/favorit_page/favorit_page.dart';
import 'package:color_code_gen/presentation/ui/setting_page/setting_page.dart';
import 'package:flutter/material.dart';

//-----------------------------------
// 画面タブ
//-----------------------------------
enum TabItem {
  search(
    title: 'カラー検索',
    icon: Icons.search,
    page: ColorSearchPage(),
  ),
  favorit(
    title: 'お気に入り',
    icon: Icons.favorite,
    page: FavoritPage(),
  ),
  setting(
    title: '設定',
    icon: Icons.settings,
    page: SettingPage(),
  );

  const TabItem({
    required this.title,
    required this.icon,
    required this.page,
  });

  // タイトル
  final String title;
  // アイコン
  final IconData icon;
  // 画面
  final Widget page;
}

//-----------------------------------
// カラータイプ
//-----------------------------------
enum ColorCodeType {
  hex, // 16進数
  rgb,
  ;
}

//-----------------------------------
// 配色の種類
//-----------------------------------
enum ColorSchemeType {
  hanten,
  hoshoku,
  triad,
  split,
  ruiji,
  hueTint,
}

//-----------------------------------
// RGBの種類
//-----------------------------------
enum RGBType {
  r,
  g,
  b,
}
