import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ColorPickerBuilder<T extends Color> extends StatelessWidget {
  final String name;
  final T? initVal;
  final String? label;
  final Function(Color? val)? formatVal;

  const ColorPickerBuilder({
    super.key,
    required this.name,
    this.initVal,
    this.label,
    this.formatVal,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<Color>(
      name: name,
      initialValue: initVal ?? Colors.green,
      valueTransformer: formatVal,
      builder: (field) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: label ?? 'Pick a color',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: ColorPicker(
            color: field.value!,
            onColorChanged: field.didChange,
          ),
        );
      },
    );
  }
}
