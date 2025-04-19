import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:labor/models/workspace_model.dart';
import 'package:labor/utils/extentions.dart';

class WorkspaceCard extends StatelessWidget {
  const WorkspaceCard({super.key, required this.workspaceModel});
  final WorkspaceModel workspaceModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'workspace',
                style: context.textTheme.labelLarge?.copyWith(
                  color: context.theme.hintColor,
                ),
              ),
              10.height,
              Text(
                workspaceModel.name ?? '',
                style: context.textTheme.titleLarge?.copyWith(
                  color: context.theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        Icon(Icons.arrow_drop_down_circle, size: 30),
      ],
    );
  }
}
