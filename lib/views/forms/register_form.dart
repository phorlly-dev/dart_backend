import 'package:dart_backend/models/user_response.dart';
import 'package:dart_backend/views/widgets/components/auth_form.dart';
import 'package:dart_backend/views/widgets/components/input_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class RegisterForm extends StatefulWidget {
  final Future<void> Function(UserResponse req) onSubmit;

  const RegisterForm({super.key, required this.onSubmit});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool _visPass = true;
  bool _visConPass = true;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return AuthForm(
      formKey: _formKey,
      label: "Register",
      icon: Icons.app_registration_rounded,
      color: Theme.of(context).colorScheme.outlineVariant,
      children: [
        InputForm(
          name: 'name',
          label: 'Full Name',
          icon: Icons.person,
          trimVal: (val) => val!.trim(),
          autofocus: true,
          validator: (val) {
            if (val == null || val.isEmpty) return 'Name is required';
            if (val.length < 2) return 'Must be at least 2 characters';
            return null;
          },
        ),
        InputForm(
          name: 'email',
          label: 'Email Address',
          icon: Icons.mail,
          trimVal: (val) => val!.trim(),
          inputType: TextInputType.emailAddress,
          validator: (val) {
            if (val == null || val.isEmpty) return 'Email is required';

            final emailRE = RegExp(r'^[^@]+@[^@]+\.[^@]+');
            if (!emailRE.hasMatch(val)) return 'Enter a valid email';

            return null;
          },
        ),
        InputForm(
          name: 'password',
          label: 'Password',
          icon: Icons.lock,
          inputType: TextInputType.visiblePassword,
          validator: (val) {
            if (val == null || val.isEmpty) return 'Password is required';
            if (val.length < 6) return 'Must be at least 6 characters';
            return null;
          },
          obscureText: _visPass,
          visibleText: () => setState(() => _visPass = !_visPass),
        ),
        InputForm(
          name: 'confirm_password',
          label: 'Confirm Password',
          inputType: TextInputType.visiblePassword,
          icon: Icons.lock,
          validator: (val) {
            // grab the password field’s current value
            final pwd = _formKey.currentState?.fields['password']?.value;
            if (val != pwd) {
              return 'Passwords do not match';
            }
            return null;
          },
          obscureText: _visConPass,
          visibleText: () => setState(() => _visConPass = !_visConPass),
        ),
        const SizedBox(height: 28),
      ],
      onSubmit: () async {
        final formState = _formKey.currentState;
        if (formState?.saveAndValidate() ?? false) {
          // Build the model here
          final req = UserResponse.fromJson(formState!.value);

          // And hand it off to the parent
          await widget.onSubmit(req);
          _formKey.currentState!.reset();
        }
      },
    );
  }
}
