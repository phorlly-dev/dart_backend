import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionButton extends StatelessWidget {
  final String? label;
  final Color? color;
  final IconData? icon;
  final double? borderRadius, textSize, iconSize;
  final VoidCallback onSubmit;
  final double width, hieght;

  const ActionButton({
    super.key,
    this.textSize,
    this.iconSize,
    this.label,
    this.color,
    this.icon,
    this.width = 240,
    this.borderRadius,
    required this.onSubmit,
    this.hieght = 40,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      label: Text(
        label ?? 'Save',
        style: TextStyle(fontSize: textSize),
      ),
      onPressed: onSubmit,
      icon: Icon(icon ?? Icons.save, size: iconSize),
      autofocus: true,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        minimumSize: Size(width.w, hieght.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
        ),
      ),
    );
  }
}
