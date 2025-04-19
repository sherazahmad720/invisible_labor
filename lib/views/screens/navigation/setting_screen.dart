import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labor/controllers/auth_controller.dart';
import 'package:labor/models/workspace_model.dart';
import 'package:labor/services/firebase_services.dart';
import 'package:labor/utils/enum/button_type.dart';
import 'package:labor/utils/extentions.dart';
import 'package:labor/views/widgets/custom_button.dart';
import 'package:labor/views/widgets/workspace_tile.dart';
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
        child: SingleChildScrollView(
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
                    24.height,
                    Text('Workspace'),
                    10.height,
                    PaginateFirestore(
                      itemBuilder: (ctx, docs, index) {
                        final WorkspaceModel workspaceModel =
                            WorkspaceModel.fromDoc(docs[index]);
                        return WorkspaceTile(workspaceModel: workspaceModel);
                      },
                      shrinkWrap: true,
                      query: FirebaseServices.myWorkspacesQuery,
                      isLive: true,
                      itemBuilderType: PaginateBuilderType.listView,
                    ),
                    24.height,
                    CustomButton(
                      buttonText: 'Logout',
                      onPressed: () => authController.logout(),
                      buttonType: ButtonType.opacity,
                      leadingIcon: Icons.logout,
                    ),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}
