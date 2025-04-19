import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labor/controllers/auth_controller.dart';
import 'package:labor/models/workspace_model.dart';
import 'package:labor/services/firebase_services.dart';
import 'package:labor/utils/app_helper.dart';
import 'package:labor/utils/enum/button_type.dart';
import 'package:labor/utils/extentions.dart';
import 'package:labor/views/widgets/bottom_sheets/workspace_form.dart';
import 'package:labor/views/widgets/cards/workspace_detailed_card.dart';
import 'package:labor/views/widgets/custom_button.dart';
import 'package:paginate_firestore_plus/paginate_firestore.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: context.theme.colorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: context.theme.colorScheme.onPrimary,
        actionsPadding: EdgeInsets.symmetric(horizontal: 12),
        title: Row(
          children: [
            Text(
              'Settings',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            10.width,
            Icon(Icons.settings_outlined, color: context.iconColor),
          ],
        ),

        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: GetBuilder(
          init: authController,
          builder:
              (authController) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.height,
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: context.theme.colorScheme.primary,
                        backgroundImage:
                            authController.userModel?.photoUrl != null
                                ? CachedNetworkImageProvider(
                                  authController.userModel!.photoUrl!,
                                )
                                : null,
                        child:
                            authController.userModel?.photoUrl == null
                                ? Icon(
                                  Icons.person_2,
                                  size: 50,
                                  color: context.theme.colorScheme.onPrimary,
                                )
                                : null,
                      ),
                      20.width,
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(authController.userModel?.displayName ?? ''),
                            Text(authController.userModel?.email ?? ''),
                          ],
                        ),
                      ),
                      CustomButton(
                        buttonText: 'Edit',
                        buttonType: ButtonType.bordered,
                        trailingIcon: Icons.edit,
                        buttonHeight: 45,
                        fontSize: 16,
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          24.height,
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Workspace',
                                  style: context.textTheme.titleLarge,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  AppHelper().showCustomBottomSheet(
                                    context,
                                    WorkspaceForm(),
                                    'Create Workspace',
                                    isMaxSize: true,
                                  );
                                },
                                label: Text('Create new workspace'),
                                icon: Icon(Icons.add),
                              ),
                            ],
                          ),
                          10.height,
                          PaginateFirestore(
                            itemBuilder: (ctx, docs, index) {
                              final WorkspaceModel workspaceModel =
                                  WorkspaceModel.fromDoc(docs[index]);
                              return WorkspaceDetailedCard(
                                workspaceModel: workspaceModel,
                              );
                            },
                            shrinkWrap: true,
                            query: FirebaseServices.myWorkspacesQuery,
                            isLive: true,
                            itemBuilderType: PaginateBuilderType.listView,
                          ),
                        ],
                      ),
                    ),
                  ),
                  24.height,
                  CustomButton(
                    buttonText: 'Logout',
                    buttonColor: context.theme.colorScheme.error,
                    onPressed: () => authController.logout(),
                    buttonType: ButtonType.opacity,
                    leadingIcon: Icons.logout,
                  ),
                  12.height,
                ],
              ),
        ),
      ),
    );
  }
}
