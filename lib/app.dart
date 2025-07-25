import 'package:dart_backend/controllers/task_controller.dart';
import 'package:dart_backend/views/screens/home.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //initial screen
      home: HomeScreen(),
    );
  }
}
