import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool isBack;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;
  final bool isDark;

  const NavBar({
    super.key,
    required this.title,
    this.actions,
    this.isBack = false,
    this.bottom,
    this.isDark = false,
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
      leading: widget.isBack
          ? IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back_ios),
            )
          : null,
      // elevation: 4,
      centerTitle: true,
      title: Text(widget.title.toUpperCase()),
      // forceMaterialTransparency: true,
      actions: [
        ...?widget.actions,
        if (widget.isDark)
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
