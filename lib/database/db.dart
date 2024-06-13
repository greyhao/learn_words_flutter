import 'package:learn_words_flutter/common/api.dart';
import 'package:learn_words_flutter/models/categoryInfo.dart';
import 'package:learn_words_flutter/models/dictionaryInfo.dart';
import 'package:sqflite/sqflite.dart';

class MySqflite {
  final String _dbName = "learn_words.db";

  final _table_category = "category";
  final _table_dictionary = "dictionary";
  final _table_word = "word";

  static final MySqflite _instance = MySqflite._();

  factory MySqflite() {
    return _instance;
  }

  MySqflite._();

  static Database? _db;

  Future<Database> get db async {
    return _db ??= await _initDB();
  }

  Future<Database> _initDB() async {
    var dbPath = await getDatabasesPath();
    String path = dbPath + _dbName;
    print("path ==== $path");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        print("onCreate====");
        await _createTablesAndAddDefaultData(db, version);
      },
      onUpgrade: (db, oldVersion, newVersion) {},
    );
  }

  /// 根据书 hash 查询所有单词
  Future<List<String>> findWordByBookHash(String bookHash) async {
    Database database = await db;
    var result = <String>[];
    var temp = await database.query(
      _table_word,
      columns: ["name"],
      where: "dictionary_hash = ?",
      whereArgs: [bookHash],
    );
    if (temp.isNotEmpty) {
      result = temp.map((e) => (e["name"] as String)).toList();
    }
    return result;
  }

  // 查询分类 + 分类包含的词本
  Future<List<CategoryInfo>> findAllDictionary() async {
    var result = await findAllCatogrey();
    var list = <CategoryInfo>[];
    if (result.isNotEmpty) {
      CategoryInfo item;
      for (var category in result) {
        item = CategoryInfo();
        item.id = category["id"];
        item.name = category["name"];
        var bookTemp = await findBookById(item.id);
        item.books = bookTemp.map((e) => DictionaryInfo.fromJson(e)).toList();
        list.add(item);
      }
    }
    return list;
  }

  // 所有分类
  Future<List<Map<String, dynamic>>> findAllCatogrey() async {
    Database database = await db;
    var temp = await database.query(_table_category);
    return temp;
  }

  // 根据分类拿到书
  Future<List<Map<String, dynamic>>> findBookById(num bookId) async {
    Database database = await db;
    var list = await database.query(_table_dictionary,
        columns: ["hash", "name", "progress"],
        where: 'category_id = ?',
        whereArgs: [bookId]);
    return list;
  }

  // 在词书中批量插入单词
  Future saveWordsByHash(String bookHash, List<dynamic> words) async {
    Database database = await db;
    var batch = database.batch();
    var oldList = await findWordByBookHash(bookHash);
    words.removeWhere((element) => oldList.contains(element));
    for (var element in words) {
      batch.insert(_table_word, {"name": element, "dictionary_hash": bookHash});
    }
    var temp = await batch.commit();
    print("save result $temp");
  }

  // 查询词书中是否存在某个单词
  Future<bool> _findWordWithHash(String word, String hash) async {
    Database database = await db;
    var list = await database.query(
      _table_word,
      columns: ["name"],
      where: "name = ? and dictionary_hash = ?",
      whereArgs: [word, hash],
    );
    print("list = $list");
    return list.isNotEmpty;
  }

  // 删除词书所有单词
  Future dropWordsByHash(String hash) async {
    Database database = await db;
    await database
        .delete(_table_word, where: "dictionary_hash = ?", whereArgs: [hash]);
  }

  ///  create tables
  Future _createTablesAndAddDefaultData(Database db, int version) async {
    if (version == 1) {
      var batch = db.batch();
      // 分类：id name
      batch.execute(
          'CREATE TABLE $_table_category (id INTERGER PRIMARY KEY, name TEXT)');
      // 词书：hash name progress category_id
      batch.execute(
          'CREATE TABLE $_table_dictionary (hash TEXT PRIMARY KEY, name TEXT, progress INTERGER, category_id INTERGER)');
      // 单词：id name dictionary_hash
      batch.execute(
          'CREATE TABLE $_table_word (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, dictionary_hash TEXT, state TEXT)');

      // insert default data
      var dictionaryList = await Api().loadDictionaries();
      for (var category in dictionaryList) {
        batch.insert(_table_category, {
          "id": category.id,
          "name": category.name,
        });

        for (var book in category.books) {
          batch.insert(_table_dictionary, {
            "hash": book.hash,
            "name": book.name,
            "progress": book.progress,
            "category_id": category.id,
          });
        }
      }
      var result = await batch.commit();
      print("_createTablesAndAddDefaultData result $result");
    }
  }
}
