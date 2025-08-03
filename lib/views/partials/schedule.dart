import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:dart_backend/controllers/event_controller.dart';
import 'package:dart_backend/models/event.dart';
import 'package:dart_backend/utils/index.dart';
import 'package:dart_backend/utils/notification_service.dart';
import 'package:dart_backend/views/functions/index.dart';
import 'package:dart_backend/views/widgets/action_button.dart';
import 'package:dart_backend/views/partials/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  late DateTime _selectedDate;
  List<DateTime> _eventDates = [];
  late final EventController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find();
    _resetSelectedDate();
  }

  void _resetSelectedDate() {
    _selectedDate = DateTime.now();

    final dates = _controller.items
        .map((state) {
          final date = strDate(state.eventDate);
          return DateTime(date.year, date.month, date.day);
        })
        .toSet()
        .toList();

    if (dates.isNotEmpty) {
      setState(() {
        _eventDates = dates;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(8),
      child: CustomScrollView(
        slivers: [
          // ── This sliver holds your "header" + calendar + buttons ───────
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ActionButton(
                      radiusBtn: 8,
                      labelBtn: 'Today',
                      iconBtn: Icons.today,
                      onPressed: () => setState(() => _resetSelectedDate()),
                    ),
                    ActionButton(
                      labelBtn: 'Add New',
                      iconBtn: Icons.add_circle,
                      colorBtn: colors.inversePrimary,
                      onPressed: () => Get.toNamed(
                        '/event/create-or-edit',
                        preventDuplicates: false,
                        arguments: EventParams(payload: _controller),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                CalendarTimeline(
                  showYears: true,
                  initialDate: _selectedDate,
                  firstDate: DateTime(1000),
                  lastDate:
                      DateTime.now().add(const Duration(days: 365 * 1000)),
                  eventDates: _eventDates,
                  onDateSelected: (date) =>
                      setState(() => _selectedDate = date),
                  // leftMargin: 8,
                  monthColor: colors.outline,
                  dayColor: Colors.teal[200],
                  dayNameColor: const Color(0xFF333A47),
                  activeDayColor: Colors.white,
                  activeBackgroundDayColor: Colors.redAccent[100],
                  dotColor: Colors.white,
                  // selectableDayPredicate: (date) => date.day != 23,
                  // locale: 'km',
                ),
              ],
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 18)),

          // ── Now the sliver list of your cards ──────────────────────────
          Obx(() {
            final states = _controller.items;
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: states.length,
                (ctx, idx) {
                  final item = states[idx];
                  scheduledRemind(
                    id: item.id ?? 0,
                    title: item.title,
                    body: item.note ?? '',
                    remind: item.remindMin,
                    route: '/event/detail',
                  );

                  if (item.repeatRule == 'Daily') {
                    final time = timeStr(item.startTime, format: 'HH:mm');
                    scheduledOnTime(
                      id: item.id ?? 0,
                      title: item.title,
                      body: item.note ?? '',
                      hour: timeSplit(time, 0),
                      minute: timeSplit(time, 1),
                      daily: true,
                      route: '/event/detail',
                    );

                    return AnimationConfiguration.staggeredList(
                      position: idx,
                      child: SlideAnimation(
                        child: FadeInAnimation(
                          child: EventCard(
                            event: item,
                            backgroundColor: item.color,
                            onLongPress: () => bottomSheet(context, item),
                            onTap: () => Get.toNamed(
                              '/event/detail',
                              preventDuplicates: false,
                              arguments: item.id,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  if (dateCheck(item.eventDate, _selectedDate)) {
                    scheduledAt(
                      id: item.id ?? 0,
                      title: item.title,
                      body: item.note ?? '',
                      at: strDate(item.eventDate),
                      route: '/event/detail',
                    );

                    return AnimationConfiguration.staggeredList(
                      position: idx,
                      child: SlideAnimation(
                        child: FadeInAnimation(
                          curve: Curves.easeIn,
                          delay: const Duration(milliseconds: 100),
                          child: EventCard(
                            event: item,
                            backgroundColor: item.color,
                            onLongPress: () => bottomSheet(context, item),
                            onTap: () => Get.toNamed(
                              '/event/detail',
                              preventDuplicates: false,
                              arguments: item.id,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            );
          }),

          SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Future<void> bottomSheet(BuildContext ctx, Event state) {
    final colors = Theme.of(ctx).colorScheme;

    return showSottomShee(height: .25, children: [
      SizedBox(
        height: 12,
      ),
      ActionButton(
        widthBtn: .8.w,
        labelBtn: 'Edit',
        colorBtn: colors.outline,
        iconBtn: Icons.edit_document,
        iconSize: 24,
        textSize: 20,
        onPressed: () async {
          await Get.toNamed(
            '/event/create-or-edit',
            preventDuplicates: false,
            arguments: EventParams(state: state, payload: _controller),
          );
          Get.back();
        },
      ),
      ActionButton(
        widthBtn: .8.w,
        colorBtn: colors.error,
        labelBtn: 'Delete',
        iconBtn: Icons.delete,
        iconSize: 24,
        textSize: 20,
        onPressed: () async {
          Get.back();
          await confirmDelete<Event>(
            ctx,
            title: state.title,
            onConfirm: () async {
              await _controller.remove(state.id!);
            },
          );
        },
      ),
      ActionButton(
        widthBtn: .8.w,
        labelBtn: 'Close',
        colorBtn: colors.scrim,
        iconBtn: Icons.close,
        iconSize: 24,
        textSize: 20,
        onPressed: () => Get.back(),
      ),
    ]);
  }
}
