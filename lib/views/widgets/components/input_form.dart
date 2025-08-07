import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputForm extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String name;
  final IconData? icon;
  final Color? iconColor, textColor, borderColor;
  final String? Function(String?)? validator;
  final bool autofocus, readOnly, obscureText;
  final int? maxLines;
  final TextInputType? inputType;
  final VoidCallback? visibleText;
  final double? width;
  final ValueChanged<String>? onChanged;
  final String Function(String? val)? trimVal;

  const InputForm({
    super.key,
    this.controller,
    this.label,
    this.icon,
    this.validator,
    this.iconColor,
    this.textColor,
    this.borderColor,
    this.autofocus = false,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.inputType = TextInputType.text,
    this.visibleText,
    this.width = .8,
    this.onChanged,
    required this.name,
    this.trimVal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: width?.sw,
      child: FormBuilderTextField(
        controller: controller,
        obscureText: obscureText,
        obscuringCharacter: '*',
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: textColor ?? Colors.white70),
          prefixIcon: Icon(icon, color: iconColor ?? Colors.white70),
          suffixIcon: visibleText != null
              ? IconButton(
                  color: iconColor ?? Colors.white70,
                  onPressed: visibleText,
                  icon: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  iconSize: 18,
                )
              : null,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: borderColor ?? Colors.white54),
          ),
        ),
        validator: validator,
        autofocus: autofocus,
        readOnly: readOnly,
        valueTransformer: trimVal,
        maxLines: maxLines,
        keyboardType: inputType,
        name: name,
      ),
    );
  }
}
