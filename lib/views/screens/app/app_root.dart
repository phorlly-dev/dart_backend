import 'package:dart_backend/models/user_response.dart';
import 'package:dart_backend/utils/index.dart';
import 'package:dart_backend/views/screens/app/home.dart';
import 'package:dart_backend/views/screens/events/event.dart';
import 'package:dart_backend/views/screens/tasks/task.dart';
import 'package:dart_backend/views/screens/users/user.dart';
import 'package:dart_backend/views/widgets/ui/tab_views.dart';
import 'package:flutter/material.dart';

class AppRootScreen extends StatelessWidget {
  final UserResponse? me;

  const AppRootScreen({super.key, this.me});

  @override
  Widget build(BuildContext context) {
    final wigets = TabViewPages(
      labels: ["Events", "Home", "Users", "Tasks"],
      icons: [
        Icons.event_available,
        Icons.home,
        Icons.people_alt,
        Icons.task_rounded,
        // Icons.format_align_justify_outlined,
      ],
      pages: [
        EventScreen(),
        HomeScreen(user: me),
        UserScreen(me: me),
        TaskScreen(),
        // SubmitFormBuilder(),
      ],
    );

    return TabViews(
      index: wigets.pages.length,
      labels: wigets.labels,
      icons: wigets.icons,
      pages: wigets.pages,
    );
  }
}
