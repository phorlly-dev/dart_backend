import 'package:dart_backend/controllers/task_controller.dart';
import 'package:dart_backend/views/screens/auth.dart';
import 'package:dart_backend/views/screens/home.dart';
import 'package:dart_backend/views/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Register controllers / bindings here
    Get.put(TaskController());

    return GetMaterialApp(
      title: 'Dart Back-End',
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/auth', page: () => AuthScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),
      ],
      theme: ThemeData.light(), // Default light theme
      darkTheme: ThemeData.dark(), // Dark theme
      themeMode: ThemeMode.system, // Follow system or allow toggling
      //initial screen
      home: HomeScreen(),
    );
  }
}
