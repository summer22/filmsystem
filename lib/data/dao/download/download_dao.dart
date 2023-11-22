import 'dart:io';

import 'package:filmsystem/data/dao/download/download_info_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:filmsystem/data/dao/Sqllite.dart';
import 'package:filmsystem/utils/log.dart';

class DownloadDao {
  static const _table = "video_table"; //表名称

  ///创建表
  static createTable(Batch batch) async {
    const sql =
    '''create table if not exists $_table (id integer primary key, email text, headNo text, dramaNumber integer, dramaUrl text, dramaUrl1 text, dramaUrl2 text, dramaTitle text, intro text, filmUrl text, duration integer, createDate text, updateDate text, receivedBytes integer, totalBytes integer, statue integer, filePath text)''';
    batch.execute(sql);
  }

  ///表升级
  static updateTable(Batch batch) async {
    const sql = '''alter table $_table add sex text null''';
    batch.execute(sql);
  }

  ///插入数据
  static Future<void> insert(DownloadInfoModel task) async {
    Database db = await Sqllite().open();
    db.transaction((txn) async {
      txn.rawInsert("insert or replace into $_table (id,headNo,dramaNumber,dramaUrl,dramaUrl1,dramaUrl2,dramaTitle,intro,filmUrl,duration,createDate,updateDate,email,statue,filePath,totalBytes,receivedBytes) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
          [task.id, task.headNo,task.dramaNumber,task.dramaUrl,task.dramaUrl1,task.dramaUrl2,task.dramaTitle,task.intro,task.filmUrl,task.duration,task.createDate,task.updateDate,task.email,task.statue,task.filePath,task.totalBytes,task.receivedBytes]);
    });
    await db.batch().commit();
    // await db.close();
  }

  ///更新数据
  static Future<void> update(DownloadInfoModel task) async {
    Database db = await Sqllite().open();
    db.transaction((txn) async {
      txn.rawUpdate(
          "update $_table set statue = ?, receivedBytes = ?  where id = ?", [task.statue,task.receivedBytes,task.id]);
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

  static deleteLocalFile(String filePath) async {
    try {
      File file = File(filePath);

      // 检查文件是否存在
      if (await file.exists()) {
        // 删除文件
        await file.delete();
        debugPrint('文件删除成功: $filePath');
      } else {
        debugPrint('文件不存在: $filePath');
      }
    } catch (e) {
      debugPrint('删除文件时出现错误: $e');
    }
  }


  ///查询单条数据
  static Future<DownloadInfoModel?> search(int id) async {
    Database db = await Sqllite().open();
    List<Map<String, dynamic>> maps =
    await db.rawQuery("select * from $_table where id = $id");
    if(maps.isEmpty){
      return null;
    }
    return DownloadInfoModel.fromJson(maps.first);
  }

  ///查询多条数据
  static Future<List<DownloadInfoModel>> searchDatas() async {
    Database db = await Sqllite().open();
    List<Map<String, dynamic>> maps =
    await db.rawQuery("select * from $_table");
    return await decodeData(maps);
  }

  ///分页查询
  static Future<List<DownloadInfoModel>> searchDataSize(int page, int size) async {
    Database db = await Sqllite().open();
    List<Map<String, dynamic>> maps = await db.rawQuery(
        "select * from $_table order by id asc limit ?,?",
        [(page - 1) * size, size]);
    return await decodeData(maps);
  }

  ///map list 转 model list
  static Future<List<DownloadInfoModel>> decodeData(List list) async {
    log('==========');
    log(list);
    List<DownloadInfoModel> arr = [];
    for (var item in list) {
      final task = DownloadInfoModel.fromJson(item);
      arr.add(task);
    }
    return arr;
  }
}
