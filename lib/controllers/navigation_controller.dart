import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:labor/models/navigation_model.dart' show NavigationModel;
import 'package:labor/views/screens/navigation/dashboard_screen.dart';
import 'package:labor/views/screens/navigation/setting_screen.dart';
import 'package:labor/views/screens/navigation/tasks_screen.dart';

class NavigationController extends GetxController {
  int _selectedIndex = 0;

  int get selectedIndex {
    return _selectedIndex;
  }

  set selectIndex(int val) {
    _selectedIndex = val;
    update();
  }

  List<NavigationModel> navigationModelList = [
    NavigationModel(icon: Icon(Icons.dashboard), label: 'Dashboard'),
    NavigationModel(icon: Icon(Icons.task_alt_rounded), label: 'Tasks'),
    NavigationModel(icon: Icon(Icons.settings), label: 'Settings'),
  ];

  List<Widget> navigationPages = [
    DashboardScreen(),
    TasksScreen(),
    SettingScreen(),
  ];

  Widget get selectedPage {
    return navigationPages[selectedIndex];
  }
}
