import 'package:dart_backend/views/screens/app_shell.dart';
import 'package:dart_backend/views/screens/auth.dart';
import 'package:dart_backend/views/screens/create_edit_event.dart';
import 'package:dart_backend/views/screens/event_detail.dart';
import 'package:dart_backend/views/screens/splash.dart';
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
        GetPage(name: '/event/detail', page: () => const EventDetailScreen()),
        GetPage(
          name: '/event/create-or-edit',
          page: () => const CreateEditEventScreen(),
        ),
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
