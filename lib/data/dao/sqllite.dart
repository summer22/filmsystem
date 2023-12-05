import 'dart:io';
import 'package:filmsystem/data/dao/download/download_dao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:filmsystem/utils/log.dart';

/// *
/// * author: summer
/// * Date: 2021/5/25
/// * Describtion: sqflite 数据库
/// *

class Sqllite {
  static const _version = 1; //数据库版本号
  static const _name = "filmsystem.db"; //数据库名称

  Database? _database;

  static final Sqllite _instance = Sqllite.internal();

  Sqllite.internal();

  factory Sqllite() {
    return _instance;
  }

  Future<Database> get database async {
    _database ??= await initDatabase();
    return _database!;
  }

  /// create database
  Future<Database> initDatabase() async {
    log("init database start");
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _name);
    _database = await openDatabase(
      path,
      version: _version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    log("init database success");
    return _database!;
  }

  /// delete the db
  Future<void> deleteDb(String dbName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);
    if (await Directory(dirname(path)).exists()) {
      await deleteDatabase(path);
      log("db is delete");
    }
  }

  //create table
  void _onCreate(Database db, int version) async {
    var batch = db.batch();
    createTable(batch);
    await batch.commit();
    log("Table is created");
  }

  ///upgrade 数据库版本升级
  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    var batch = db.batch();
    log('oldVersion:$oldVersion' + 'newVersion:$newVersion');
    if (oldVersion < _version) {
      updateTable(batch);
    }
    await batch.commit();
  }

  createTable(Batch batch) {
    DownloadDao.createTable(batch);
  }

  updateTable(Batch batch) {
    DownloadDao.updateTable(batch);
  }

  ///打开
  Future<Database> open() async {
    return await database;
  }

  ///关闭
  Future<void> close() async {
    final db = await database;
    return db.close();
  }
}
