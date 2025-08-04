import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectOption<T> extends StatelessWidget {
  final double? width;
  final List<DropdownMenuItem<T>>? options;
  final void Function(T? value)? onChanged, onSaved;
  final String? Function(T? value)? validator;
  final String? hint, label;

  const SelectOption({
    super.key,
    this.width = 1,
    this.options,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.hint,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width?.sw,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField2<T>(
        isExpanded: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          labelText: label,
        ),
        hint: Text(
          hint ?? '',
          style: TextStyle(fontSize: 14),
        ),
        items: options,
        validator: validator,
        onChanged: onChanged,
        onSaved: onSaved,
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.only(right: 8),
        ),
        iconStyleData: IconStyleData(
          icon: Icon(
            Icons.arrow_drop_down,
            color: Theme.of(context).colorScheme.secondary,
          ),
          iconSize: 24,
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
