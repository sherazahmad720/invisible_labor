import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labor/controllers/auth_controller.dart';
import 'package:labor/controllers/dashboard_controller.dart';
import 'package:labor/models/task_model.dart';
import 'package:labor/services/firebase_services.dart';
import 'package:labor/utils/app_helper.dart';
import 'package:labor/utils/extentions.dart';
import 'package:labor/views/widgets/bottom_sheets/work_spaces_list.dart';
import 'package:labor/views/widgets/cards/task_card.dart';
import 'package:labor/views/widgets/cards/workspace_card.dart';
import 'package:paginate_firestore_plus/paginate_firestore.dart';

class DashboardScreen extends StatelessWidget {
  DashboardController dashboardController = Get.put(DashboardController());
  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: GetBuilder<AuthController>(
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  controller.selectedWorkSpace == null
                      ? SizedBox()
                      : InkWell(
                        onTap: () {
                          AppHelper().showCustomBottomSheet(
                            context,
                            WorkSpacesList(),
                            'Workspaces',
                          );
                        },
                        child: WorkspaceCard(
                          workspaceModel: controller.selectedWorkSpace!,
                        ),
                      ),
                  20.height,
                  Text(
                    'Stats',
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Recent Tasks',
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PaginateFirestore(
                    itemBuilder: (ctx, docs, index) {
                      final TaskModel taskModel = TaskModel.fromDoc(
                        docs[index],
                      );
                      return TaskCard(taskModel: taskModel);
                    },
                    shrinkWrap: true,
                    query: FirebaseServices().myTasksQuery(
                      controller.selectedWorkSpace?.ref?.id ?? '',
                    ),
                    isLive: true,
                    itemBuilderType: PaginateBuilderType.listView,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
