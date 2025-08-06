import 'package:dart_backend/views/partials/schedule.dart';
import 'package:dart_backend/views/widgets/ui/app_entire.dart';
import 'package:dart_backend/views/widgets/ui/nav_bar.dart';
import 'package:flutter/material.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppEntire(
      header: NavBar(title: "Welcome to Events"),
      content: Schedule(),
    );
  }
}
