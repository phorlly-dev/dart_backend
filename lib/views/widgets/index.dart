import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> confirmDelete<T>({
  required String title,
  required VoidCallback onConfirm,
}) {
  return Get.defaultDialog<T>(
    title: 'Are you sure?',
    middleText: 'Remove "$title"?',
    onConfirm: () {
      onConfirm.call();
      Get.back();
      Get.snackbar(
        "Removed",
        '"$title" from Database!',
        snackPosition: SnackPosition.BOTTOM,
        icon: Icon(Icons.check),
      );
    },
    onCancel: Get.back,
  );
}
