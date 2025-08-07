import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputBuilder extends StatelessWidget {
  final String? label, initVal;
  final String name;
  final int? maxLines;
  final double? width;
  final Color? iconColor, textColor, borderColor;
  final String? Function(String?)? validator;
  final bool autofocus, enabled, obscureText, isBorderd;
  final TextInputType? inputType;
  final Widget? startedIcon, endedIcon;
  final FocusNode? focus;
  final AutovalidateMode? autovalidate;
  final Function(String? val)? formatVal;

  const InputBuilder({
    super.key,
    this.width = 1,
    this.label,
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
    this.formatVal,
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
                  borderSide: BorderSide(color: Colors.white),
                )
              : null,
          labelText: 'Enter $label',
        ),
        validator: validator,
        autofocus: autofocus,
        autovalidateMode: autovalidate,
        enabled: enabled,
        maxLines: maxLines,
        keyboardType: inputType,
        focusNode: focus,
        name: name,
        valueTransformer: formatVal,
      ),
    );
  }
}
