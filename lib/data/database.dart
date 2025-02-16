import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyDataBase {
  static Future<Database> get database async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'colorcode_database.db'),
      // このversionで実行するスクリプトを制御する
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return database;
  }

  ///
  /// Table新規作成処理
  ///
  static _onCreate(
    Database database,
    int version,
  ) async {
    await _migrate(database, 0, version);
  }

  ///
  /// Tableバージョンアップ処理
  ///
  static _onUpgrade(
    Database database,
    int oldVersion,
    int newVersion,
  ) async {
    await _migrate(database, oldVersion, newVersion);
  }

  ///
  /// テーブル新規作成 及び バージョンアップ
  ///
  static Future<void> _migrate(Database db, int oldVersion, int newVersion) async {
    for (var i = oldVersion + 1; i <= newVersion; i++) {
      final queries = migrationScripts[i.toString()]!;
      for (final query in queries) {
        await db.execute(query);
      }
    }
  }

  ///
  /// スクリプト集
  ///
  static const migrationScripts = {
    '1': [
      '''
        CREATE TABLE favorit(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          colorCode INTEGER,
          title TEXT,
          sortNo INTEGER
        )
      ''',
    ],
  };
}
