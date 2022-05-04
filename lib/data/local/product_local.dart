import 'package:glovory_test/core/utils/db_helper.dart';
import 'package:glovory_test/data/models/product_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class ProductsLocal {

  Future<bool> insertProducts(ProductModel model) async {
    Database _db = await DatabaseHelper.instance.database;

    for (var i = 0; i < model.results!.length; i++) {
     Map<String, dynamic> _row = {
       DatabaseHelper.productColumnId : model.results?[i].id,
       DatabaseHelper.productColumnName : model.results?[i].productName,
       DatabaseHelper.productColumnImg : model.results?[i].productImgSm,
       DatabaseHelper.productColumnPrice : model.results?[i].productPrice,
       DatabaseHelper.productCategoryName : model.results?[i].productCategory?.categoryName,
       DatabaseHelper.productCategoryId : model.results?[i].productCategory?.categoryId,
     };

     final _queryResult = await _db.rawQuery('SELECT * FROM ${DatabaseHelper.tableProducts} WHERE ${DatabaseHelper.productColumnId}="${model.results?[i].id}"');
     final _exists = Sqflite.firstIntValue(_queryResult);

      if (_exists == 0 || _exists == null) {
        _db.insert(DatabaseHelper.tableProducts, _row);
      }
    }

    return true;
  }

  Future<List<Results>> search(String keyword) async {
    Database _db = await DatabaseHelper.instance.database;

    final _resSearch = await _db.query(
      DatabaseHelper.tableProducts, 
      where: "${DatabaseHelper.productColumnName} LIKE ?", 
      whereArgs: ['%$keyword%'],
    );

    List<Results> _listOfResults = [];

    var _finalList = _listOfResults.toList();

    for (var i = 0; i < _resSearch.length; i++) {
      _finalList.add(Results(
        id: int.parse('${_resSearch[i]['_id']}'),
        productName: '${_resSearch[i]['product_name']}',
        productImgSm: '${_resSearch[i]['product_img']}',
        productPrice: '${_resSearch[i]['product_price']}'
      ));
    }

    return _finalList;
  }

  Future<List<Results>> getProductsByCategory(String categoryId) async {
    Database _db = await DatabaseHelper.instance.database;
    final _result = await _db.query(DatabaseHelper.tableProducts, where: '${DatabaseHelper.categoryName} = ?', whereArgs: [categoryId]);
    List<Results> _listOfResults = [];

    var _finalList = _listOfResults.toList();
    for (var i = 0; i < _result.length; i++) {
      _finalList.add(Results(
        id: int.parse('${_result[i]['_id']}'),
        productName: '${_result[i]['product_name']}',
        productImgSm: '${_result[i]['product_img']}',
        productPrice: '${_result[i]['product_price']}',
        productCategory: ProductCategory(
          categoryName: '${_result[i]['category_name']}',
          categoryId: '${_result[i]['category_id']}'
        )
      ));
    }
    return _finalList;
  }

  Future<List<Results>> allProducts() async {
    Database _db = await DatabaseHelper.instance.database;
    final _result = await _db.query(DatabaseHelper.tableProducts);

    ProductModel model = ProductModel();

    List<Results> _listOfResults = [];

    var _finalList = _listOfResults.toList();
    
    for (var i = 0; i < _result.length; i++) {

      _finalList.add(Results(
        id: int.parse('${_result[i]['_id']}'),
        productName: '${_result[i]['product_name']}',
        productImgSm: '${_result[i]['product_img']}',
        productPrice: '${_result[i]['product_price']}',
        productCategory: ProductCategory(
          categoryName: '${_result[i]['category_name']}',
          categoryId: '${_result[i]['category_id']}'
        )
      ));

      // model.results?.insert(i, Results(
      //   id: int.parse('${{_result[i]['_id']}}'),
      //   productName: '${_result[i]['product_name']}',
      //   productImgSm: '${_result[i]['product_img']}',
      //   productPrice: '${_result[i]['product_price']}'
      // ));

      // _model.results?[i].productCategory ==
      // model.results?[i].id = int.parse('${{_result[i]['_id']}}');
      // model.results?[i].productName = '${_result[i]['product_name']}';
      // _model.results?[i].productImgSm = '${_result[i]['product_img']}';
      // _model.results?[i].productPrice = '${_result[i]['product_price']}';

      // model.results?[i] = Results(
      //   id: int.parse('${{_result[i]['_id']}}'),
      //   productName: '${_result[i]['product_name']}',
      //   productImgSm: '${_result[i]['product_img']}',
      //   productPrice: '${_result[i]['product_price']}'
      // );
      // print('_model ${model.results?.length}');
    }

    // print('model ${model.results?[0].productName} | ${_finalList.length} | ${model.count} | ${model.next} ');
    return _finalList;
  }
}