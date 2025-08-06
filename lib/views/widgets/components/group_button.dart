import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class GroupButton extends StatefulWidget {
  final VoidCallback? onEdit, onDelete;

  const GroupButton({super.key, this.onEdit, this.onDelete});

  @override
  State<GroupButton> createState() => _GroupButtonState();
}

class _GroupButtonState extends State<GroupButton> {
  String? _selected;

  // will hold 'edit' or 'delete'
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        value: _selected,
        customButton: const Icon(Icons.more_vert_outlined),
        items: [
          if (widget.onEdit != null)
            DropdownMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_document, color: colors.primary),
                  const SizedBox(width: 8),
                  const Text('Edit'),
                ],
              ),
            ),
          if (widget.onDelete != null)
            DropdownMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: colors.error),
                  const SizedBox(width: 8),
                  const Text('Delete'),
                ],
              ),
            ),
        ],
        onChanged: (choice) {
          // call the callback _after_ the dropdown closes
          Future.microtask(() {
            if (choice == 'edit') widget.onEdit?.call();
            if (choice == 'delete') widget.onDelete?.call();
          });
          setState(() {
            _selected = null; // clear selection so next open shows hint
          });
        },
        hint: const SizedBox.shrink(), // or some Icon/Text
        dropdownStyleData: DropdownStyleData(
          width: 120,
          elevation: 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
