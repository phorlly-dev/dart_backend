import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ChackboxBuilder extends StatelessWidget {
  final String name, label;
  final bool? initVal;
  final bool enabled;
  final Color? color;
  final Function(bool? val)? formatVal;

  const ChackboxBuilder({
    super.key,
    required this.name,
    required this.label,
    this.initVal,
    this.enabled = true,
    this.color,
    this.formatVal,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderCheckbox(
      initialValue: initVal,
      enabled: enabled,
      name: name,
      valueTransformer: formatVal,
      title: Text(
        label,
        style: TextStyle(color: color ?? Colors.white),
      ),
    );
  }
}
