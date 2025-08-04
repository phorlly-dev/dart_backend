import 'package:dart_backend/app.dart';
import 'package:dart_backend/utils/notification_service.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotify();

  runApp(const MainApp());
}
