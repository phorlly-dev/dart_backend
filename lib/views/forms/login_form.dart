import 'package:dart_backend/controllers/auth_controller.dart';
import 'package:dart_backend/models/login_response.dart';
import 'package:dart_backend/utils/index.dart';
import 'package:dart_backend/views/functions/toastification.dart';
import 'package:dart_backend/views/widgets/components/auth_form.dart';
import 'package:dart_backend/views/widgets/components/chackbox_builder.dart';
import 'package:dart_backend/views/widgets/components/input_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class LoginForm extends StatefulWidget {
  final AuthController controller;

  const LoginForm({super.key, required this.controller});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final AuthController _controller;
  bool _visPass = true;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return AuthForm(
      formKey: _formKey,
      children: [
        InputForm(
          name: 'email',
          label: 'Email Address',
          icon: Icons.mail,
          trimVal: (val) => val!.trim(),
          inputType: TextInputType.emailAddress,
          autofocus: true,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Email is required';

            final emailRE = RegExp(r'^[^@]+@[^@]+\.[^@]+');
            if (!emailRE.hasMatch(v)) return 'Enter a valid email';

            return null;
          },
        ),
        InputForm(
          name: 'password',
          label: 'Password',
          icon: Icons.lock,
          inputType: TextInputType.visiblePassword,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Password is required';
            if (v.length < 6) return 'Must be at least 6 characters';
            return null;
          },
          obscureText: _visPass,
          visibleText: () => setState(() => _visPass = !_visPass),
        ),
        ChackboxBuilder(
          name: 'remember',
          label: 'Remember me',
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
      ],
      onSubmit: () async {
        final formState = _formKey.currentState;
        if (formState?.saveAndValidate() ?? false) {
          final err = _controller.errorMessage.value;
          final me = _controller.currentUser.value;

          final req = LoginResponse.fromJson(formState!.value);
          await _controller.login(req);

          if (!context.mounted) return;
          if (me == null && err.isNotEmpty) {
            showToast(
              context,
              type: Toast.error,
              title: 'Authentication error!',
              message: err,
            );
            debugPrint(err);
          } else {
            Get.offAllNamed('/app-shell', arguments: UserParams(state: me));
            showToast(
              context,
              title: 'Welcome!',
              message: 'You have successfully logged in.',
            );
            _formKey.currentState!.reset();
          }
        }
      },
    );
  }
}
