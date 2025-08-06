import 'package:dart_backend/controllers/user_controller.dart';
import 'package:dart_backend/models/user_response.dart';
import 'package:dart_backend/utils/index.dart';
import 'package:dart_backend/views/widgets/components/input_form_builder.dart';
import 'package:dart_backend/views/widgets/components/submit_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ProfileForm extends StatelessWidget {
  final UserResponse model;
  final UserController controller;

  const ProfileForm({super.key, required this.model, required this.controller});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    final colors = Theme.of(context).colorScheme;

    return SubmitFormBuilder(
      formKey: formKey,
      onSubmit: () {},
      colorBtn: colors.secondary,
      iconBtn: Icons.update,
      initValue: model.toJson(),
      children: [
        InputFormBuilder(
          // isBorderd: true,
          name: 'name',
          label: 'Full Name',
        ),
        InputFormBuilder(
          // isBorderd: true,
          name: 'email',
          label: 'Email Address',
          enabled: false,
          inputType: TextInputType.emailAddress,
        ),
        InputFormBuilder(
          // isBorderd: true,
          name: 'phone',
          label: 'Phone Number',
        ),
        InputFormBuilder(
          name: 'phone',
          label: 'Phone Number',
          inputType: TextInputType.phone,
        ),
        InputFormBuilder(
          name: 'createdAt',
          label: 'Created At',
          enabled: false,
          initVal: dateStr(strDate(model.createdAt)),
          inputType: TextInputType.datetime,
        ),
        InputFormBuilder(
          initVal: dateStr(strDate(model.updatedAt)),
          name: 'updatedAt',
          label: 'Updated At',
          inputType: TextInputType.datetime,
          enabled: false,
        ),
      ],
    );
  }
}
