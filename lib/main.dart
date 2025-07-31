import 'dart:io';

import 'package:dart_backend/app.dart';
import 'package:dart_backend/controllers/auth_controller.dart';
import 'package:dart_backend/data/database_provider.dart';
import 'package:dart_backend/data/event_db_helper.dart';
import 'package:dart_backend/data/task_db_helper.dart';
import 'package:dart_backend/data/user_db_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1️⃣ Initialize the correct databaseFactory
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

  // 2️⃣ Load .env (if you’re using flutter_dotenv)
  await dotenv.load(fileName: ".env");

  // 3️⃣ register all table DDL
  TaskDbHelper(); // registers tasks table
  EventDbHelper(); // registers events table
  UserDbHelper(); // registers users table

  // 3️⃣ Force DB creation before the UI starts
  // Force the database to open (and create all registered tables)
  await DatabaseProvider.instance.database;

  Get.put(AuthController());

  //ScreenUtil
  await ScreenUtil.ensureScreenSize();

  // 4️⃣ Launch your app
  return runApp(
    ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      builder: (_, __) => const MainApp(),
    ),
  );
}
