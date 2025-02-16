import 'package:color_code_gen/models/favorit_store.dart';
import 'package:color_code_gen/presentation/controller/favorit_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
}

//------------------------------
// Body部
//------------------------------
class _body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return FutureBuilder(
          future: ref.read(favoritController).initialize(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // 非同期処理未完了 = 通信中
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: <Widget>[
                // コンテンツ部
                _Content(),
              ],
            );
          },
        );
      },
    );
  }
}

///
/// コンテンツ部クラス
///
class _Content extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(favoritController);
    return Expanded(
      child: ReorderableListView(
        onReorder: (oldIndex, newIndex) {},
        children: controller.favoritlist.map((FavoritStore store) {
          return InkWell(
            key: Key(store.id.toString()),
            child: _listRowWidget(context, ref, store),
          );
        }).toList(),
      ),
    );
  }

  ///
  /// お気に入りのリスト
  ///
  Widget _listRowWidget(BuildContext context, WidgetRef ref, FavoritStore store) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, top: 1, bottom: 1),
      child: SizedBox(
        height: 80,
        child: Row(),
      ),
    );
  }
}
