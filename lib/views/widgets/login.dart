import 'package:dart_backend/controllers/auth_controller.dart';
import 'package:dart_backend/models/login_request.dart';
import 'package:dart_backend/utils/toastification.dart';
import 'package:dart_backend/views/widgets/auth_form.dart';
import 'package:dart_backend/views/widgets/input_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginForm extends StatefulWidget {
  final AuthController controller;

  const LoginForm({super.key, required this.controller});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final AuthController _controller;
  bool _rememberMe = false;
  bool _passwordVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final email = _email.text.trim();
    final password = _password.text;
    final req = LoginRequest(email: email, password: password);

    await _controller.login(req, _rememberMe);
    if (_controller.errorMessage.value.isNotEmpty && context.mounted) {
      showToast(
        context,
        type: Toast.error,
        title: 'Login Failed!',
        message: _controller.errorMessage.value,
      );
      debugPrint('Errors: ${_controller.errorMessage.value}');
    } else {
      Get.offAllNamed('/app-shell');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthForm(
      formKey: _formKey,
      children: [
        _emailField(),
        _passwordField(),
        CheckboxListTile(
          value: _rememberMe,
          checkColor: Colors.white,
          onChanged: (v) => setState(() => _rememberMe = v!),
          title: const Text(
            'Remember me',
            style: TextStyle(color: Colors.white),
          ),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                color: Colors.white70,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Obx(
          () => ElevatedButton(
            onPressed: () => _submit(context),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            child: _controller.isLoading.value
                ? const CircularProgressIndicator()
                : const Text('Log In'),
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
    autofocus: true,
    validator: (v) =>
        (v?.contains('@') ?? false) ? null : 'Enter a valid email',
  );

  Widget _passwordField() => InputForm(
    controller: _password,
    label: 'Password',
    icon: Icons.lock,
    validator: (v) => (v?.length ?? 0) >= 6 ? null : 'Min 6 characters',
    obscureText: _passwordVisible,
    visibleText: () => setState(() => _passwordVisible = !_passwordVisible),
  );
}
