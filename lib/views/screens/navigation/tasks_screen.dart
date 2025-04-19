import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labor/controllers/auth_controller.dart';
import 'package:labor/models/task_model.dart';
import 'package:labor/services/firebase_services.dart';
import 'package:labor/utils/app_helper.dart';
import 'package:labor/views/widgets/bottom_sheets/task_form.dart';
import 'package:labor/views/widgets/cards/task_card.dart';
import 'package:paginate_firestore_plus/paginate_firestore.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      floatingActionButton: IconButton.filled(
        onPressed: () {
          AppHelper().showCustomBottomSheet(
            context,
            TaskForm(),
            'Create Task',
            isMaxSize: false,
          );
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
        icon: Icon(Icons.add, color: context.theme.colorScheme.onPrimary),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 30, 12, 0),
          child: PaginateFirestore(
            itemBuilder: (ctx, docs, index) {
              final TaskModel taskModel = TaskModel.fromDoc(docs[index]);
              return TaskCard(taskModel: taskModel);
            },
            shrinkWrap: true,
            query: FirebaseServices().myTasksQuery(
              authController.selectedWorkSpace?.ref?.id ?? '',
            ),
            isLive: true,
            itemBuilderType: PaginateBuilderType.listView,
          ),
        ),
      ),
    );
  }
}
