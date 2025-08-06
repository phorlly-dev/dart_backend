
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


      // ====================================
           // return DataTableView<Task>(
        //   items: ctrl.tasks,
        //   isLoading: ctrl.isLoading.value,
        //   hasError: ctrl.errorMessage.value,
        //   notFound: ctrl.tasks,
        //   isSelected: (t) => t.done,
        //   columns: const [
        //     DataColumn(label: Text('Id')),
        //     DataColumn(label: Text('Title')),
        //     DataColumn(label: Text('Done')),
        //   ],
        //   rowBuilder: (t, i) => [
        //     DataCell(Text('${i + 1}')),
        //     DataCell(Text(t.title)),
        //     DataCell(
        //       Checkbox(
        //         value: t.done,
        //         onChanged: (v) => ctrl.change(t.copyWith(done: v!)),
        //       ),
        //     ),
        //   ],
        //   onEdit: (t) => taskForm(context, task: t),
        //   onDelete: (t) => confirmDelete<Task>(
        //     title: t.title,
        //     onConfirm: () async => await ctrl.remove(t.id!),
        //   ),
        // );