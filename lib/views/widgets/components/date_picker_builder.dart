import 'package:dart_backend/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DatePickerBuilder extends StatelessWidget {
  final DateTime? initVal;
  final String? format, label;
  final String name;
  final double? width;
  final bool isBorderd, enabled;
  final String? Function(DateTime?)? validator;
  final void Function(DateTime?)? onChanged;

  const DatePickerBuilder({
    super.key,
    this.initVal,
    this.format,
    required this.name,
    this.isBorderd = false,
    this.label,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.width = 1,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width?.sw,
      child: FormBuilderDateTimePicker(
        name: name,
        initialValue: initVal ?? dtNow(),
        inputType: InputType.date,
        format: DateFormat(format ?? 'd MMMM yyyy'),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(Icons.date_range_rounded),
          border: isBorderd
              ? OutlineInputBorder(borderRadius: BorderRadius.circular(12))
              : null,
        ),
        validator: validator,
        onChanged: onChanged,
        valueTransformer: (value) => value?.toIso8601String(),
        enabled: enabled,
      ),
    );
  }
}
