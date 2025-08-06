import 'package:dart_backend/controllers/event_controller.dart';
import 'package:dart_backend/models/event_response.dart';
import 'package:dart_backend/utils/index.dart';
import 'package:dart_backend/views/widgets/ui/app_entire.dart';
import 'package:dart_backend/views/widgets/ui/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    _ctrl = Get.find();

    // trigger the load *after* initState, but before first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ctrl.show(_id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final event = _ctrl.currentEvent.value;
      final err = _ctrl.errorMessage.value;
      if (err.isNotEmpty) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(err),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _ctrl.show(_id),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      } else if (event == null) {
        return Scaffold(
          body: Center(child: const Text('Not found event!')),
        );
      }

      // parse & format
      final date = dateStr(strDate(event.eventDate));
      final start = timeStr(event.startTime);
      final end = timeStr(event.endTime);
      final remind = '${event.remindMin} minutes early';

      return AppEntire(
        header: NavBar(
          title: 'Event Detail',
          isBack: true,
        ),
        content: SingleChildScrollView(
          padding: const EdgeInsets.all(32).h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                'Title',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(event.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),

              // Date / Start / End
              _buildDetailRow(Icons.calendar_today, 'Date', date),
              _buildDetailRow(Icons.access_time, 'Start', start),
              _buildDetailRow(Icons.access_time, 'End', end),
              const SizedBox(height: 16),

              // Remind / Repeat / Status
              _buildDetailRow(Icons.alarm, 'Remind', remind),
              _buildDetailRow(Icons.repeat, 'Repeat', event.repeatRule.label),
              _buildDetailRow(Icons.flag, 'Status', event.status.label),
              const SizedBox(height: 16),

              // Note
              if ((event.note ?? '').isNotEmpty) ...[
                const Text(
                  'Note',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(event.note!),
                const SizedBox(height: 16),
              ],

              // Color swatch
              const Text(
                'Color',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: event.color,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey.shade300),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  /// Helper to render a single icon + label + value row
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
