import 'dart:convert';

import 'package:dart_backend/services/event_request.dart';
import 'package:dart_backend/models/event_response.dart';
import 'package:dart_backend/utils/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;

class EventController extends GetxController {
  final _db = EventRequest();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<EventResponse> states = <EventResponse>[].obs;
  final Rxn<EventResponse> currentEvent = Rxn<EventResponse>();

  // filters:
  final selectedDate = DateTime.now().obs;
  final selectedRepeat = RepeatRule.none.obs;
  final selectedStatus = Status.pending.obs;

  // computed list after applying the three filters
  RxList<EventResponse> get filteredEvents => _filteredEvents;
  final RxList<EventResponse> _filteredEvents = <EventResponse>[].obs;

  @override
  void onInit() {
    super.onInit();

    // load everything once
    index();

    // whenever any of these change, re‐filter & re‐schedule notifications
    everAll([
      states,
      selectedDate,
      selectedRepeat,
      selectedStatus,
    ], (_) {
      _applyFilters();
      _scheduleNotifications();
    });
  }

  void _applyFilters() {
    final date = selectedDate.value;
    final rep = selectedRepeat.value;
    final stat = selectedStatus.value;

    final v = states.where((e) {
      final sameDay = e.eventDate;
      final matchesDate = DateTime(sameDay.year, sameDay.month, sameDay.day) ==
          DateTime(date.year, date.month, date.day);
      final matchesRepeat = (rep == RepeatRule.none) || e.repeatRule == rep;
      final matchesStatus = (stat == Status.pending) || e.status == stat;
      return matchesDate && matchesRepeat && matchesStatus;
    }).toList();

    _filteredEvents
      ..assignAll(v)
      ..sort((a, b) => b.id!.compareTo(a.id!)); // newest first
  }

  void _scheduleNotifications() {
    // cancel all old reminders first (you could track IDs instead)
    notifier.cancelAll();

    final now = tz.TZDateTime.now(tz.local);
    for (final e in filteredEvents) {
      final dt = e.eventDate;
      final start = e.startTime;

      var scheduled = tz.TZDateTime(
        tz.local,
        dt.year,
        dt.month,
        dt.day,
        start.hour,
        start.minute,
      );

      // ← If that time is already past today, bump it to tomorrow
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      notifier.zonedSchedule(
        e.id!,
        e.title,
        e.note ?? '',
        scheduled,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'reminder_channel', // channel id
            'Reminders', // channel name
            channelDescription: 'Scheduled event reminders',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentSound: true,
            presentBadge: true,
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: jsonEncode({'route': '/events/detail', 'id': e.id}),
      );
    }
  }

  /// FETCH ALL
  Future<void> index() async {
    try {
      isLoading.value = true;
      final all = await _db.list();
      states.assignAll(all);
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Could not load records: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// FETCH ONE
  Future<void> show(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final res = await _db.retrieve(id);
      if (res == null) {
        errorMessage.value = 'Not found';
      }

      currentEvent.value = res;
    } catch (e) {
      errorMessage.value = 'Could not load record #$id: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// CREATE
  Future<void> store(EventResponse req) async {
    try {
      isLoading.value = true;
      final res = await _db.make(req);

      states.add(res);
      states.refresh();

      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Could not create record: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// CREATE OR UPDATE
  Future<void> saveChange(EventResponse req) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      if (req.id == null) {
        // → CREATE
        final created = await _db.make(req);
        // insert at top so newest appears first:
        states.insert(0, created);
      } else {
        // → UPDATE: stamp the new updatedAt
        final updated = req.copyWith(updatedAt: DateTime.now());
        await _db.release(updated);

        // find & replace
        final idx = states.indexWhere((e) => e.id == updated.id);
        if (idx != -1) {
          states[idx] = updated;
        }
      }
    } catch (e) {
      errorMessage.value = 'Could not save event: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// UPDATE
  Future<void> change(EventResponse req) async {
    try {
      isLoading.value = true;
      await _db.release(req);

      final idx = states.indexWhere((res) => res.id == req.id);
      if (idx != -1) {
        states[idx] = req;
        states.refresh();
      }

      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Could not update record: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// DELETE
  Future<void> remove(int id) async {
    try {
      isLoading.value = true;
      await _db.destoy(id);

      states.removeWhere((res) => res.id == id);

      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Could not delete record: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
