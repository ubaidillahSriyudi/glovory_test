import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "glovory.db";
  static const _databaseVersion = 1;

  static const table = 'search_table';
  static const tableProducts = 'products_table';
  static const tableCategories = 'categories_table';

  static const columnId = '_id';
  static const columnKeyword = 'keyword';

  static const productColumnId = '_id';
  static const productColumnName = 'product_name';
  static const productColumnPrice = 'product_price';
  static const productColumnImg = 'product_img';
  static const productCategoryName = 'category_name';
  static const productCategoryId = 'category_id';

  static const categoryName = 'category_name';
  static const categoryId = 'category_id';


  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;

  Future<Database> get database async {
    
    if (_database != null) {
      return _database!;
    }
      
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    final _res = await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
    return _res;
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    try {
      await db.execute(
        '''
        CREATE TABLE $table (
          $columnId INTEGER PRIMARY KEY,
          $columnKeyword TEXT NOT NULL
        )
        '''
      );

      await db.execute(
        ''' 
        CREATE TABLE $tableProducts (
          $productColumnId INTEGER PRIMARY KEY,
          $productColumnName TEXT COLLATE NOCASE,
          $productColumnImg TEXT NOT NULL,
          $productColumnPrice TEXT NOT NULL,
          $productCategoryName TEXT NOT NULL,
          $productCategoryId TEXT NOT NULL
        )
        '''
      );

      await db.execute(
        ''' 
        CREATE TABLE $tableCategories (
          $columnId INTEGER PRIMARY KEY,
          $categoryName TEXT NOT NULL,
          $categoryId TEXT NOT NULL
        )
        '''
      );
    } catch (e) {
      print('_onCreate catch $e');
    }
  }
}