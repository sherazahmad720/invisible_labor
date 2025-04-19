import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labor/controllers/auth_controller.dart';
import 'package:labor/utils/app_validator.dart';
import 'package:labor/utils/extentions.dart';
import 'package:labor/views/widgets/custom_button.dart';
import 'package:labor/views/widgets/custom_text_form_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Forgot Password 🔑',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  12.height,
                  Text(
                    'Enter your email address to get an email for a password reset link.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  32.height,
                  // 32.verticalSpace,
                  CustomTextFormField(
                    controller: emailController,
                    validator: AppValidator.emailValidator.call,
                    keyboardType: TextInputType.emailAddress,
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icons.email_outlined,
                  ),
                  24.height,
                  Obx(
                    () => CustomButton(
                      buttonText: 'Reset Password',
                      onPressed:
                          authController.isLoading.value
                              ? null
                              : () {
                                if (formKey.currentState!.validate()) {
                                  authController.forgotPassword(
                                    emailController.text.trim(),
                                  );
                                }
                              },
                      isLoading: authController.isLoading.value,
                    ),
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
