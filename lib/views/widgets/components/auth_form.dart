import 'package:dart_backend/views/widgets/components/action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AuthForm extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final List<Widget> children;
  final VoidCallback onSubmit;
  final String? label;
  final IconData? icon;
  final Color? color;

  const AuthForm({
    super.key,
    required this.formKey,
    required this.children,
    required this.onSubmit,
    this.label,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24),
        ),
        child: FormBuilder(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...children,
              ActionButton(
                onSubmit: onSubmit,
                icon: icon ?? Icons.login_rounded,
                label: label ?? "Log In",
                color: color,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
