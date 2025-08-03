import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionButton extends StatelessWidget {
  final String? labelBtn;
  final Color? colorBtn;
  final IconData? iconBtn;
  final double? widthBtn, radiusBtn, textSize, iconSize;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    this.labelBtn,
    this.colorBtn,
    this.iconBtn,
    this.widthBtn, // largest 1
    this.radiusBtn,
    required this.onPressed,
    this.textSize,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widthBtn?.sw,
      child: TextButton.icon(
        label: Text(
          labelBtn ?? 'Save',
          style: TextStyle(fontSize: textSize),
        ),
        onPressed: onPressed,
        icon: Icon(iconBtn ?? Icons.save, size: iconSize),
        autofocus: true,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorBtn ?? Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusBtn ?? 12),
          ),
        ),
      ),
    );
  }
}
