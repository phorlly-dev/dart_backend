import 'package:dart_backend/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class TimePickerBuilder extends StatelessWidget {
  final DateTime? initVal;
  final String? format, label;
  final String name;
  final double? width;
  final bool isBorderd, enabled;
  final String? Function(DateTime?)? validator;
  final void Function(DateTime?)? onChanged;

  const TimePickerBuilder({
    super.key,
    this.initVal,
    this.format,
    this.label,
    required this.name,
    this.isBorderd = false,
    this.enabled = true,
    this.validator,
    this.onChanged,
    this.width = 1,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width?.sw,
      child: FormBuilderDateTimePicker(
        name: name,
        initialValue: initVal ?? dtNow(),
        inputType: InputType.time,
        format: DateFormat(format ?? 'h:mm a'),
        timePickerInitialEntryMode: TimePickerEntryMode.dialOnly,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.access_time_rounded),
          labelText: label,
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
