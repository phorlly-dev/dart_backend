import 'package:dart_backend/controllers/event_controller.dart';
import 'package:dart_backend/views/widgets/app_entire.dart';
import 'package:dart_backend/views/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late final int _id;
  late final EventController _ctrl;

  @override
  void initState() {
    super.initState();
    _id = Get.arguments as int;
    _ctrl = Get.find<EventController>();

    // trigger the load *after* initState, but before first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ctrl.show(_id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_ctrl.isLoading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      if (_ctrl.errorMessage.value.isNotEmpty) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_ctrl.errorMessage.value),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _ctrl.show(_id),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }

      final event = _ctrl.currentEvent.value;
      if (event == null) {
        return const Scaffold(
          body: Center(child: Text('Event not found')),
        );
      }

      return AppEntire(
        header: NavBar(title: 'Event Detail'),
        content: Column(children: [
          Text('Title: ${event.title}'),
          Text('Note:  ${event.note ?? '-'}'),
          // …etc…
        ]),
      );
    });
  }
}
