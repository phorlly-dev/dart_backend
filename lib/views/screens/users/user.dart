import 'package:dart_backend/controllers/user_controller.dart';
import 'package:dart_backend/models/user_response.dart';
import 'package:dart_backend/views/widgets/ui/app_entire.dart';
import 'package:dart_backend/views/widgets/ui/paginated_table_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserScreen extends StatelessWidget {
  final UserResponse? me;

  const UserScreen({super.key, this.me});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<UserController>();

    return AppEntire(
      content: ListView(
        children: [
          Obx(() {
            return PaginatedTableView<UserResponse>(
              title: 'Users Management',
              items: ctrl.states.where((usr) => usr.id != me!.id).toList(),
              isLoading: ctrl.isLoading.value,
              hasError: ctrl.errorMessage.value,
              isSelected: (value) => value.status,
              columns: [
                DataColumn(label: Text('Id')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Role')),
                DataColumn(label: Text('Status')),
              ],
              sorters: [
                // pull out the fields directly from your model
                (state) => state.id ?? 0,
                (state) => state.name,
                (state) => state.role ? 1 : 0,
                (state) => state.status ? 1 : 0,
              ],
              rowBuilder: (item, idx) => [
                DataCell(Text('${idx + 1}')),
                DataCell(Text(item.name)),
                DataCell(Text(item.role ? 'Admin' : 'User')),
                DataCell(Text(item.status ? 'Active' : 'Inactive')),
              ],
              onEdit: (v) {},
              onDelete: (v) {},
            );
          }),
        ],
      ),
    );
  }
}
