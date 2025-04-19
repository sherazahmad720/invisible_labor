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
import 'package:shimmer/shimmer.dart';

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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Stats',
                          style: context.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GetBuilder<DashboardController>(
                        builder: (controller) {
                          return SegmentedButton(
                            segments: [
                              ButtonSegment(
                                label: Text('Yearly'),
                                value: 'yearly',
                              ),
                              ButtonSegment(
                                label: Text('Monthly'),
                                value: 'monthly',
                              ),
                              ButtonSegment(
                                label: Text('Weekly'),
                                value: 'weekly',
                              ),
                            ],
                            multiSelectionEnabled: false,
                            selected: {controller.selectedDuration},
                            onSelectionChanged: (val) {
                              controller.selectedDuration = val.first;
                              controller.updateDashboard();
                              controller.update();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  20.height,
                  GetBuilder<DashboardController>(
                    builder: (controller) {
                      return Row(
                        children: [
                          Expanded(
                            child:
                                controller.loading
                                    ? dashboardStatCardShimmer()
                                    : dashboardStatCard(
                                      context,
                                      'Total Tasks',
                                      (controller.count).toString(),
                                    ),
                          ),
                          Expanded(
                            child:
                                controller.loading
                                    ? dashboardStatCardShimmer()
                                    : dashboardStatCard(
                                      context,
                                      'Average Time',
                                      '${controller.averageTime} Mins',
                                    ),
                          ),
                        ],
                      );
                    },
                  ),

                  20.height,

                  FutureBuilder(
                    future:
                        FirebaseServices()
                            .myRecentTasksQuery(
                              controller.selectedWorkSpace?.ref?.id ?? '',
                            )
                            .limit(1)
                            .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final TaskModel taskModel = TaskModel.fromDoc(
                          snapshot.data!.docs[0],
                        );
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recent Task',
                              style: context.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            20.height,

                            TaskCard(taskModel: taskModel),
                          ],
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget dashboardStatCard(BuildContext context, String label, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(label, textAlign: TextAlign.left),
                ),
                10.height,
                Text(value, style: context.textTheme.headlineLarge),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardStatCardShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.grey[300]!,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(height: 70),
        ),
      ),
    );
  }
}
