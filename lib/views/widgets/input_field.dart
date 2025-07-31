import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputField extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final int? maxLines;
  final double? width;
  final TextEditingController? controller;
  final Color? iconColor, textColor, borderColor;
  final String? Function(String?)? validator;
  final bool autofocus, readOnly, obscureText;
  final TextInputType? inputType;
  final ValueChanged<String>? onChanged;
  final Widget? startedIcon, endedIcon;

  const InputField({
    super.key,
    this.width = 1,
    this.label,
    this.controller,
    this.icon,
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
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width?.sw,
      // height: 66.w,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: startedIcon,
          suffixIcon: endedIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          labelText: 'Enter your ${label!.toLowerCase()}',
        ),
        validator: validator,
        autofocus: autofocus,
        readOnly: readOnly,
        maxLines: maxLines,
        keyboardType: inputType,
      ),
    );
  }
}
