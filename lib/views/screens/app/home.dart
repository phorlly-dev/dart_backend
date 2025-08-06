import 'package:dart_backend/models/user_response.dart';
import 'package:dart_backend/views/widgets/ui/app_entire.dart';
import 'package:dart_backend/views/widgets/ui/nav_bar.dart';
import 'package:dart_backend/views/widgets/ui/side_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final UserResponse? user;

  const HomeScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return AppEntire(
      header: NavBar(title: "Welcome", isDark: true),
      menu: SideBar(me: user),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 24,
        children: [
          Center(
            child: Text(
              'Flutter with SQLite',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          Center(
            child: Text(
              'Flutter with SQLite',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
          ),
          Center(
            child: Text(
              'Flutter with SQLite',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ),
          Center(
            child: Text(
              'Flutter with SQLite',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
          Center(
            child: Text(
              'Flutter with SQLite',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
            ),
          ),
          Center(
            child: Text(
              'Flutter with SQLite',
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
