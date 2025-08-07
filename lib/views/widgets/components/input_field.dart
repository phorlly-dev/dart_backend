import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputField extends StatelessWidget {
  final String? label, name;
  final int? maxLines;
  final double? width;
  final TextEditingController? controller;
  final Color? iconColor, textColor, borderColor;
  final String? Function(String?)? validator;
  final bool autofocus, readOnly, obscureText, expands;
  final TextInputType? inputType;
  final ValueChanged<String>? onChanged;
  final Widget? startedIcon, endedIcon;
  final FormFieldSetter<String>? onSaved;

  const InputField({
    super.key,
    this.width = 1,
    this.label,
    this.controller,
    this.iconColor,
    this.textColor,
    this.borderColor,
    this.validator,
    this.autofocus = false,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLines,
    this.inputType,
    this.onChanged,
    this.startedIcon,
    this.endedIcon,
    this.expands = false,
    this.name,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width?.sw,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        initialValue: name,
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: startedIcon,
          suffixIcon: endedIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          labelText: 'Enter ${label!.toLowerCase()}',
        ),
        validator: validator,
        onSaved: onSaved,
        autofocus: autofocus,
        readOnly: readOnly,
        maxLines: maxLines,
        keyboardType: inputType,
        expands: expands,
      ),
    );
  }
}
