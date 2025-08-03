import 'package:dart_backend/views/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubmitForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> children;
  final VoidCallback onPressed;
  final String? labelBtn;
  final Color? colorBtn;
  final IconData? iconBtn;

  const SubmitForm({
    super.key,
    required this.formKey,
    required this.children,
    required this.onPressed,
    this.labelBtn,
    this.colorBtn,
    this.iconBtn,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ActionButton(
                    labelBtn: 'Back',
                    iconBtn: Icons.arrow_back_ios_rounded,
                    colorBtn: colors.scrim,
                    onPressed: () => Get.back(),
                  ),
                  ActionButton(
                    labelBtn: labelBtn ?? 'Save',
                    iconBtn: iconBtn ?? Icons.save,
                    colorBtn: colorBtn ?? colors.primary,
                    onPressed: onPressed,
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
