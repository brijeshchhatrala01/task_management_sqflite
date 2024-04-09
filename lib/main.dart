import 'package:flutter/material.dart';
import 'package:task_management/pages/homepage.dart';
import 'package:task_management/theme/theme.dart';

void main() async {
  runApp(const MyApp());
}

//materialapp widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: const Homepage(),
    );
  }
}
