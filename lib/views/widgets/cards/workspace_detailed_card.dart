import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labor/controllers/auth_controller.dart';
import 'package:labor/models/user_model.dart';
import 'package:labor/models/workspace_model.dart';
import 'package:labor/services/firebase_services.dart';

class WorkspaceDetailedCard extends StatelessWidget {
  WorkspaceDetailedCard({
    super.key,
    required this.workspaceModel,
    required this.onTap,
  });
  final WorkspaceModel workspaceModel;
  final AuthController authController = Get.find<AuthController>();
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  workspaceModel.name ?? '',
                  style: context.textTheme.titleLarge?.copyWith(
                    color: context.theme.colorScheme.primary,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${workspaceModel.members?.length ?? 0} Member${(workspaceModel.members?.length ?? 0) <= 1 ? '' : 's'}',
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.theme.hintColor,
                ),
              ),
              FutureBuilder(
                future: FirebaseServices.getUser(
                  workspaceModel.createdBy ?? '-',
                ),
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
