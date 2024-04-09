import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:task_management/theme/colors.dart';


//custom bottom navigationbar for homepage
class CustomBottomNavigationBar extends StatelessWidget {
  final Function(int value)? onTabChange;
  const CustomBottomNavigationBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: GNav(
        activeColor: activeTabColor,
        tabBackgroundColor: tabBackgroundColor,
        tabBorderRadius: 24,
        tabActiveBorder: Border.all(color: activeTabColor),
        iconSize: 22,
        mainAxisAlignment: MainAxisAlignment.center,
        onTabChange: onTabChange,
        tabs: [
          GButton(
            backgroundColor: tabBackgroundColor,
            icon: Icons.home,
            text: "Homepage",
            padding: const EdgeInsets.all(18),
            borderRadius: BorderRadius.circular(8),
          ),
          GButton(
            icon: Icons.search,
            text: "Search Task",
            backgroundColor: tabBackgroundColor,
            padding: const EdgeInsets.all(20),
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }
}
