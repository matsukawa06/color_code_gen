import 'package:flutter/material.dart';

///
/// お気に入りリストページ
///
class FavoritPage extends StatelessWidget {
  const FavoritPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _body(),
    );
  }

  //------------------------------
  // AppBar部
  //------------------------------
  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      title: const Text('お気に入り'),
    );
  }

  //------------------------------
  // Body部
  //------------------------------
  Widget _body() {
    return Container();
  }
}
