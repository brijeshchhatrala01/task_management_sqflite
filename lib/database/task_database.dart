// ignore_for_file: non_constant_identifier_names

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_management/model/taskmodel.dart';

class TaskDatabase {
  late Database database;
  final DATABASENAME = "TaskDatabase.db";
  final TABLENAME = "taskdata";
  Future openDataBase() async {
    database = await openDatabase(
      version: 1,
      join(await getDatabasesPath(), DATABASENAME),
      onCreate: (db, version) async {
        //create table
        await db.execute('''
          CREATE TABLE IF NOT EXISTS $TABLENAME
          (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            task_completed TEXT NOT NULL,
            task_name TEXT NOT NULL,
            task_discription TEXT NOT NULL,
            task_date DATETIME NOT NULL,
            task_time TEXT NOT NULL,
            task_priority INTEGER NOT NULL        
          );
        ''');
      },
    );
  }

  //get open database object
  Future<Database> getDatabaseObject() async {
    return openDatabase(join(await getDatabasesPath(), DATABASENAME),
        version: 1);
  }

  //add task to database
  Future<void> addTask(TaskModel taskModel) async {
    database = await getDatabaseObject();
    database.insert(TABLENAME, taskModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort);
  }

  //get list of task by name by first date and time
  Future<List<Map<String, Object?>>> getTaskByName(String task_name) async {
    database = await getDatabaseObject();
    var listData = await database.query(TABLENAME,
        where: 'task_name = ?',
        whereArgs: [task_name],
        orderBy: 'task_date, task_time ASC');

    return listData;
  }

  //fetch all task by particular order by descending priority
  Future<List<Map<String, Object?>>> fetchAllTask() async {
    database = await getDatabaseObject();
    var listData =
        await database.query(TABLENAME, orderBy: 'task_priority DESC');
    return listData;
  }


  //filter all task by date and time
  Future<List<Map<String, Object?>>> filterByDate() async {
    database = await getDatabaseObject();
    var listData =
        await database.query(TABLENAME, orderBy: 'task_date, task_time ASC');
    return listData;
  }

  //get paricular task by id for search task
  Future<Map<String,Object?>> getTaskDataById(int id) async {
    database = await getDatabaseObject();
    var data = await database.query(TABLENAME,where: "id = ?",whereArgs: [id]);
    return data.first;
  }

  //update task by its id
  Future<void> updateTaskById(int id,TaskModel taskModel) async {
    database = await getDatabaseObject();
    database.update(TABLENAME, taskModel.toMap(),where: "id = ?",whereArgs: [id],conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  //delete task by id
  Future<void> deleteTaskById(int id) async {
    database = await getDatabaseObject();
    database.delete(TABLENAME,where: "id = ?",whereArgs: [id]);
  }
}
