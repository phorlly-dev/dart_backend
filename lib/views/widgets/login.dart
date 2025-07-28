import 'package:dart_backend/controllers/auth_controller.dart';
import 'package:dart_backend/models/login_request.dart';
import 'package:dart_backend/utils/toastification.dart';
import 'package:dart_backend/views/screens/params.dart';
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
    // 1️⃣ Validate form
    if (!_formKey.currentState!.validate()) return;

    // 2️⃣ Prepare request
    final email = _email.text.trim();
    final password = _password.text;
    final req = LoginRequest(email: email, password: password);

    try {
      // 3️⃣ Attempt login
      final me = await _controller.login(req, _rememberMe);

      // 4️⃣ **After** login, read the updated state
      final err = _controller.errorMessage.value;
      final user = _controller.currentUser.value;

      if (!context.mounted) return;

      // 5️⃣ Branch on success vs. failure
      if (user == null || me == null) {
        // Login failed
        showToast(
          context,
          type: Toast.error,
          title: 'Login Failed!',
          message: err.isNotEmpty ? err : 'Unknown error',
        );
        _password.clear();
        debugPrint('Login errors: $err');
      } else {
        Get.offAllNamed('/app-shell', arguments: Params(info: user));

        // Login succeeded
        showToast(
          context,
          autoClose: 5,
          title: 'Welcome!',
          message: 'You have successfully logged in.',
        );

        _formKey.currentState!.reset();
      }
    } catch (e) {
      debugPrint('Login exception: $e');
      showToast(
        context,
        type: Toast.error,
        title: 'Error',
        message: 'Something went wrong. Please try again.',
      );
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
        ElevatedButton.icon(
          // 1) disable while loading
          onPressed: () => _submit(context),
          icon: const Icon(Icons.login_rounded),
          label: const Text("Log In"),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
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
        (v != null && v.contains('@')) ? null : 'Enter a valid email',
  );

  Widget _passwordField() => InputForm(
    controller: _password,
    label: 'Password',
    icon: Icons.lock,
    validator: (v) => (v != null && v.length >= 6) ? null : 'Min 6 characters',
    obscureText: _passwordVisible,
    visibleText: () => setState(() => _passwordVisible = !_passwordVisible),
  );
}
