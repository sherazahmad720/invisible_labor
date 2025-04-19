import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labor/models/user_model.dart';
import 'package:labor/models/workspace_model.dart';
import 'package:labor/services/firebase_services.dart';

class WorkspaceTile extends StatelessWidget {
  const WorkspaceTile({super.key, required this.workspaceModel});

  final WorkspaceModel workspaceModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 5),
      color: context.theme.colorScheme.onPrimary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(workspaceModel.name ?? ''),
            Row(
              children: [
                ...(workspaceModel.members ?? []).map(
                  (e) => FutureBuilder(
                    future: FirebaseServices.userCollection.doc(e).get(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        final UserModel userModel = UserModel.fromDoc(
                          snapshot.data!,
                        );
                        return Padding(
                          padding: const EdgeInsets.only(right: 3),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: context.theme.colorScheme.primary
                                .withOpacity(0.4),
                            backgroundImage:
                                userModel.photoUrl != null
                                    ? CachedNetworkImageProvider(
                                      userModel.photoUrl!,
                                    )
                                    : null,
                            child:
                                (userModel.photoUrl ?? '').isEmpty
                                    ? Center(
                                      child: Text(
                                        (userModel.displayName?[0] ?? '')
                                            .toUpperCase(),
                                        style:
                                            context
                                                .theme
                                                .textTheme
                                                .headlineSmall,
                                      ),
                                    )
                                    : null,
                          ),
                        );
                      }
                      return SizedBox();
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: context.theme.colorScheme.primary,
                    child: Icon(
                      Icons.add,
                      size: 15,
                      color: context.theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
