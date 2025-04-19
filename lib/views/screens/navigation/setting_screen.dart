import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labor/controllers/auth_controller.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});
  AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Container(
        child: Column(
          children: [
            Spacer(),
            ElevatedButton(
              onPressed: () {
                authController.logout();
              },
              child: Text('logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
