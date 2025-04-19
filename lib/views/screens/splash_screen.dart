import 'package:flutter/material.dart';
import 'package:labor/utils/constants/image_constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(child: Image.asset(ImageConstants.logo)),
      ),
    );
  }
}
