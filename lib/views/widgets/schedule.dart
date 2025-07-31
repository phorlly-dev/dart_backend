import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:dart_backend/views/forms/event_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  late DateTime _selectedDate;
  late List<DateTime> _eventDates;

  @override
  void initState() {
    super.initState();
    _resetSelectedDate();
  }

  void _resetSelectedDate() {
    _selectedDate = DateTime.now();
    _eventDates = [
      DateTime.now().add(const Duration(days: 2)),
      DateTime.now().add(const Duration(days: 3)),
      DateTime.now().add(const Duration(days: 4)),
      DateTime.now().subtract(const Duration(days: 4)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                label: const Text('Today'),
                onPressed: () => setState(() => _resetSelectedDate()),
                icon: Icon(Icons.today),
                autofocus: true,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              ElevatedButton.icon(
                label: const Text('Add Task'),
                onPressed: () =>
                    Get.to(() => EventForm(), fullscreenDialog: true),
                icon: Icon(Icons.add_circle),
                autofocus: true,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.inversePrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 8, bottom: 8),
          child: CalendarTimeline(
            showYears: true,
            initialDate: _selectedDate,
            firstDate: DateTime(2000),
            lastDate: DateTime.now().add(const Duration(days: 365 * 50)),
            eventDates: _eventDates,
            onDateSelected: (date) => setState(() => _selectedDate = date),
            leftMargin: 12,
            monthColor: colors.outline,
            dayColor: Colors.teal[200],
            dayNameColor: const Color(0xFF333A47),
            activeDayColor: Colors.white,
            activeBackgroundDayColor: Colors.redAccent[100],
            dotColor: Colors.white,
            // selectableDayPredicate: (date) => date.day != 23,
            // locale: 'km',
          ),
        ),
      ],
    );
  }
}
