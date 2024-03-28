import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:task_management/database/task_database.dart';
import 'package:task_management/pages/add_task.dart';
import 'package:task_management/pages/util/show_row_task_field.dart';
import 'package:task_management/theme/theme.dart';

class ShowTask extends StatefulWidget {
  const ShowTask({super.key});

  @override
  State<ShowTask> createState() => _ShowTaskState();
}

class _ShowTaskState extends State<ShowTask> {
  List<Map<String, Object?>> taskData = [];

  TaskDatabase taskDatabase = TaskDatabase();

  bool isDataVisible = false;

  void fetchAllData() {
    Future.delayed(
      const Duration(milliseconds: 300),
      () async {
        try {
          taskData = await TaskDatabase().fetchAllTask();
          if (taskData != null) {
            setState(() {
              isDataVisible = true;
            });
          }
        } catch (e) {
          setState(() {
            isDataVisible = false;
          });
        }
      },
    );
  }

  @override
  void initState() {
    fetchAllData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Filter By Date",
                  style: mediumText,
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.filter_list))
              ],
            ),
          ),
          Visibility(
            visible: isDataVisible,
            child: Expanded(
                child: ListView(
              children: taskData.map((data) {
                return Card.filled(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        RowTaskData(
                          iconData: Icons.task_alt,
                          taskfieldName: "Task Name",
                          taskData: data!['task_name'].toString(),
                        ),
                        RowTaskData(
                          iconData: Icons.view_stream,
                          taskfieldName: "Task Discription",
                          taskData:
                              "${data!['task_discription'].toString().substring(0, 5)}...",
                        ),
                        RowTaskData(
                          iconData: Icons.date_range,
                          taskfieldName: "Task Date",
                          taskData: data!['task_date'].toString(),
                        ),
                        RowTaskData(
                          iconData: Icons.access_time,
                          taskfieldName: "Task Time",
                          taskData: data!['task_time'].toString(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.priority_high),
                                Text("Priority"),
                              ],
                            ),
                            Slider(
                                min: 1,
                                max: 5,
                                divisions: 4,
                                value: double.parse(
                                    data!['task_priority'].toString()),
                                onChanged: null),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            )),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTask(),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
