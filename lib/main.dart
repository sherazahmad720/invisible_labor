import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:labor/firebase_options.dart';
import 'package:labor/utils/theme.dart';
import 'package:labor/utils/util.dart';
import 'package:labor/views/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Roboto", "Roboto");

    MaterialTheme theme = MaterialTheme(textTheme);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Invisible Labor',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      home: const SplashScreen(),
    );
  }
}
