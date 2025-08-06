import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum LoadingType { circular, cupertino }

class LoadingAnimation extends StatelessWidget {
  final LoadingType type;
  final String label;

  const LoadingAnimation({
    super.key,
    this.label = "Loading...",
    this.type = LoadingType.circular,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(label), SizedBox(height: 16), _widget()],
      ),
    );
  }

  Widget _widget() {
    Widget loading = CircularProgressIndicator();
    switch (type) {
      case LoadingType.cupertino:
        loading = CupertinoActivityIndicator();
        break;
      default:
        loading = CircularProgressIndicator();
    }

    return loading;
  }
}
