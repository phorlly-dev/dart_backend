import 'package:dart_backend/controllers/auth_controller.dart';
import 'package:dart_backend/views/screens/auth.dart';
import 'package:dart_backend/views/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppShellScreen extends StatelessWidget {
  const AppShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Obx(() {
      // 1️⃣ still loading?
      if (auth.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      // 2️⃣ no user or not “remembered” → show login
      final user = auth.currentUser.value;
      if (user == null) {
        return const AuthScreen();
      }

      // 3️⃣ otherwise we have a remembered user → home
      return HomeScreen(user: user);
    });
  }
}
