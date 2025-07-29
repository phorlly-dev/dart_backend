import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<T?> confirmDelete<T>({
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

Future<T?> showFormDialog<T>(
  BuildContext ctx, {
  T? model,
  required String title,
  required List<Widget> children,
  required VoidCallback store,
  required VoidCallback release,
}) {
  final isEditing = model != null;
  final formKey = GlobalKey<FormState>();
  final colors = Theme.of(ctx).colorScheme;

  return Get.dialog(
    AlertDialog(
      title: Center(child: Text(isEditing ? 'Edit $title' : 'New $title')),
      content: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(mainAxisSize: MainAxisSize.min, children: children),
      ),
      actions: [
        ElevatedButton.icon(
          onPressed: () => Get.back(),
          label: Text('Cancel'),
          icon: Icon(Icons.close_rounded),
          autofocus: true,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.secondary, // Dark color (for Cancel)
            foregroundColor: Colors.white, // Text/Icon color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            if (!formKey.currentState!.validate()) return;

            if (isEditing) {
              // update existing
              release.call();
            } else {
              // create new
              store.call();
            }
            Get.back();
          },
          autofocus: true,
          icon: Icon(isEditing ? Icons.update : Icons.save),
          label: Text(isEditing ? 'Update' : 'Save'),
          style: ElevatedButton.styleFrom(
            backgroundColor: isEditing ? colors.outline : colors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
      scrollable: true,
      actionsAlignment: MainAxisAlignment.center,
    ),
    barrierDismissible: false,
  );
}
