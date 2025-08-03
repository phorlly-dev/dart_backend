import 'package:dart_backend/models/user.dart';
import 'package:dart_backend/views/widgets/auth_form.dart';
import 'package:dart_backend/views/widgets/input_form.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  final Future<void> Function(User req) onSubmit;

  const RegisterForm({super.key, required this.onSubmit});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _email;
  late final TextEditingController _name;
  late final TextEditingController _password;
  late final TextEditingController _confirm;

  bool _visPass = true;
  bool _visConPass = true;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
    _confirm = TextEditingController();
    _name = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthForm(
      formKey: _formKey,
      label: "Register",
      icon: Icons.app_registration_rounded,
      onPressed: () {
        if (!_formKey.currentState!.validate()) return;

        // Build the request
        final name = _name.text.trim();
        final email = _email.text.trim();
        final password = _password.text;

        // Build the model here
        final req = User(
          name: name,
          email: email,
          password: password,
          role: false,
        );

        // And hand it off to the parent
        widget.onSubmit(req);
        _formKey.currentState!.reset();
      },
      children: [
        _nameField(),
        _emailField(),
        _passwordField(),
        _confirmPasswordField(),
        const SizedBox(height: 28),
      ],
    );
  }

  Widget _emailField() => InputForm(
        controller: _email,
        label: 'Email',
        icon: Icons.mail,
        inputType: TextInputType.emailAddress,
        validator: (v) =>
            (v?.contains('@') ?? false) ? null : 'Enter a valid email',
      );

  Widget _nameField() => InputForm(
        controller: _name,
        label: 'Full Name',
        icon: Icons.person,
        autofocus: true,
        validator: (v) => (v?.isNotEmpty ?? false) ? null : 'Required',
      );

  Widget _passwordField() => InputForm(
        controller: _password,
        label: 'Password',
        icon: Icons.lock,
        validator: (v) => (v?.length ?? 0) >= 6 ? null : 'Min 6 characters',
        obscureText: _visPass,
        visibleText: () => setState(() => _visPass = !_visPass),
      );

  Widget _confirmPasswordField() => InputForm(
        controller: _confirm,
        label: 'Confirm Password',
        icon: Icons.lock_outline,
        validator: (v) => v == _password.text ? null : 'Passwords do not match',
        obscureText: _visConPass,
        visibleText: () => setState(() => _visConPass = !_visConPass),
      );
}
