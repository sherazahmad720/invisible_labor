import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:labor/controllers/auth_controller.dart';
import 'package:labor/models/workspace_model.dart';
import 'package:labor/services/firebase_services.dart';
import 'package:labor/utils/enum/button_type.dart';
import 'package:labor/utils/extentions.dart';
import 'package:labor/views/widgets/custom_button.dart';
import 'package:labor/views/widgets/workspace_card.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});
  AuthController authController = Get.put(AuthController());

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
        actions: [
          IconButton.filled(
            onPressed: () {},
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            icon: Icon(Icons.add, color: context.theme.colorScheme.onPrimary),
          ),
        ],
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
                    StreamBuilder(
                      stream:
                          FirebaseServices.workspaceCollection
                              .where(
                                'members',
                                arrayContains: authController.userModel?.id,
                              )
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return CircularProgressIndicator();
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            primary: true,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final WorkspaceModel workspaceModel =
                                  WorkspaceModel.fromDoc(
                                    snapshot.data!.docs[index],
                                  );
                              return WorkspaceCard(
                                workspaceModel: workspaceModel,
                              );
                            },
                          );
                        }
                        return SizedBox();
                      },
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
