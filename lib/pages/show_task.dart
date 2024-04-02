import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_management/database/task_database.dart';
import 'package:task_management/pages/add_task.dart';
import 'package:task_management/pages/util/show_row_task_field.dart';
import 'package:task_management/theme/theme.dart';

class ShowTask extends StatefulWidget {
  final bool isListView;
  const ShowTask({super.key, required this.isListView});

  @override
  State<ShowTask> createState() => _ShowTaskState();
}

class _ShowTaskState extends State<ShowTask> {
  List<Map<String, Object?>>? taskData = [];

  TaskDatabase taskDatabase = TaskDatabase();

  bool isDataVisible = false;

  String currentTime = "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}";
  bool isFilterByDate = true;
  void fetchAllData() {
    Future.delayed(
      const Duration(milliseconds: 300),
      () async {
        try {
          taskData = isFilterByDate
              ? await TaskDatabase().filterByDate()
              : await TaskDatabase().fetchAllTask();
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
      body: taskData!.isNotEmpty
          ? Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isFilterByDate
                            ? "Filter By Priority"
                            : "Filter By Date",
                        style: mediumText,
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              isFilterByDate = !isFilterByDate;
                              fetchAllData();
                            });
                          },
                          icon: isFilterByDate
                              ? const Icon(Icons.priority_high)
                              : const Icon(Icons.filter_list))
                    ],
                  ),
                ),
                Visibility(
                    visible: isDataVisible,
                    child: widget.isListView
                        ? Expanded(
                            child: ListView(
                              children: taskData!.map((data) {
                                bool isCompleted = bool.parse(
                                    data['task_completed'].toString());
                                return Slidable(
                                  endActionPane: ActionPane(
                                      motion: const StretchMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) {
                                            TaskDatabase().deleteTaskById(
                                                int.parse(
                                                    data['id'].toString()));
                                            fetchAllData();
                                          },
                                          icon: Icons.delete,
                                          backgroundColor: Colors.red.shade300,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        )
                                      ]),
                                  startActionPane: ActionPane(
                                      motion: const StretchMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => AddTask(
                                                      taskId: int.parse(
                                                          data['id']
                                                              .toString())),
                                                ));
                                          },
                                          icon: Icons.edit,
                                          backgroundColor:
                                              Colors.yellow.shade200,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        )
                                      ]),
                                  child: Card(
                                    color: data['task_completed'].toString() ==
                                            "true"
                                        ? Colors.grey
                                        : DateTime.now().isAfter(DateTime.parse(
                                                    data['task_date']
                                                        .toString())) &&
                                                TimeOfDay.now().hour >=
                                                    int.parse(data['task_time']
                                                        .toString()
                                                        .substring(0, 2))
                                            ? Colors.blue.shade200
                                            : int.parse(data['task_priority']
                                                        .toString()) >=
                                                    4
                                                ? Colors.red.shade200
                                                : int.parse(data['task_priority'].toString()) > 2 &&
                                                        int.parse(data['task_priority'].toString()) < 4
                                                    ? Colors.blue.shade200
                                                    : Colors.green.shade200,
                                    shape: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Column(
                                        children: [
                                          RowTaskData(
                                            iconData: Icons.task_alt,
                                            taskfieldName: "Task Name",
                                            taskData:
                                                data['task_name'].toString(),
                                            isCompleted: isCompleted,
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
                                            taskData:
                                                data['task_date'].toString(),
                                            isCompleted: isCompleted,
                                          ),
                                          RowTaskData(
                                            iconData: Icons.access_time,
                                            taskfieldName: "Task Time",
                                            taskData:
                                                data['task_time'].toString(),
                                            isCompleted: isCompleted,
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
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                        : Expanded(
                            child: GridView.count(
                            crossAxisCount: 2,
                            children: taskData!.map((task) {
                              bool isCompleted =
                                  bool.parse(task['task_completed'].toString());
                              print(isCompleted);
                              return GestureDetector(
                                onLongPress: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("You can"),
                                        actions: [
                                          ElevatedButton.icon(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => AddTask(
                                                          taskId: int.parse(
                                                              task['id']
                                                                  .toString())),
                                                    ));
                                              },
                                              icon: const Icon(Icons.edit),
                                              label: Text("Edit")),
                                          ElevatedButton.icon(
                                              onPressed: () {
                                                TaskDatabase().deleteTaskById(
                                                    int.parse(
                                                        task['id'].toString()));
                                                Navigator.pop(context);
                                                fetchAllData();
                                              },
                                              icon: const Icon(Icons.delete),
                                              label: Text("Delete"))
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Card(
                                  color: task['task_completed'].toString() ==
                                          "true"
                                      ? Colors.grey
                                      : DateTime.now().isAfter(DateTime.parse(
                                                  task['task_date']
                                                      .toString())) &&
                                              TimeOfDay.now().hour >=
                                                  int.parse(task['task_time']
                                                      .toString()
                                                      .substring(0, 2))
                                          ? Colors.blue.shade200
                                          : int.parse(task['task_priority']
                                                      .toString()) >=
                                                  4
                                              ? Colors.red.shade200
                                              : int.parse(task['task_priority'].toString()) > 2 &&
                                                      int.parse(task['task_priority'].toString()) < 4
                                                  ? Colors.blue.shade200
                                                  : Colors.green.shade200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        RowTaskData(
                                          iconData: Icons.task_alt,
                                          taskfieldName: "",
                                          taskData:
                                              task['task_name'].toString(),
                                          isCompleted: isCompleted,
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        RowTaskData(
                                          iconData: Icons.date_range,
                                          taskfieldName: "",
                                          taskData: task['task_date']
                                              .toString()
                                              .substring(0, 10),
                                          isCompleted: isCompleted,
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        RowTaskData(
                                          iconData: Icons.access_time_rounded,
                                          taskfieldName: "",
                                          taskData:
                                              task['task_time'].toString(),
                                          isCompleted: isCompleted,
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            const Icon(Icons.priority_high),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              child: Slider.adaptive(
                                                  min: 1,
                                                  max: 5,
                                                  divisions: 4,
                                                  value: double.parse(
                                                      task['task_priority']
                                                          .toString()),
                                                  onChanged: null),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ))),
              ],
            )
          : const Center(
              child: Text("No Data Found"),
            ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddTask(
                  taskId: 0,
                ),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
