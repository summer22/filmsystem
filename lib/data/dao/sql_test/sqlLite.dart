import 'package:flutter/material.dart';
import 'task.dart';
import 'task_dao.dart';

/// *
/// * author: edz
/// * Date: 2021/5/25
/// * Describtion:
/// *
class SqlLitePage extends StatefulWidget {
  const SqlLitePage({Key? key}) : super(key: key);

  @override
  _SqlLitePageState createState() => _SqlLitePageState();
}

class _SqlLitePageState extends State<SqlLitePage> {
  List dataList = [];
  int count = 0;

  @override
  void initState() {
    super.initState();
    _searchDatas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '数据库curd测试',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white12,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.update),
            onPressed: () {
              //默认更新第一条
              TaskDao.update(Task(id: dataList.last.id, name: '小名更新'))
                  .then((value) => {_searchDatas()});
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        onPressed: () {
          count++;
          TaskDao.insert(Task(id: dataList.length + 1, name: '小名$count'))
              .then((value) => {_searchDatas()});
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          return _items(index);
        },
      ),
    );
  }

  _searchDatas() async {
    final list = await TaskDao.searchDatas();
    setState(() {
      dataList = list;
    });
  }

  _items(int index) {
    if (dataList.isEmpty) return const SizedBox(height: 0);
    var task = dataList[index];
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
      height: 50,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(task.id.toString() + '-' + task.name!),
          GestureDetector(
            onTap: () {
              TaskDao.delete(task.id).then((value) => {_searchDatas()});
            },
            child: const Icon(Icons.delete),
          )
        ],
      ),
    );
  }
}
