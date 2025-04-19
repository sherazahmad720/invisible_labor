import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:labor/models/user_model.dart';
import 'package:labor/models/workspace_model.dart';
import 'package:labor/services/firebase_services.dart';
import 'package:labor/utils/extentions.dart';
import 'package:labor/views/screens/user_search_form.dart';

import '../../widgets/cards/user_card.dart';

class WorkspaceDetailsScreen extends StatefulWidget {
  WorkspaceDetailsScreen({super.key, required this.workspaceModel});
  WorkspaceModel workspaceModel;

  @override
  State<WorkspaceDetailsScreen> createState() => _WorkspaceDetailsScreenState();
}

class _WorkspaceDetailsScreenState extends State<WorkspaceDetailsScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text(widget.workspaceModel.name ?? "")),
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Created on: ${DateFormat('dd MMM,yyyy').format(widget.workspaceModel.createAt ?? DateTime(2025))}',
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
                      onPressed: () async {
                        var result = await Get.to(
                          () => UserSearchForm(
                            selectedUser: widget.workspaceModel.members ?? [],
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            isLoading = true;
                          });
                          widget.workspaceModel.members?.clear();
                          result.forEach((e) {
                            widget.workspaceModel.members?.add(e.toString());
                          });
                          if (!widget.workspaceModel.members!.contains(
                            FirebaseAuth.instance.currentUser?.uid ?? '-',
                          )) {
                            widget.workspaceModel.members?.add(
                              FirebaseAuth.instance.currentUser?.uid ?? '-',
                            );
                          }

                          await widget.workspaceModel.ref?.update({
                            'members':
                                widget.workspaceModel.members?.toSet().toList(),
                          });
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      label: Text('Add Members'),
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (String id
                            in widget.workspaceModel.members ?? []) ...[
                          FutureBuilder(
                            future: FirebaseServices.getUser(id),
                            builder: (ctx, snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                UserModel user = snapshot.data!;
                                return UserCard(
                                  userModel: user,
                                  isCreator:
                                      user.id ==
                                      widget.workspaceModel.createdBy,
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
                          10.height,
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withAlpha(125),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
