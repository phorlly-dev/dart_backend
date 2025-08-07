import 'package:dart_backend/models/event_response.dart';
import 'package:dart_backend/utils/index.dart';
import 'package:flutter/material.dart';

/// A card that displays an event's details: title, time range, notes, and status.
class EventCard extends StatelessWidget {
  /// The event to display
  final EventResponse event;

  /// Background color of the card
  final Color backgroundColor;

  /// Corner radius of the card
  final double borderRadius;

  //Action callback
  final VoidCallback? onTap, onLongPress;

  const EventCard({
    super.key,
    this.onTap,
    required this.event,
    this.borderRadius = 12.0,
    this.backgroundColor = Colors.blueAccent,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final texts = Theme.of(context).textTheme;

    // Format start and end times
    final start = dtToTm(event.startTime);
    final end = dtToTm(event.endTime);
    final date = dtToTx(event.eventDate);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        color: backgroundColor.withValues(alpha: 0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Event details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.title, style: texts.titleLarge),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded, size: 16.0),
                        const SizedBox(width: 4.0),
                        Wrap(
                          children: [
                            Text(
                              '$start – $end',
                              style: texts.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w400),
                            ),
                            Text(
                              ' on $date',
                              style: texts.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (event.note?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 8.0),
                      Text(event.note!, style: texts.bodyMedium),
                    ],
                  ],
                ),
              ),
              // Divider
              Container(
                height: 60,
                width: 1,
                color: Theme.of(context).dividerColor,
                margin: const EdgeInsets.symmetric(horizontal: 12.0),
              ),
              // Event status label (rotated vertical)
              RotatedBox(
                quarterTurns: 3,
                child: Text(
                  event.status.label.toUpperCase(),
                  style: texts.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
