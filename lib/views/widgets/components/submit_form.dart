import 'package:dart_backend/views/widgets/components/action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubmitForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> children;
  final VoidCallback onPressed;
  final String? labelBtn;
  final Color? colorBtn;
  final IconData? iconBtn;
  final double widthBtn;

  const SubmitForm({
    super.key,
    required this.formKey,
    required this.children,
    required this.onPressed,
    this.labelBtn,
    this.colorBtn,
    this.iconBtn,
    this.widthBtn = .6,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 12, right: 12),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              ...children,
              const SizedBox(height: 24),
              ActionButton(
                label: labelBtn,
                icon: iconBtn,
                color: colorBtn,
                onSubmit: onPressed,
                width: widthBtn.w,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
