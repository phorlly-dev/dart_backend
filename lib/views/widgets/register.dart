import 'package:dart_backend/controllers/auth_controller.dart';
import 'package:dart_backend/models/user.dart';
import 'package:dart_backend/utils/toastification.dart';
import 'package:dart_backend/views/widgets/auth_form.dart';
import 'package:dart_backend/views/widgets/input_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterForm extends StatefulWidget {
  final AuthController controller;

  const RegisterForm({super.key, required this.controller});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _email;
  late final TextEditingController _name;
  late final TextEditingController _password;
  late final TextEditingController _confirm;
  late final AuthController _controller;

  bool _visPass = true;
  bool _visConPass = true;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
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

  void _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final email = _email.text.trim();
    final name = _name.text.trim();
    final password = _password.text;
    final req = User(name: name, email: email, password: password, role: true);

    await _controller.register(req);
    if (context.mounted) {
      if (_controller.errorMessage.value.isNotEmpty) {
        showToast(
          context,
          type: Toast.error,
          title: 'Register Failed!',
          message: _controller.errorMessage.value,
        );
        debugPrint('Errors: ${_controller.errorMessage.value}');
      } else {
        final tabController = DefaultTabController.of(context);
        if (tabController.index != 0) {
          tabController.animateTo(0);
          showToast(
            context,
            title: 'Registration successful!',
            message: 'Please log in.',
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthForm(
      formKey: _formKey,
      children: [
        _nameField(),
        _emailField(),
        _passwordField(),
        _confirmPasswordField(),
        const SizedBox(height: 28),
        Obx(
          () => ElevatedButton(
            onPressed: () => _submit(context),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            child: _controller.isLoading.value
                ? const CircularProgressIndicator()
                : const Text('Register'),
          ),
        ),
        const SizedBox(height: 24),
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
    validator: (v) => (v?.length ?? 0) == 0 ? 'The full name is requied' : null,
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
