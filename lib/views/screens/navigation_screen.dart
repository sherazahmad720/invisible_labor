import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labor/controllers/auth_controller.dart';
import 'package:labor/controllers/navigation_controller.dart';
import 'package:labor/models/navigation_model.dart';
import 'package:labor/views/widgets/empty_widget.dart';

class NavigationScreen extends StatelessWidget {
  NavigationScreen({super.key});
  NavigationController navigationController = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        return GetBuilder<NavigationController>(
          builder: (controller) {
            return Scaffold(
              body: controller.selectedPage,
              bottomNavigationBar:
              authController.selectedWorkSpace == null
                  ? null
                  :
              BottomNavigationBar(
                currentIndex: controller.selectedIndex,
                onTap: (val) {
                  controller.selectIndex = val;
                },
                items:
                    controller.navigationModelList
                        .map(
                          (NavigationModel e) => BottomNavigationBarItem(
                            label: e.label,
                            icon: e.icon,
                          ),
                        )
                        .toList(),
              ),
            );
          },
        );
      },
    );
  }
}
