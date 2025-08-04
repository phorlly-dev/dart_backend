import 'package:dart_backend/models/user.dart';
import 'package:dart_backend/views/widgets/app_entire.dart';
import 'package:dart_backend/views/widgets/nav_bar.dart';
import 'package:dart_backend/views/partials/schedule.dart';
import 'package:dart_backend/views/widgets/side_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final User? user;

  const HomeScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    // final TaskController ctrl = Get.find();

    return AppEntire(
      header: NavBar(title: "Welcome"),
      menu: SideBar(
        name: user?.name,
        email: user?.email,
        createdAt: user?.createdAt,
      ),
      content: Schedule(),

      //  Obx(() {
      //   return PaginatedTableView<Task>(
      //     title: 'Task Management',
      //     items: ctrl.tasks,
      //     isLoading: ctrl.isLoading.value,
      //     hasError: ctrl.errorMessage.value,
      //     isSelected: (value) => value.done,
      //     columns: [
      //       DataColumn(label: Text('Id')),
      //       DataColumn(label: Text('Title')),
      //       DataColumn(label: Text('Done')),
      //     ],
      //     sorters: [
      //       // pull out the fields directly from your model
      //       (t) => t.id ?? 0,
      //       (t) => t.title.toLowerCase(),
      //       (t) => t.done ? 1 : 0,
      //     ],
      //     rowBuilder: (item, idx) => [
      //       DataCell(Text('${idx + 1}')),
      //       DataCell(Text(item.title)),
      //       DataCell(
      //         Checkbox(
      //           value: item.done,
      //           onChanged: (v) async =>
      //               await ctrl.change(item.copyWith(done: v!)),
      //         ),
      //       ),
      //     ],
      //     onEdit: (v) => taskForm(context, task: v),
      //     onDelete: (v) => confirmDelete<Task>(
      //       title: v.title,
      //       onConfirm: () async => await ctrl.remove(v.id!),
      //     ),
      //   );
      // }),
      // button: IconButton(
      //   onPressed: () => taskForm(context),
      //   icon: Icon(Icons.create_new_folder_rounded),
      //   autofocus: true,
      //   color: Theme.of(context).colorScheme.primary,
      // ),
    );
  }
}
