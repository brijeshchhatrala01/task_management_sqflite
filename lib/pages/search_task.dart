import 'package:flutter/material.dart';
import 'package:task_management/database/task_database.dart';
import 'package:task_management/pages/util/custom_textformfield.dart';
import 'package:task_management/pages/util/show_row_task_field.dart';
import 'package:task_management/theme/theme.dart';

class SearchTask extends StatefulWidget {
  const SearchTask({super.key});

  @override
  State<SearchTask> createState() => _SearchTaskState();
}

class _SearchTaskState extends State<SearchTask> {
  List<Map<String, Object?>>? taskData = [];

  bool isCardVisible = false;
  bool isNoDataFound = false;
  void fetchTaskDataByName() {
    Future.delayed(
      const Duration(milliseconds: 300),
      () async {
        try {
          taskData = await TaskDatabase().getTaskByName(_searchController.text.trim());
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
                iconData: Icons.search,
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
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView(
                          children: taskData!.map((data) {
                            bool isCompleted = data['task_completed'].toString() == "true";
                            return Card(
                              color: data['task_completed'].toString() == "true"
                                  ? Colors.grey
                                  : DateTime.now().isAfter(DateTime.parse(
                                              data['task_date'].toString())) &&
                                          TimeOfDay.now().hour >=
                                              int.parse(data['task_time']
                                                  .toString()
                                                  .substring(0, 2))
                                      ? Colors.blue.shade300
                                      : int.parse(data['task_priority'].toString()) >=
                                              4
                                          ? Colors.red.shade300
                                          : int.parse(data['task_priority']
                                                          .toString()) >
                                                      2 &&
                                                  int.parse(
                                                          data['task_priority']
                                                              .toString()) <
                                                      4
                                              ? Colors.blue.shade300
                                              : Colors.green.shade300,
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  children: [
                                    RowTaskData(
                                      iconData: Icons.task_alt,
                                      taskfieldName: "Task Name",
                                      taskData: data['task_name'].toString(), isCompleted: isCompleted ,
                                    ),
                                    // RowTaskData(
                                    //   iconData: Icons.view_stream,
                                    //   taskfieldName: "Task Discription",
                                    //   taskData:
                                    //       "${data!['task_discription'].toString().substring(0, 5)}...",
                                    // ),
                                    RowTaskData(
                                      iconData: Icons.date_range,
                                      taskfieldName: "Task Date",
                                      taskData: data['task_date'].toString(), isCompleted: isCompleted,
                                    ),
                                    RowTaskData(
                                      iconData: Icons.access_time,
                                      taskfieldName: "Task Time",
                                      taskData: data['task_time'].toString(), isCompleted: isCompleted,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
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
                                                data['task_priority']
                                                    .toString()),
                                            onChanged: null),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  : const Text("No Task Found!")
            ],
          ),
        ),
      ),
    );
  }
}
