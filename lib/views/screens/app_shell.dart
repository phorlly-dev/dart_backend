import 'package:dart_backend/controllers/auth_controller.dart';
import 'package:dart_backend/utils/index.dart';
import 'package:dart_backend/views/screens/auth.dart';
import 'package:dart_backend/views/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppShellScreen extends StatelessWidget {
  const AppShellScreen({super.key});

  Future<UserParams?> _loadParams() async {
    final auth = Get.find<AuthController>();

    // 1️⃣ If we already have someone in memory, go straight to them:
    final inMemory = auth.currentUser.value;
    if (inMemory != null) {
      return UserParams(info: inMemory);
    }

    // 2️⃣ Otherwise try the persistent remember-me logic:
    final me = await auth.tryAutoLogin();
    if (me == null) return null;

    final args = Get.arguments;
    if (args is UserParams) {
      return args;
    } else if (args is Map) {
      return UserParams(info: args['info']);
    }
    return UserParams(info: me);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserParams?>(
      future: _loadParams(),
      builder: (ctx, snap) {
        // still loading…
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final params = snap.data;
        // no user → show Auth
        if (params == null || params.info == null) {
          return const AuthScreen();
        }
        // logged in → show Home
        return HomeScreen(user: params.info!);
      },
    );
  }
}
