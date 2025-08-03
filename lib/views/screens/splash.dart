import 'dart:io';
import 'package:dart_backend/data/database_provider.dart';
import 'package:dart_backend/data/event_db_helper.dart';
import 'package:dart_backend/data/task_db_helper.dart';
import 'package:dart_backend/data/user_db_helper.dart';
import 'package:dart_backend/utils/notification_service.dart';
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
      // 1️⃣ Load environment
      await dotenv.load(fileName: ".env");

      if (kIsWeb) {
        // Web uses the IndexedDB shim
        databaseFactory = databaseFactoryFfiWeb;
      } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        // Desktop uses ffi
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      } else {
        // Mobile (Android/iOS) — don't touch databaseFactory!
        // sqflite's default platform‐channel factory will be used.
      }

      // 2️⃣ Initialize your database (register tables + open)
      TaskDbHelper();
      EventDbHelper();
      UserDbHelper();
      await DatabaseProvider.instance.database;

      // 3️⃣ Register controllers, ScreenUtil, notifications, etc.
      await ScreenUtil.ensureScreenSize();
      await initNotify();

      // 4️⃣ Done – navigate into your real app shell
      Get.offAllNamed('/app-shell');
    } catch (e) {
      // If anything fails, show an error + retry button
      setState(() => _error = e.toString());
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
