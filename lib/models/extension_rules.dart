part of 'event.dart';

/// Mirror the SQL CHECK(status IN (0,1,2,3))
enum EventStatus { pending, loading, completed, canceled }

extension EventStatusX on EventStatus {
  int get code {
    switch (this) {
      case EventStatus.pending:
        return 0;
      case EventStatus.loading:
        return 1;
      case EventStatus.completed:
        return 2;
      case EventStatus.canceled:
        return 3;
    }
  }

  String get label {
    switch (this) {
      case EventStatus.pending:
        return 'Pending...';
      case EventStatus.loading:
        return 'Loading...';
      case EventStatus.completed:
        return 'Completed';
      case EventStatus.canceled:
        return 'Canceled';
    }
  }

  static EventStatus fromCode(int code) {
    return EventStatus.values.firstWhere((e) => e.code == code);
  }
}

/// In lib/models/repeat_rule.dart
enum RepeatRule { none, daily, weekly, monthly }

extension RepeatRuleX on RepeatRule {
  int get code {
    switch (this) {
      case RepeatRule.none:
        return 0;
      case RepeatRule.daily:
        return 1;
      case RepeatRule.weekly:
        return 2;
      case RepeatRule.monthly:
        return 3;
    }
  }

  String get label {
    switch (this) {
      case RepeatRule.none:
        return 'None';
      case RepeatRule.daily:
        return 'Daily';
      case RepeatRule.weekly:
        return 'Weekly';
      case RepeatRule.monthly:
        return 'Monthly';
    }
  }

  static RepeatRule fromCode(int code) {
    return RepeatRule.values.firstWhere((e) => e.code == code);
  }
}
