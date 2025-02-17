import 'package:color_code_gen/data/database.dart';
import 'package:color_code_gen/models/favorit_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

const String _tableName = 'favorit';

final favoritRepository = Provider((ref) => FavoritRepository());

class FavoritRepository {
  ///
  /// favoritテーブルからお気に入りデータを取得
  ///
  Future<List<FavoritStore>> getFavoritList() async {
    final db = await MyDataBase.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
        select
          id
          ,colorCode
          ,title
          ,sortNo
        from
          $_tableName
        order by
          sortNo ASC
      ''',
    );
    return List.generate(
      maps.length,
      (i) {
        return FavoritStore(
          id: maps[i]['id'],
          colorCode: maps[i]['colorCode'],
          title: maps[i]['title'],
          sortNo: maps[i]['sortNo'],
        );
      },
    );
  }

  ///
  /// favoritテーブルに1件追加
  ///
  Future<int> insert(FavoritStore store) async {
    final Database db = await MyDataBase.database;
    final insertedId = await db.insert(
      _tableName,
      store.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return insertedId;
  }

  ///
  /// favoritテーブルの1件を更新
  ///
  Future<void> update(FavoritStore store) async {
    final Database db = await MyDataBase.database;
    await db.update(
      _tableName,
      store.toMap(),
      where: 'id = ?',
      whereArgs: [store.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  ///
  /// favoritテーブルから1件を削除
  ///
  Future<void> delete(int colorCode) async {
    final db = await MyDataBase.database;
    await db.delete(
      _tableName,
      where: 'colorCode=?',
      whereArgs: [colorCode],
    );
  }

  ///
  /// favoritテーブルの件数を取得
  ///
  Future<int> getListCount() async {
    final Database db = await MyDataBase.database;
    var result = await db.rawQuery(
      'SELECT COUNT(*) FROM $_tableName',
    );
    int? exists = Sqflite.firstIntValue(result);
    return exists == null ? 0 : Sqflite.firstIntValue(result)!;
  }
}
