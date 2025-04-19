import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labor/controllers/auth_controller.dart';
import 'package:labor/services/firebase_services.dart';
import 'package:labor/utils/app_validator.dart';
import 'package:labor/utils/extentions.dart';
import 'package:labor/views/widgets/custom_button.dart';
import 'package:labor/views/widgets/custom_text_form_field.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find<AuthController>();

    // Initialize controllers with current values
    _nameController.text = authController.userModel?.displayName ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Edit Profile',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: GetBuilder<AuthController>(
        builder:
            (authController) => SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Basic Information',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      16.height,
                      CustomTextFormField(
                        controller: _nameController,
                        validator: AppValidator.nameValidator,
                        labelText: 'Display Name',
                        hintText: 'Enter your display name',
                        prefixIcon: Icons.person_outline,
                        textCapitalization: TextCapitalization.words,
                      ),

                      16.height,

                      CustomButton(
                        buttonText: 'Save Changes',
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await FirebaseServices.updateUser(
                              _nameController.text,
                              authController.userModel?.ref?.id ?? "",
                            );

                            await authController.fetchUserModel();
                            Get.back();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
  }
}
