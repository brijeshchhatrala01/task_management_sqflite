import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:task_management/database/task_database.dart';
import 'package:task_management/model/taskmodel.dart';
import 'package:task_management/pages/homepage.dart';
import 'package:task_management/pages/util/custom_textformfield.dart';
import 'package:task_management/theme/colors.dart';
import 'package:task_management/theme/theme.dart';

class AddTask extends StatefulWidget {
  final int taskId;
  const AddTask({super.key, required this.taskId});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  //controllers
  final _taskNameController = TextEditingController();

  final _discriptionController = TextEditingController();

  final _dateController = TextEditingController();

  final _timeController = TextEditingController();

  TaskDatabase taskDatabase = TaskDatabase();

  final _formKey = GlobalKey<FormState>();

  Map<String, Object?> taskData = {};

  double _sliderValue = 1;

  bool _isTaskCompleted = false;

  @override
  void initState() {
    getTaskDataById();
    super.initState();
  }

  void getTaskDataById() {
    if (widget.taskId != 0) {
      Future.delayed(
        const Duration(milliseconds: 300),
        () async {
          taskData = await TaskDatabase().getTaskDataById(widget.taskId);
          setState(() {
            _taskNameController.text = taskData['task_name'].toString();
            _discriptionController.text =
                taskData['task_discription'].toString();
            _sliderValue = double.parse(taskData['task_priority'].toString());
            _timeController.text = taskData['task_time'].toString();
            _dateController.text = taskData['task_date'].toString();
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Task Manager",
          style: appBarTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  smallSizedBox,
                  CustomTextFormField(
                    hintText: "Enter Task Name",
                    controller: _taskNameController,
                    keyboardType: TextInputType.text,
                    maxLine: 1,
                    iconData: Icons.task_alt,
                  ),
                  smallSizedBox,
                  CustomTextFormField(
                    hintText: "Enter Discription",
                    controller: _discriptionController,
                    keyboardType: TextInputType.text,
                    maxLine: 2,
                    iconData: Icons.article_outlined,
                  ),
                  smallSizedBox,
                  TextFormField(
                    onTap:  () async {
                      await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2024, DateTime.monthsPerYear),
                      ).then(
                            (value) {
                          if (value != null) {
                            _dateController.text =
                                value.toString().substring(0,11);
                          }
                        },
                      );
                    },
                    controller: _dateController,
                    readOnly: true,
                    validator: (value) {
                      return value!.isEmpty
                          ? "Please Enter Required Fields"
                          : null;
                    },
                    decoration: InputDecoration(
                      errorStyle: errorTextStyle,
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: errorColor),
                          borderRadius: BorderRadius.circular(12)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: errorColor),
                          borderRadius: BorderRadius.circular(12)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: "Select Date",
                      prefixIcon: IconButton(
                        onPressed: () async {
                          await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2024, DateTime.monthsPerYear),
                          ).then(
                            (value) {
                              if (value != null) {
                                _dateController.text =
                                    value.toString().substring(0,11);
                              }
                            },
                          );
                        },
                        icon: const Icon(Icons.date_range),
                      ),
                    ),
                  ),
                  smallSizedBox,
                  TextFormField(
                    controller: _timeController,
                    readOnly: true,
                    validator: (value) {
                      return value!.isEmpty
                          ? "Please Enter Required Fields"
                          : null;
                    },
                    onTap: () async {
                      final TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime:
                        TimeOfDay.fromDateTime(DateTime.now()),

                      );
                      if(time != null){
                        var df = DateFormat("h:mm a");
                        var dt = df.parse(time!.format(context));
                        var finaltime =  DateFormat('HH:mm').format(dt);
                        _timeController.text = finaltime.toString();
                      }

                    },
                    decoration: InputDecoration(
                        errorStyle: errorTextStyle,
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: errorColor),
                            borderRadius: BorderRadius.circular(12)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: errorColor),
                            borderRadius: BorderRadius.circular(12)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "Select Time",
                        prefixIcon: IconButton(
                            onPressed: () async {
                              final TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime:
                                    TimeOfDay.fromDateTime(DateTime.now()),

                              );
                              if(time != null){
                                var df = DateFormat("h:mm a");
                                var dt = df.parse(time!.format(context));
                                var finaltime =  DateFormat('HH:mm').format(dt);
                                _timeController.text = finaltime.toString();
                              }
                              //     .then(
                              //   (value) {
                              //     if (value != null) {
                              //       _timeController.text = "${value.hour.toString()}:${value.minute.toString()}";
                              //     }
                              //   },
                              // );
                            },
                            icon: const Icon(Icons.access_time))),
                  ),
                  smallSizedBox,
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: blackColor, width: 0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Choose Priority"),
                          Slider(
                            value: _sliderValue,
                            min: 1,
                            max: 5,
                            divisions: 4,
                            onChanged: (value) {
                              setState(() {
                                _sliderValue = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  smallSizedBox,
                  Visibility(
                    visible: widget.taskId != 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text("Task Completed : "),
                        Switch.adaptive(
                          value: _isTaskCompleted,
                          onChanged: (value) {
                            setState(() {
                              _isTaskCompleted = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  smallSizedBox,
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        var taskData = TaskModel(
                            task_completed: _isTaskCompleted.toString(),
                            task_name: _taskNameController.text.trim(),
                            task_discription: _discriptionController.text,
                            task_date: _dateController.text,
                            task_time: _timeController.text,
                            task_priority: _sliderValue.toInt());

                        if (widget.taskId != 0) {
                          taskDatabase.updateTaskById(widget.taskId, taskData);
                        } else {
                          taskDatabase.addTask(taskData);
                        }
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Homepage(),
                            ));
                      }
                    },
                    icon: widget.taskId == 0
                        ? Icon(Icons.add_task)
                        : Icon(Icons.update),
                    label: widget.taskId == 0
                        ? Text('A D D  T A S K')
                        : Text('U P D A T E  T A S K'),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
