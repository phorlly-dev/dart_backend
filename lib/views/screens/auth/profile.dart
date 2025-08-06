import 'package:dart_backend/controllers/user_controller.dart';
import 'package:dart_backend/models/user_response.dart';
import 'package:dart_backend/utils/index.dart';
import 'package:dart_backend/views/forms/profile_form.dart';
import 'package:dart_backend/views/widgets/ui/app_entire.dart';
import 'package:dart_backend/views/widgets/ui/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1️⃣ Retrieve the EventParams
    final params = Get.arguments as UserParams;

    // 2️⃣ Unpack them
    final UserResponse model = params.state!;
    final UserController controller = params.payload!;

    return AppEntire(
      header: NavBar(title: 'My Profile', isBack: true),
      content: ProfileForm(controller: controller, model: model),
    );
  }
}
