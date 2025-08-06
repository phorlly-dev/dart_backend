part of 'user_response.dart';

enum Sex { male, female, other }

extension SexX on Sex {
  int get code {
    switch (this) {
      case Sex.male:
        return 0;
      case Sex.female:
        return 1;
      case Sex.other:
        return 2;
    }
  }

  String get label {
    switch (this) {
      case Sex.male:
        return 'Male';
      case Sex.female:
        return 'Female';
      case Sex.other:
        return 'Other';
    }
  }

  static Sex fromCode(int code) {
    return Sex.values.firstWhere((e) => e.code == code);
  }
}
