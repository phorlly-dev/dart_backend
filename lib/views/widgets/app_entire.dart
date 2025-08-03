import 'package:flutter/material.dart';

class AppEntire extends StatelessWidget {
  final Widget? menu, content, button;
  final PreferredSizeWidget? header;

  const AppEntire({
    super.key,
    this.menu,
    this.content,
    this.button,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header,
      drawer: menu == null ? null : SafeArea(child: menu!),
      body: Container(
        margin: EdgeInsets.only(top: 8),
        child: SafeArea(child: content ?? SizedBox.shrink()),
      ),
      floatingActionButton: button,
    );
  }
}
