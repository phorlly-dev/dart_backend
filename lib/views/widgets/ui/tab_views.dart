import 'package:dart_backend/views/widgets/ui/app_entire.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';

class TabViews extends StatefulWidget {
  final int index;
  final List<IconData>? icons;
  final List<String?> labels;
  final List<Widget> pages;

  const TabViews({
    super.key,
    required this.index,
    required this.pages,
    this.icons,
    required this.labels,
  });

  @override
  State<TabViews> createState() => _TabViewsState();
}

class _TabViewsState extends State<TabViews> with TickerProviderStateMixin {
  late MotionTabBarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MotionTabBarController(
      initialIndex: 1,
      length: widget.index,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppEntire(
      content: TabBarView(
        controller: _controller,
        children: widget.pages,
      ),
      tab: MotionTabBar(
        initialSelectedTab: widget.labels[1] ?? '',
        labels: widget.labels,
        icons: widget.icons,
        controller: _controller,
        onTabItemSelected: (val) => setState(() {
          _controller.index = val;
        }),
        tabSelectedColor: Colors.blue[800],
      ),
    );
  }
}
