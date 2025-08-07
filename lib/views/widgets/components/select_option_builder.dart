import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectOptionBuilder<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> options;
  final T? initVal;
  final String name;
  final String? label;
  final String? Function(T? val)? validator;
  final Function(T? val)? formatVal;
  final void Function(T? val)? onChanged;
  final bool enabled;
  final double? width;

  const SelectOptionBuilder({
    super.key,
    required this.options,
    required this.name,
    this.initVal,
    this.label,
    this.validator,
    this.onChanged,
    this.formatVal,
    this.enabled = true,
    this.width = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width?.sw,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: FormBuilderDropdown<T>(
        name: name,
        decoration: InputDecoration(
          labelText: 'Select $label',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        initialValue: initVal,
        items: options,
        validator: validator,
        onChanged: onChanged,
        valueTransformer: formatVal,
        enabled: enabled,
      ),
    );
  }
}
