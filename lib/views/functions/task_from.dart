import 'package:dart_backend/controllers/task_controller.dart';
import 'package:dart_backend/models/task.dart';
import 'package:dart_backend/utils/toastification.dart';
import 'package:dart_backend/views/functions/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> taskForm(BuildContext context, {Task? task}) {
  final TaskController ctrl = Get.find();
  final title = TextEditingController(text: task?.title ?? '');
  final done = (task?.done ?? false).obs;

  return showFormDialog<Task>(
    context,
    model: task,
    title: 'Task',
    children: [
      // Title field
      TextFormField(
        controller: title,
        decoration: const InputDecoration(labelText: 'Title'),
        validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
      ),
      const SizedBox(height: 8),
      // Done checkbox (only show when editing, optional)
      Obx(
        () => CheckboxListTile(
          value: done.value,
          title: const Text('Done'),
          onChanged: (v) => done.value = v ?? false,
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ),
    ],
    store: () async {
      await ctrl.store(Task(title: title.text.trim(), done: done.value));
      if (!context.mounted) return;
      showToast(
        context,
        type: Toast.info,
        title: 'Task',
        message: 'The task saved.',
      );
    },
    release: () async {
      await ctrl.change(
        task!.copyWith(title: title.text.trim(), done: done.value),
      );
      if (!context.mounted) return;
      showToast(context, title: 'Task', message: 'The task updated.');
    },
  );
}
