import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:labor/models/user_model.dart';
import 'package:labor/models/workspace_model.dart';
import 'package:labor/services/firebase_services.dart';
import 'package:labor/utils/app_helper.dart';
import 'package:labor/utils/extentions.dart';
import 'package:labor/views/widgets/bottom_sheets/user_search_form.dart';
import '../../widgets/cards/user_card.dart';

class WorkspaceDetailsScreen extends StatelessWidget {
  const WorkspaceDetailsScreen({super.key, required this.workspaceModel});
  final WorkspaceModel workspaceModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(workspaceModel.name ?? "")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Created on: ${DateFormat('dd MMM,yyyy').format(workspaceModel.createAt ?? DateTime(2025))}',
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.theme.hintColor,
                  ),
                ),
              ],
            ),
            10.height,
            Divider(),
            10.height,
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Members',
                    style: context.textTheme.titleLarge,
                    maxLines: 1,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    AppHelper().showCustomBottomSheet(
                      context,
                      UserSearchForm(workspaceModel: workspaceModel),
                      'Add Member',
                      isMaxSize: true,
                    );
                  },
                  label: Text('Add Members'),
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            for (String id in workspaceModel.members ?? [])
              FutureBuilder(
                future: FirebaseServices.getUser(
                  workspaceModel.createdBy ?? '-',
                ),
                builder: (ctx, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    UserModel user = snapshot.data!;
                    return UserCard(
                      userModel: user,
                      isCreator: user.id == workspaceModel.createdBy,
                    );
                  }
                  return SizedBox(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: 50,
                      height: 20,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
