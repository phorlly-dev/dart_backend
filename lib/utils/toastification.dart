import 'package:flutter/cupertino.dart';
import 'package:toastification/toastification.dart';

enum Toast { success, error, warning, info }

void showToast(
  BuildContext ctx, {
  Toast type = Toast.success,
  required String title,
  String? message,
  int autoClose = 3,
}) {
  switch (type) {
    case Toast.success:
      toastification.showSuccess(
        context: ctx,
        title: title,
        description: message,
        autoCloseDuration: Duration(seconds: autoClose),
      );
      break;
    case Toast.warning:
      toastification.showWarning(
        context: ctx,
        title: title,
        description: message,
        autoCloseDuration: Duration(seconds: autoClose),
      );
      break;
    case Toast.info:
      toastification.show(
        context: ctx,
        title: title,
        description: message,
        autoCloseDuration: Duration(seconds: autoClose),
      );
      break;
    default:
      toastification.showError(
        context: ctx,
        title: title,
        description: message,
      );
  }
}
