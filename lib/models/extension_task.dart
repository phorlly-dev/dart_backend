part of 'task_response.dart';

/// Mirror the SQL CHECK(status IN (0,1,2,3))
enum Status { pending, inProgress, completed, failed }

extension StatusX on Status {
  int get code {
    switch (this) {
      case Status.pending:
        return 0;
      case Status.inProgress:
        return 1;
      case Status.completed:
        return 2;
      case Status.failed:
        return 3;
    }
  }

  String get label {
    switch (this) {
      case Status.pending:
        return 'Pending...';
      case Status.inProgress:
        return 'In Progress';
      case Status.completed:
        return 'Completed';
      case Status.failed:
        return 'Failed';
    }
  }

  static Status fromCode(int code) {
    return Status.values.firstWhere((e) => e.code == code);
  }
}

/// In lib/models/repeat_rule.dart
enum Priority { low, medium, high }

extension PriorityX on Priority {
  int get code {
    switch (this) {
      case Priority.low:
        return 0;
      case Priority.medium:
        return 1;
      case Priority.high:
        return 2;
    }
  }

  String get label {
    switch (this) {
      case Priority.low:
        return 'Low';
      case Priority.medium:
        return 'Medium';
      case Priority.high:
        return 'High';
    }
  }

  static Priority fromCode(int code) {
    return Priority.values.firstWhere((e) => e.code == code);
  }
}
