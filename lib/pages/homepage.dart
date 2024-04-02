import 'package:flutter/material.dart';
import 'package:task_management/database/task_database.dart';
import 'package:task_management/pages/search_task.dart';
import 'package:task_management/pages/show_task.dart';
import 'package:task_management/pages/util/bottom_nav_bar.dart';
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

  bool isListView = true;

  @override
  Widget build(BuildContext context) {
    List pages = [
      ShowTask(
        isListView: isListView,
      ),
      const SearchTask(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Task Manager",
          style: appBarTextStyle,
        ),
        actions: [
          _selectedIndex == 0
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isListView = !isListView;
                    });
                  },
                  icon: isListView
                      ? const Icon(Icons.grid_on)
                      : const Icon(Icons.list),
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
