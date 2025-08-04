import 'package:dart_backend/controllers/event_controller.dart';
import 'package:dart_backend/models/event.dart';
import 'package:dart_backend/utils/index.dart';
import 'package:dart_backend/views/forms/event_form.dart';
import 'package:dart_backend/views/widgets/app_entire.dart';
import 'package:dart_backend/views/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateEditEventScreen extends StatelessWidget {
  const CreateEditEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1️⃣ Retrieve the EventParams
    final params = Get.arguments as EventParams;

    // 2️⃣ Unpack them
    final Event? model = params.state;
    final EventController? controller = params.payload;

    return AppEntire(
      header: NavBar(title: model != null ? 'Edit Event' : "Add Event"),
      content: EventForm(controller: controller!, model: model),
    );
  }
}
