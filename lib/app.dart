import 'package:dart_backend/views/screens/app/app_shell.dart';
import 'package:dart_backend/views/screens/auth/auth.dart';
import 'package:dart_backend/views/screens/auth/profile.dart';
import 'package:dart_backend/views/screens/events/create_or_edit_event.dart';
import 'package:dart_backend/views/screens/events/event.dart';
import 'package:dart_backend/views/screens/events/event_detail.dart';
import 'package:dart_backend/views/screens/app/splash.dart';
import 'package:dart_backend/views/screens/tasks/create_or_edit_task.dart';
import 'package:dart_backend/views/screens/users/create_or_edit_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dart Back-End',
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/app-shell', page: () => const AppShellScreen()),
        GetPage(name: '/auth', page: () => const AuthScreen()),

        //Users
        GetPage(name: '/users/profile', page: () => const ProfileScreen()),
        GetPage(
            name: '/users/create-or-edit',
            page: () => const CreateOrEditUserScreen()),

        //Tasks
        GetPage(
            name: '/tasks/create-or-edit',
            page: () => const CreateOrEditTaskScreen()),

        //Events
        GetPage(name: '/events', page: () => const EventScreen()),
        GetPage(name: '/events/detail', page: () => const EventDetailScreen()),
        GetPage(
            name: '/events/create-or-edit',
            page: () => const CreateOrEditEventScreen()),
      ],
      theme: ThemeData.light(), // Default light theme
      darkTheme: ThemeData.dark(), // Dark theme
      themeMode: ThemeMode.system, // Follow system or allow toggling

      //initial screen
      navigatorKey: Get.key,
      home: ScreenUtilInit(
        designSize: Size(375, 812),
        minTextAdapt: true,
        builder: (_, __) => const SplashScreen(),
      ),
    );
  }
}
