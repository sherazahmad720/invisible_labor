import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labor/controllers/auth_controller.dart';
import 'package:labor/utils/app_colors.dart';
import 'package:labor/utils/extentions.dart';
import 'package:labor/views/screens/auth/forget_password_screen.dart';
import 'package:labor/views/screens/auth/register_screen.dart';
import 'package:labor/views/widgets/custom_button.dart';
import 'package:labor/views/widgets/custom_text_form_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final RxBool isPasswordVisible = false.obs;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  30.verticalSpace,
                  // Image.asset(
                  //   AppImages.splash,
                  //   width: 120,
                  //   height: 120,
                  // ),
                  24.verticalSpace,
                  Text(
                    'Welcome Back! 👋',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  8.verticalSpace,
                  Text(
                    'Sign in to continue',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                  ),
                  32.verticalSpace,
                  CustomTextFormField(
                    controller: emailController,
                    // validator: AppValidators.emailValidator.call,
                    keyboardType: TextInputType.emailAddress,
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icons.email_outlined,
                  ),
                  16.verticalSpace,
                  Obx(
                    () => CustomTextFormField(
                      controller: passwordController,
                      // validator: AppValidators.passwordValidator.call,
                      obscureText: !isPasswordVisible.value,
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () => isPasswordVisible.toggle(),
                      ),
                    ),
                  ),
                  8.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Get.to(ForgetPasswordScreen()),
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  24.verticalSpace,
                  Obx(
                    () => CustomButton(
                      buttonText: 'Login',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          authController.login(
                            emailController.text.trim(),
                            passwordController.text,
                          );
                        }
                      },
                      isLoading: authController.isLoading.value,
                    ),
                  ),
                  24.verticalSpace,
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[300])),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[300])),
                    ],
                  ),
                  24.verticalSpace,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      TextButton(
                        onPressed: () => Get.to(RegisterScreen()),
                        child: Text(
                          'Create an Account',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  24.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
