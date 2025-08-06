import 'package:dart_backend/views/widgets/ui/app_entire.dart';
import 'package:dart_backend/views/widgets/ui/nav_bar.dart';
import 'package:flutter/material.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppEntire(
      header: NavBar(title: "Welcome to Tasks"),
      content: Container(),
    );
  }
}
