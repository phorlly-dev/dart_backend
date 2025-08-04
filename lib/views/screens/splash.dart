import 'dart:io';

import 'package:dart_backend/controllers/auth_controller.dart';
import 'package:dart_backend/controllers/event_controller.dart';
import 'package:dart_backend/controllers/task_controller.dart';
import 'package:dart_backend/controllers/user_controller.dart';
import 'package:dart_backend/data/database_provider.dart';
import 'package:dart_backend/data/event_db_helper.dart';
import 'package:dart_backend/data/task_db_helper.dart';
import 'package:dart_backend/data/user_db_helper.dart';
import 'package:dart_backend/views/widgets/loading_animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? _error;

  @override
  void initState() {
    super.initState();
    // Defer the heavy work until after the very first frame:
    WidgetsBinding.instance.addPostFrameCallback((_) => _initApp());
  }

  Future<void> _initApp() async {
    try {
      // 1️⃣ Load environment variables
      await dotenv.load(fileName: ".env");

      // 2️⃣ Initialize sqflite factories *before* opening any DB
      if (kIsWeb) {
        databaseFactory = databaseFactoryFfiWeb;
      } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }
      // on mobile do nothing (sqflite auto‐registers)

      // 3️⃣ Register your tables now that env is loaded
      TaskDbHelper();
      EventDbHelper();
      UserDbHelper();

      // 4️⃣ Open the database (this will read DB_NAME and DB_VERSION from dotenv.env)
      await DatabaseProvider.instance.database;

      // 5️⃣ Other inits (ScreenUtil, controllers…)
      await ScreenUtil.ensureScreenSize();
      Get.put(AuthController());
      Get.put(TaskController());
      Get.put(UserController());
      Get.put(EventController());

      // 6️⃣ All done, navigate to your app shell
      Get.offAllNamed('/app-shell');
    } catch (e) {
      // If anything fails, show an error + retry button
      setState(() => _error = e.toString());
      debugPrint('Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // If we hit an error, show a retry UI:
    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Initialization failed:\n$_error',
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _error = null;
                  });
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => _initApp());
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Otherwise show your loading animation
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/browser.png", width: 120),
            const SizedBox(height: 24),
            LoadingAnimation(
              type: LoadingType.cupertino,
              label: "Please Wait...",
            ),
          ],
        ),
      ),
    );
  }
}
