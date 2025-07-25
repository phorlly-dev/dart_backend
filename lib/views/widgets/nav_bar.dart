import 'package:flutter/material.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const NavBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: AppBar(centerTitle: true, title: Text(title)));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
