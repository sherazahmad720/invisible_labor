import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labor/controllers/auth_controller.dart';
import 'package:labor/utils/app_helper.dart';
import 'package:labor/views/widgets/bottom_sheets/work_spaces_list.dart';
import 'package:labor/views/widgets/cards/workspace_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              GetBuilder<AuthController>(
                builder: (controller) {
                  return controller.selectedWorkSpace == null
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
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
