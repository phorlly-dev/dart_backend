import 'package:dart_backend/views/widgets/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DataView<T> extends StatelessWidget {
  final int itemCounter;
  final bool? isLoading;
  final String? hasError;
  final List<T>? notFound;
  final String noDataMessage;
  final NullableIndexedWidgetBuilder itemBuilder;

  const DataView({
    super.key,
    required this.itemBuilder,
    required this.itemCounter,
    this.isLoading = false,
    this.hasError = '',
    this.notFound = const [],
    this.noDataMessage = 'No data found!',
  });

  @override
  Widget build(BuildContext context) {
    // If loading, show a loading animation
    if (isLoading == true) {
      return Container(
        margin: EdgeInsets.only(top: .3.sh),
        child: LoadingAnimation(type: LoadingType.cupertino),
      );
    }

    // If an error is present, show the error message
    if (hasError!.isNotEmpty) {
      return Container(
        margin: EdgeInsets.only(top: .3.sh),
        child: LoadingAnimation(label: hasError!),
      );
    }

    // If no items are found and notFound is empty, show a loading animation
    if (notFound == null || notFound!.isEmpty) {
      return Container(
        margin: EdgeInsets.only(top: .3.sh),
        child: LoadingAnimation(
          label: noDataMessage,
          type: LoadingType.cupertino,
        ),
      );
    }

    // If items are found, display them in a ListView
    return ListView.builder(
      primary: false,
      itemCount: itemCounter,
      itemBuilder: itemBuilder,
      physics: NeverScrollableScrollPhysics(), // Not scrollable
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}
