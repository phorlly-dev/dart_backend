import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputFormBuilder extends StatelessWidget {
  final String? label, initVal;
  final String name;
  final IconData? icon;
  final int? maxLines;
  final double? width;
  final Color? iconColor, textColor, borderColor;
  final String? Function(String?)? validator;
  final bool autofocus, enabled, obscureText, isBorderd;
  final TextInputType? inputType;
  final Widget? startedIcon, endedIcon;
  final FocusNode? focus;
  final AutovalidateMode? autovalidate;

  const InputFormBuilder({
    super.key,
    this.width = 1,
    this.label,
    this.icon,
    this.iconColor,
    this.textColor,
    this.borderColor,
    this.validator,
    this.autofocus = false,
    this.enabled = true,
    this.obscureText = false,
    this.maxLines,
    this.inputType,
    this.startedIcon,
    this.endedIcon,
    required this.name,
    this.initVal,
    this.isBorderd = false,
    this.focus,
    this.autovalidate = AutovalidateMode.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width?.sw,
      child: FormBuilderTextField(
        initialValue: initVal,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: startedIcon,
          suffixIcon: endedIcon,
          border: isBorderd
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                )
              : null,
          labelText: label,
        ),
        validator: validator,
        autofocus: autofocus,
        autovalidateMode: autovalidate,
        enabled: enabled,
        maxLines: maxLines,
        keyboardType: inputType,
        focusNode: focus,
        name: name,
      ),
    );
  }
}
