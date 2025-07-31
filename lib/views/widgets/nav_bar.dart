import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;

  const NavBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.bottom,
  });

  @override
  State<NavBar> createState() => _NavBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _NavBarState extends State<NavBar> {
  bool isDark = Get.isDarkMode;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: widget.leading,
      elevation: 1,
      centerTitle: true,
      title: Text(widget.title),
      actions: [
        ...?widget.actions,
        IconButton(
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          onPressed: () {
            Get.changeTheme(isDark ? ThemeData.light() : ThemeData.dark());
            setState(() {
              isDark = !isDark;
            });
          },
          tooltip: 'Toggle Theme',
        ),
      ],
      bottom: widget.bottom,
    );
  }
}
