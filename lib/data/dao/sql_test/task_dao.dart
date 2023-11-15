import 'package:sqflite/sqflite.dart';
import 'package:filmsystem/data/dao/Sqllite.dart';
import 'package:filmsystem/utils/log.dart';
import 'task.dart';

/// *
/// * author: summer
/// * Date: 2021/5/25
/// * Describtion: 数据库crud操作api
/// *

class TaskDao {
  static const _table = "tasktable"; //表名称

  ///创建表
  static createTable(Batch batch) async {
    const sql =
        '''create table if not exists $_table (id integer primary key, name text)''';
    batch.execute(sql);
  }

  ///表升级
  static updateTable(Batch batch) async {
    const sql = '''alter table $_table add sex text null''';
    batch.execute(sql);
  }

  ///插入数据
  static Future<void> insert(Task task) async {
    Database db = await Sqllite().open();
    db.transaction((txn) async {
      txn.rawInsert("insert or replace into $_table (id,name) values (?,?)",
          [task.id, task.name]);
    });
    await db.batch().commit();
    // await db.close();
  }

  ///更新数据
  static Future<void> update(Task task) async {
    Database db = await Sqllite().open();
    db.transaction((txn) async {
      txn.rawUpdate(
          "update $_table set name =  ? where id = ?", [task.name, task.id]);
    });
    await db.batch().commit();
    // await db.close();
  }

  ///删除数据
  static Future<void> delete(int id) async {
    Database db = await Sqllite().open();
    db.transaction((txn) async {
      txn.rawDelete("delete from $_table where id = ?", [id]);
    });
    await db.batch().commit();
    // await db.close();
  }

  ///查询单条数据
  static Future search(int id) async {
    Database db = await Sqllite().open();
    List<Map<String, dynamic>> maps =
        await db.rawQuery("select * from $_table where id = $id");
    return Task.fromJson(maps.first);
  }

  ///查询多条数据
  static Future<List> searchDatas() async {
    Database db = await Sqllite().open();
    List<Map<String, dynamic>> maps =
        await db.rawQuery("select * from $_table");
    return await decodeData(maps);
  }

  ///分页查询
  static Future<List> searchDataSize(int page, int size) async {
    Database db = await Sqllite().open();
    List<Map<String, dynamic>> maps = await db.rawQuery(
        "select * from $_table order by id asc limit ?,?",
        [(page - 1) * size, size]);
    return await decodeData(maps);
  }

  ///map list 转 model list
  static Future<List> decodeData(List list) async {
    log('==========');
    log(list);
    List<Task> arr = [];
    for (var item in list) {
      final task = Task.fromJson(item);
      arr.add(task);
    }
    return arr;
  }
}
