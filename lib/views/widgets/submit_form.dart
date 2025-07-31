import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubmitForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> children;
  final VoidCallback? onPressed;
  final String? labelBtn;
  final Color? colorBtn;
  final IconData? iconBtn;

  const SubmitForm({
    super.key,
    required this.formKey,
    required this.children,
    this.onPressed,
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
                  TextButton.icon(
                    label: const Text('Back'),
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.arrow_back_ios_rounded),
                    autofocus: true,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.secondary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  TextButton.icon(
                    label: Text(labelBtn ?? 'Save'),
                    onPressed: onPressed,
                    icon: Icon(iconBtn ?? Icons.save),
                    autofocus: true,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorBtn ?? colors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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
