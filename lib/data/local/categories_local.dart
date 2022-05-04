import 'package:glovory_test/core/utils/db_helper.dart';
import 'package:glovory_test/data/models/category_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class CategoriesLocal {

  Future<void> insertCategories(CategoryModel model) async {
    Database _db = await DatabaseHelper.instance.database;

    for (var i = 0; i < model.results!.length; i++) {
       Map<String, dynamic> _row = {
       DatabaseHelper.columnId : model.results?[i].id,
       DatabaseHelper.categoryName : model.results?[i].categoryName,
       DatabaseHelper.categoryId : model.results?[i].categoryId,
     };

     final _checkResult = await _db.query(DatabaseHelper.tableCategories, where: '${DatabaseHelper.columnId} = ?', whereArgs: [model.results?[i].id]);
     final _exists = Sqflite.firstIntValue(_checkResult);

     if (_exists == 0 || _exists == null) {
       _db.insert(DatabaseHelper.tableCategories, _row);
     }
    }

  }

  Future<List<Results>> allCategories() async {
    Database _db = await DatabaseHelper.instance.database;
    final _result = await _db.query(DatabaseHelper.tableCategories);

    List<Results> _listOfResults = [];

    var _finalList = _listOfResults.toList();

     _finalList.add(Results(
        id: 0,
        categoryName : 'All Products',
        categoryId: 'All Products',
    ));

    _finalList.addAll([
      Results(
          id : 3,
          categoryName:  "Appliances",
          categoryId: "appliances"
      ),
       Results(
        id: 4,
        categoryName: "Automotive",
        categoryId: "automotive"
      ),
       Results(
        id: 5,
        categoryName: "Babies",
        categoryId: "babies"
      ),
       Results(
        id: 6,
        categoryName: "Fashionmen",
        categoryId: "fashionmen"
      ),
       Results(
        id: 7,
        categoryName: "Fashionwomen",
        categoryId: "fashionwomen"
      ),
       Results(
        id: 8,
        categoryName: "Gadgets",
        categoryId: "gadgets"
      ),
       Results(
        id: 9,
        categoryName: "Groceries",
        categoryId: "groceries"
      ),
       Results(
        id: 10,
        categoryName: "HealthAndBeauty",
        categoryId: "healthandbeauty"
      ),
       Results(
        id: 11,
        categoryName: "HomeAndLiving",
        categoryId: "homeandliving"
      ),
       Results(
        id: 12,
        categoryName: "Pets",
        categoryId: "pets"
      ),
       Results(
        id: 13,
        categoryName: "SchoolSupplies",
        categoryId: "schoolsupplies"
      ),
       Results(
        id: 14,
        categoryName: "SportsAndLifestyle",
        categoryId: "sportsandlifestyle"
      ),
       Results(
        id: 15,
        categoryName: "ToysAndCollectibles",
        categoryId: "toysandcollectibles"
      ),
       Results(
        id: 2,
        categoryName: "Accessories",
        categoryId: "accessories"
      )
    ]);

    // for (var i = 0; i < _result.length; i++) { ///__________ DISABLE
    //   _finalList.add(Results(
    //     id: int.parse('${_result[i]['_id']}'),
    //     categoryName : '${_result[i]['category_name']}',
    //     categoryId: '${_result[i]['category_id']}',
    //   ));
    // }

   

    return _finalList;
  }
}