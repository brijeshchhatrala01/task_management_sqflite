import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:task_management/database/task_database.dart';
import 'package:task_management/model/taskmodel.dart';
import 'package:task_management/pages/homepage.dart';
import 'package:task_management/pages/util/custom_textformfield.dart';
import 'package:task_management/theme/colors.dart';
import 'package:task_management/theme/theme.dart';

class AddTask extends StatefulWidget {
  AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _taskNameController = TextEditingController();

  final _discriptionController = TextEditingController();

  final _dateController = TextEditingController();

  final _timeController = TextEditingController();

  TaskDatabase taskDatabase = TaskDatabase();

  final _formKey = GlobalKey<FormState>();

  double _sliderValue = 1;

  final _isTaskCompleted = false;

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
              ),
              smallSizedBox,
              CustomTextFormField(
                hintText: "Enter Discription",            
                controller: _discriptionController,
                keyboardType: TextInputType.text,
                maxLine: 2,
              ),
              smallSizedBox,
              TextFormField(
                controller: _dateController,
                readOnly: true,
                validator: (value) {
                  return value!.isEmpty ? "Please Enter Required Fields" : null;
                },
                decoration: InputDecoration(
                  errorStyle: errorTextStyle,
                  errorBorder: OutlineInputBorder(borderSide: BorderSide(color: errorColor),borderRadius: BorderRadius.circular(12)),
                  focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: errorColor),borderRadius: BorderRadius.circular(12)),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Select Date",
                  suffixIcon: IconButton(
                    onPressed: () async {
                      await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2024,DateTime.monthsPerYear),
                      ).then(
                        (value) {
                          if (value != null) {
                            _dateController.text =
                                ("${value!.day.toString()}/${value.month}/${value.year}");
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
                  return value!.isEmpty ? "Please Enter Required Fields" : null;
                },
                decoration: InputDecoration(
                    errorStyle: errorTextStyle,
                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: errorColor),borderRadius: BorderRadius.circular(12)),
                    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: errorColor),borderRadius: BorderRadius.circular(12)),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: "Selec Time",
                    suffixIcon: IconButton(
                        onPressed: () async {
                          await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then(
                            (value) {
                              if (value != null) {
                                _timeController.text =
                                    ("${value!.hour.toString()}:${value.minute.toString()} ${value.period.name}");
                              }
                            },
                          );
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
              ElevatedButton.icon(
                onPressed: () {
                  if(_formKey.currentState!.validate()){
                    var taskData = TaskModel(task_completed: _isTaskCompleted.toString(), task_name: _taskNameController.text, task_discription: _discriptionController.text, task_date: _dateController.text, task_time: _timeController.text, task_priority: _sliderValue.toInt());
                    taskDatabase.addTask(taskData);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage(),));
                  }
                },
                icon: const Icon(Icons.add_task),
                label: const Text('A D D  T A S K'),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
