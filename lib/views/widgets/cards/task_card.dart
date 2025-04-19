import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labor/controllers/auth_controller.dart';
import 'package:labor/models/task_model.dart';
import 'package:labor/models/user_model.dart';
import 'package:labor/services/firebase_services.dart';

class TaskCard extends StatelessWidget {
  TaskCard({super.key, required this.taskModel});
  final TaskModel taskModel;

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  taskModel.title ?? '',
                  style: context.textTheme.titleLarge?.copyWith(
                    // color: context.theme.primaryColor,
                  ),
                ),
              ),

              (taskModel.doneBy ?? '').isEmpty
                  ? SizedBox()
                  : Icon(
                    Icons.check,
                    size: 30,
                    color: context.theme.colorScheme.primary,
                  ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${taskModel.durationInMinutes} Minutes',
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.theme.hintColor,
                ),
              ),
              if ((taskModel.doneBy ?? '').isNotEmpty)
                FutureBuilder(
                  future: FirebaseServices.getUser(taskModel.doneBy ?? '-'),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      UserModel user = snapshot.data!;
                      return Text(
                        'by ${user.displayName ?? '-'}',
                        style: context.textTheme.labelMedium?.copyWith(
                          color: context.theme.hintColor,
                        ),
                      );
                    }
                    return SizedBox(child: Text(''));
                  },
                ),
            ],
          ),

          Divider(),
        ],
      ),
    );
  }
}
