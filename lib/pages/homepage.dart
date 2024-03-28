import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:task_management/database/task_database.dart';
import 'package:task_management/pages/add_task.dart';
import 'package:task_management/pages/search_task.dart';
import 'package:task_management/pages/show_task.dart';
import 'package:task_management/pages/util/bottom_nav_bar.dart';
import 'package:task_management/theme/colors.dart';
import 'package:task_management/theme/theme.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  TaskDatabase taskDatabase = TaskDatabase();

  @override
  void initState() {
    taskDatabase.openDataBase();
    super.initState();
  }

  int _selectedIndex = 0;

  void navBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> pages = [
    const ShowTask(),
    SearchTask(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Task Manager",
          style: appBarTextStyle,
        ),
        actions: [
          _selectedIndex == 0
              ? IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.list),
                )
              : Container()
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onTabChange: (value) {
          navBottomBar(value);
        },
      ),
      body: pages[_selectedIndex],
    );
  }
}
