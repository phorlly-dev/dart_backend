import 'package:dart_backend/app.dart';
import 'package:dart_backend/data/task_db_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1️⃣ Initialize the correct databaseFactory
  if (kIsWeb) {
    // on web: this comes from sqflite_common_ffi_web
    databaseFactory = databaseFactoryFfiWeb;
  } else {
    // on mobile/desktop: initialize the ffi loader
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // 2️⃣ Load .env (if you’re using flutter_dotenv)
  await dotenv.load(fileName: ".env");

  // 3️⃣ Force DB creation before the UI starts
  await TaskDbHelper().database;

  //ScreenUtil
  await ScreenUtil.ensureScreenSize();

  // 4️⃣ Launch your app
  return runApp(
    ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) => const MainApp(),
    ),
  );
}
