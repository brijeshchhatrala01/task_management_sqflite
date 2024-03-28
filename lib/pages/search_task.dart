import 'package:flutter/material.dart';
import 'package:task_management/database/task_database.dart';
import 'package:task_management/pages/util/custom_textformfield.dart';
import 'package:task_management/pages/util/show_row_task_field.dart';
import 'package:task_management/theme/theme.dart';

class SearchTask extends StatefulWidget {
  SearchTask({super.key});

  @override
  State<SearchTask> createState() => _SearchTaskState();
}

class _SearchTaskState extends State<SearchTask> {
  Map<String, Object?>? taskData = {};

  bool isCardVisible = false;
  bool isNoDataFound = false;
  void fetchTaskDataByName() {
    Future.delayed(
      const Duration(milliseconds: 300),
      () async {
        try {
          taskData = await TaskDatabase().getTaskByName(_searchController.text);
          if (taskData != null) {
            setState(() {
              isCardVisible = true;
            });
          }
        } catch (e) {
          setState(() {
            isCardVisible = false;
          });
        }
      },
    );
  }

  final _formKey = GlobalKey<FormState>();

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              smallSizedBox,
              CustomTextFormField(
                hintText: 'Enter Task Name !',
                controller: _searchController,
                keyboardType: TextInputType.text,
                maxLine: 1,
              ),
              smallSizedBox,
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    fetchTaskDataByName();
                  }
                },
                icon: const Icon(Icons.search),
                label: const Text("S E A R C H"),
              ),
              smallSizedBox,
              isCardVisible
                  ? Container(
                      width: MediaQuery.of(context).size.width / 0.4,
                      child: Card.filled(
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            children: [
                              RowTaskData(
                                iconData: Icons.task_alt,
                                taskfieldName: "Task Name",
                                taskData: taskData!['task_name'].toString(),
                              ),
                              RowTaskData(
                                iconData: Icons.view_stream,
                                taskfieldName: "Task Discription",
                                taskData:
                                    "${taskData!['task_discription'].toString().substring(0, 14)}...",
                              ),
                              RowTaskData(
                                iconData: Icons.date_range,
                                taskfieldName: "Task Date",
                                taskData: taskData!['task_date'].toString(),
                              ),
                              RowTaskData(
                                iconData: Icons.access_time,
                                taskfieldName: "Task Time",
                                taskData: taskData!['task_time'].toString(),
                              ),
                              RowTaskData(
                                  iconData: Icons.priority_high,
                                  taskfieldName: "Task Priority",
                                  taskData:
                                      taskData!['task_priority'].toString()),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Text("No Task Found!")
            ],
          ),
        ),
      ),
    );
  }
}
