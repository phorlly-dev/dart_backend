import 'package:dart_backend/controllers/auth_controller.dart';
import 'package:dart_backend/controllers/task_controller.dart';
import 'package:dart_backend/models/task.dart';
import 'package:dart_backend/models/user.dart';
import 'package:dart_backend/views/forms/task_from.dart';
import 'package:dart_backend/views/widgets/body_content.dart';
import 'package:dart_backend/views/widgets/data_table_view.dart';
import 'package:dart_backend/views/widgets/index.dart';
import 'package:dart_backend/views/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  final User? user;

  const HomeScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final TaskController ctrl = Get.find();

    return BodyContent(
      header: NavBar(
        title: "Welcome, ${user!.name}",
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.find<AuthController>().logout();
              Get.offAllNamed('/auth');
            },
          ),
        ],
      ),
      content: Obx(() {
        return DataTableView<Task>(
          items: ctrl.tasks,
          isLoading: ctrl.isLoading.value,
          hasError: ctrl.errorMessage.value,
          notFound: ctrl.tasks,
          isSelected: (t) => t.done,
          columns: const [
            DataColumn(label: Text('Id')),
            DataColumn(label: Text('Title')),
            DataColumn(label: Text('Done')),
          ],
          rowBuilder: (t, i) => [
            DataCell(Text('${i + 1}')),
            DataCell(Text(t.title)),
            DataCell(
              Checkbox(
                value: t.done,
                onChanged: (v) => ctrl.change(t.copyWith(done: v!)),
              ),
            ),
          ],
          onEdit: (t) => taskForm(context, task: t),
          onDelete: (t) => confirmDelete<Task>(
            title: t.title,
            onConfirm: () async => await ctrl.remove(t.id!),
          ),
        );
      }),
      button: IconButton(
        onPressed: () => taskForm(context),
        icon: Icon(Icons.create_new_folder_rounded),
        autofocus: true,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
