import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:dart_backend/controllers/event_controller.dart';
import 'package:dart_backend/models/event.dart';
import 'package:dart_backend/utils/index.dart';
import 'package:dart_backend/views/functions/index.dart';
import 'package:dart_backend/views/partials/event_card.dart';
import 'package:dart_backend/views/widgets/action_button.dart';
import 'package:dart_backend/views/widgets/select_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

class Schedule extends StatelessWidget {
  const Schedule({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<EventController>();
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(12),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                // ── Buttons ───────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ActionButton(
                      radiusBtn: 8,
                      labelBtn: 'Today',
                      iconBtn: Icons.today,
                      onPressed: () => ctrl.selectedDate.value = DateTime.now(),
                    ),
                    ActionButton(
                      labelBtn: 'Add New',
                      iconBtn: Icons.add_circle,
                      colorBtn: colors.inversePrimary,
                      onPressed: () {
                        Get.toNamed(
                          '/event/create-or-edit',
                          preventDuplicates: false,
                          arguments: EventParams(payload: ctrl),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // ── Filters ───────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: SelectOption<RepeatRule>(
                        label: 'Repeat by',
                        hint: ctrl.selectedRepeat.value.label,
                        options: RepeatRule.values.map((r) {
                          return DropdownMenuItem(
                            value: r,
                            child: Text(
                              r.label,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (r) => ctrl.selectedRepeat.value = r!,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SelectOption<EventStatus>(
                        label: 'Status',
                        hint: ctrl.selectedStatus.value.label,
                        options: EventStatus.values.map((s) {
                          return DropdownMenuItem(
                            value: s,
                            child: Text(
                              s.label,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (s) => ctrl.selectedStatus.value = s!,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // ── Calendar ──────────────────────────────
                Obx(() {
                  final selected = ctrl.selectedDate.value;
                  // does any event fall on that selected day?
                  final hasEvent = ctrl.states.any((e) {
                    final d = DateTime.parse(e.eventDate);
                    return d.year == selected.year &&
                        d.month == selected.month &&
                        d.day == selected.day;
                  });

                  return CalendarTimeline(
                    initialDate: selected,
                    showYears: true,
                    firstDate: DateTime(1000),
                    lastDate:
                        DateTime.now().add(const Duration(days: 365 * 1000)),
                    eventDates: ctrl.states
                        .map((e) {
                          final d = DateTime.parse(e.eventDate);
                          return DateTime(d.year, d.month, d.day);
                        })
                        .toSet()
                        .toList(),
                    onDateSelected: (d) => ctrl.selectedDate.value = d,
                    monthColor: colors.outline,
                    dayColor:
                        Get.isDarkMode ? Colors.grey[600] : Colors.teal[200],
                    dayNameColor: hasEvent ? const Color(0xFF333A47) : null,
                    activeDayColor: hasEvent ? Colors.tealAccent : null,
                    activeBackgroundDayColor: hasEvent
                        ? Colors.blueAccent[200]
                        : Colors.redAccent[100],
                    dotColor: hasEvent ? null : Colors.redAccent[100],
                  );
                }),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // ── List of filtered events ─────────────────
          Obx(() {
            final evts = ctrl.filteredEvents;
            if (evts.isEmpty) {
              return SliverToBoxAdapter(
                child: Center(child: SizedBox.shrink()),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, idx) => _showEvent(ctx, ctrl, evts[idx], idx),
                childCount: evts.length,
              ),
            );
          }),

          SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _showEvent(
      BuildContext ctx, EventController payload, Event state, int index) {
    return AnimationConfiguration.staggeredList(
      position: index,
      // ↑ this is the total time for the whole stagger sequence
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        // you can also slow just the slide:
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        horizontalOffset: MediaQuery.of(ctx).size.width,
        verticalOffset: 0,
        child: FadeInAnimation(
          // and slow the fade:
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeIn,
          child: EventCard(
            event: state,
            backgroundColor: state.color,
            onLongPress: () => _showBottomSheet(ctx, payload, state),
            onTap: () => Get.toNamed(
              '/event/detail',
              preventDuplicates: false,
              arguments: state.id,
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(
      BuildContext ctx, EventController payload, Event state) {
    final colors = Theme.of(ctx).colorScheme;

    showSottomShee(height: .2, children: [
      ActionButton(
        widthBtn: .8.w,
        labelBtn: 'Edit',
        colorBtn: colors.outline,
        iconBtn: Icons.edit_document,
        iconSize: 20,
        textSize: 18,
        onPressed: () async {
          await Get.toNamed(
            '/event/create-or-edit',
            preventDuplicates: false,
            arguments: EventParams(state: state, payload: payload),
          );
          Get.back();
        },
      ),
      ActionButton(
        widthBtn: .8.w,
        colorBtn: colors.error,
        labelBtn: 'Delete',
        iconBtn: Icons.delete,
        iconSize: 20,
        textSize: 18,
        onPressed: () async {
          Get.back();
          await confirmDelete<Event>(
            ctx,
            title: state.title,
            onConfirm: () async {
              await payload.remove(state.id!);
            },
          );
        },
      ),
      ActionButton(
        widthBtn: .8.w,
        labelBtn: 'Close',
        colorBtn: colors.scrim,
        iconBtn: Icons.close,
        iconSize: 20,
        textSize: 18,
        onPressed: () => Get.back(),
      ),
    ]);
  }
}
