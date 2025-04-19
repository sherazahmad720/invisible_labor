import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labor/controllers/auth_controller.dart';
import 'package:labor/models/workspace_model.dart';
import 'package:labor/services/firebase_services.dart';
import 'package:labor/utils/extentions.dart';
import 'package:labor/views/widgets/custom_button.dart';
import 'package:labor/views/widgets/custom_text_form_field.dart';

class WorkspaceForm extends StatefulWidget {
  const WorkspaceForm({super.key});

  @override
  State<WorkspaceForm> createState() => _WorkspaceFormState();
}

class _WorkspaceFormState extends State<WorkspaceForm> {
  TextEditingController nameController = TextEditingController();
  AuthController _authController = Get.find<AuthController>();
  GlobalKey<FormState> formKey = GlobalKey();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: formKey,
          child: CustomTextFormField(
            controller: nameController,
            validator: (val) {
              if ((val?.trim() ?? '').isEmpty) {
                return 'Name is required';
              }
              return null;
            },
            labelText: 'Workspace Name',
            hintText: 'Write you workspace name here...',
          ),
        ),
        30.height,
        CustomButton(
          buttonText: 'Save',
          isLoading: isLoading,
          onPressed: () async {
            if (!formKey.currentState!.validate()) {
              return;
            }
            setState(() {
              isLoading = true;
            });
            WorkspaceModel workspaceModel = WorkspaceModel(
              createdBy: FirebaseAuth.instance.currentUser?.uid ?? '-',
              members: [FirebaseAuth.instance.currentUser?.uid ?? '-'],
              name: nameController.text,
            );

            DocumentReference? ref = await FirebaseServices.createWorkspace(
              workspaceModel,
            );
            if (ref != null) {
              DocumentSnapshot doc = await ref.get();
              if (doc.exists) {
                _authController.selectWorkSpace = WorkspaceModel.fromDoc(doc);
                _authController.update();
              }
            }

            setState(() {
              isLoading = false;
            });
            Get.back();
          },
        ),
      ],
    );
  }
}
