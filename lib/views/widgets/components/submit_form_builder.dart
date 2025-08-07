import 'package:dart_backend/views/widgets/components/action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SubmitFormBuilder extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final List<Widget> children;
  final VoidCallback onSubmit;
  final String? labelBtn;
  final Color? colorBtn;
  final IconData? iconBtn;
  final double? widthBtn, hieghtBtn;
  final Map<String, dynamic> initVal;

  const SubmitFormBuilder({
    super.key,
    required this.formKey,
    required this.children,
    required this.onSubmit,
    this.labelBtn,
    this.colorBtn,
    this.iconBtn,
    this.widthBtn,
    this.initVal = const <String, dynamic>{},
    this.hieghtBtn,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: FormBuilder(
        initialValue: initVal,
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          spacing: 16,
          children: [
            ...children,
            const SizedBox(height: 24),
            ActionButton(
              label: labelBtn,
              icon: iconBtn,
              color: colorBtn,
              onSubmit: onSubmit,
              width: widthBtn ?? 280,
              hieght: hieghtBtn ?? 40,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
