import 'package:glovory_test/core/utils/db_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class LatestSearch {
  
  void insertKeyword(String keyword) async {
    Database _db = await DatabaseHelper.instance.database;

    Map<String, dynamic> _row = {
      DatabaseHelper.columnKeyword : keyword
    };

    try {
      final _queryResult = await _db.rawQuery('SELECT * FROM ${DatabaseHelper.table} WHERE ${DatabaseHelper.columnKeyword}="$keyword"');
      final exists = Sqflite.firstIntValue(_queryResult);
      if (exists == 0 || exists == null) {
        await _db.insert(DatabaseHelper.table, _row);
      }
    } catch (e) {
      print('insertKeyword Catch $e');
    }
  }

  Future<List<String>> getKeywords() async {
    Database _db = await DatabaseHelper.instance.database;
    List<String> _data = [];
    List<Map<String, Object?>> _result = await _db.query(DatabaseHelper.table);
    for (var i = 0; i < _result.length; i++) {
      _data.add('${_result[i]['keyword']}');
    }
    return _data;
  }

  void clearKeywords() async {
    Database _db = await DatabaseHelper.instance.database;
    await _db.delete(DatabaseHelper.table);
  }
}