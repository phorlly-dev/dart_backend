import 'package:dart_backend/views/widgets/components/action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubmitFormBuilder extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final List<Widget> children;
  final VoidCallback onSubmit;
  final String? labelBtn;
  final Color? colorBtn;
  final IconData? iconBtn;
  final double widthBtn;
  final Map<String, dynamic> initValue;

  const SubmitFormBuilder({
    super.key,
    required this.formKey,
    required this.children,
    required this.onSubmit,
    this.labelBtn,
    this.colorBtn,
    this.iconBtn,
    this.widthBtn = .6,
    this.initValue = const <String, dynamic>{},
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: FormBuilder(
          initialValue: initValue,
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            spacing: 16,
            children: [
              ...children,
              const SizedBox(height: 24),
              ActionButton(
                label: labelBtn ?? 'Save',
                icon: iconBtn ?? Icons.save,
                color: colorBtn ?? Theme.of(context).colorScheme.primary,
                onSubmit: onSubmit,
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

// class SubmitFormBuilder extends StatefulWidget {
//   const SubmitFormBuilder({super.key});

//   @override
//   State<SubmitFormBuilder> createState() => _SubmitFormBuilderState();
// }

// class _SubmitFormBuilderState extends State<SubmitFormBuilder> {
//   final _fbKey = GlobalKey<FormBuilderState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Form Builder'),
//       ),
//       body: Container(
//         margin: EdgeInsets.symmetric(horizontal: 24),
//         child: FormBuilder(
//           key: _fbKey,
//           child: Column(
//             children: [
//               FormBuilderTextField(
//                 name: 'name',
//                 decoration: const InputDecoration(labelText: 'Email'),
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 child: const Text('Submit'),
//                 onPressed: () {
//                   final formState = _fbKey.currentState!;
//                   if (formState.saveAndValidate()) {
//                     // 1. get form values
//                     final data = formState.value;
//                     print(data);
//                     formState.reset();

//                     // 🔥 call your controller/repo here...
//                   } else {
//                     // validation failed
//                     print('Validation failed');
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
