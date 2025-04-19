import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:labor/models/workspace_model.dart';
import 'package:labor/services/firebase_services.dart';
import 'package:labor/utils/app_helper.dart';
import 'package:labor/utils/extentions.dart';
import 'package:labor/views/widgets/bottom_sheets/workspace_form.dart';
import 'package:labor/views/widgets/cards/workspace_card.dart';
import 'package:paginate_firestore_plus/paginate_firestore.dart';

import '../cards/workspace_detailed_card.dart';

class WorkSpacesList extends StatelessWidget {
  const WorkSpacesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                AppHelper().showCustomBottomSheet(
                  context,
                  WorkspaceForm(),
                  'Create Workspace',
                  isMaxSize: false,
                );
              },
              label: Text('Create a workspace'),
              icon: Icon(Icons.add),
            ),
          ],
        ),
        20.height,
        PaginateFirestore(
          itemBuilder: (ctx, docs, index) {
            final WorkspaceModel workspaceModel = WorkspaceModel.fromDoc(
              docs[index],
            );
            return WorkspaceDetailedCard(workspaceModel: workspaceModel);
          },
          shrinkWrap: true,
          query: FirebaseServices.myWorkspacesQuery,
          isLive: true,
          itemBuilderType: PaginateBuilderType.listView,
        ),
      ],
    );
  }
}
