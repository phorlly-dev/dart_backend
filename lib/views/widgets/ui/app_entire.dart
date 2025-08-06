import 'package:flutter/material.dart';

class AppEntire extends StatelessWidget {
  final Widget? menu, content, tab, button;
  final PreferredSizeWidget? header;

  const AppEntire({
    super.key,
    this.menu,
    this.content,
    this.button,
    this.header,
    this.tab,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header,
      drawer: menu == null ? null : SafeArea(child: menu!),
      body: SafeArea(child: content ?? SizedBox.shrink()),
      floatingActionButton: button,
      bottomNavigationBar: tab,
      extendBody: true,
      extendBodyBehindAppBar: true,
    );
  }
}
