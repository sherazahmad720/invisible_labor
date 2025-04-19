import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:labor/controllers/auth_controller.dart';
import 'package:labor/models/workspace_model.dart';
import 'package:labor/utils/extentions.dart';

class WorkspaceDetailedCard extends StatelessWidget {
  const WorkspaceDetailedCard({super.key, required this.workspaceModel});
  final WorkspaceModel workspaceModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                workspaceModel.name ?? '',
                style: context.textTheme.titleLarge?.copyWith(
                  color: context.theme.primaryColor,
                ),
              ),
            ),

            GetBuilder<AuthController>(
              builder: (controller) {
                return controller.selectedWorkSpace?.ref?.id !=
                        workspaceModel.ref?.id
                    ? SizedBox()
                    : Icon(
                      Icons.check,
                      size: 30,
                      color: context.theme.colorScheme.primary,
                    );
              },
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}
