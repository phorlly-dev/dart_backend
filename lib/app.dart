import 'package:dart_backend/controllers/task_controller.dart';
import 'package:dart_backend/controllers/user_controller.dart';
import 'package:dart_backend/views/screens/app_shell.dart';
import 'package:dart_backend/views/screens/auth.dart';
import 'package:dart_backend/views/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Register controllers / bindings here
    Get.put(TaskController());
    Get.put(UserController());

    return GetMaterialApp(
      title: 'Dart Back-End',
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/app-shell', page: () => const AppShellScreen()),
        GetPage(name: '/auth', page: () => const AuthScreen()),
      ],
      theme: ThemeData.light(), // Default light theme
      darkTheme: ThemeData.dark(), // Dark theme
      themeMode: ThemeMode.system, // Follow system or allow toggling
      //initial screen
      navigatorKey: Get.key,
      home: SplashScreen(),
    );
  }
}
