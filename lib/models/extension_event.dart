part of 'event_response.dart';

/// Mirror the SQL CHECK(status IN (0,1,2,3))
enum Status { pending, loading, completed, canceled }

extension StatusX on Status {
  int get code {
    switch (this) {
      case Status.pending:
        return 0;
      case Status.loading:
        return 1;
      case Status.completed:
        return 2;
      case Status.canceled:
        return 3;
    }
  }

  String get label {
    switch (this) {
      case Status.pending:
        return 'Pending...';
      case Status.loading:
        return 'Loading...';
      case Status.completed:
        return 'Completed';
      case Status.canceled:
        return 'Canceled';
    }
  }

  static Status fromCode(int code) {
    return Status.values.firstWhere((e) => e.code == code);
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
