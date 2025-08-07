import 'package:bcrypt/bcrypt.dart';
import 'package:dart_backend/controllers/event_controller.dart';
import 'package:dart_backend/controllers/task_controller.dart';
import 'package:dart_backend/controllers/user_controller.dart';
import 'package:dart_backend/models/event_response.dart';
import 'package:dart_backend/models/task_response.dart';
import 'package:dart_backend/models/user_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// List of Background Images////
final bgList = [
  "assets/images/bg1.jpeg",
  "assets/images/bg2.jpeg",
  "assets/images/bg3.jpeg",
  "assets/images/bg4.webp",
  "assets/images/bg5.jpeg",
  "assets/images/bg6.jpeg",
  "assets/images/bg7.jpg",
  "assets/images/bg8.jpeg",
];

class UserParams {
  final int? id;
  final UserResponse? state;
  final UserController? payload;

  UserParams({this.id, this.state, this.payload});
}

class TaskParams {
  final int? id;
  final TaskResponse? state;
  final TaskController? payload;

  TaskParams({this.id, this.state, this.payload});
}

class TabViewPages {
  final List<Widget> pages;
  final List<IconData>? icons;
  final List<String?> labels;

  TabViewPages({
    this.icons,
    required this.labels,
    required this.pages,
  });
}

class EventParams {
  final int? id;
  final EventResponse? state;
  final EventController? payload;

  EventParams({this.id, this.state, this.payload});
}

String hashPwd(String password) {
  final salt = BCrypt.gensalt(); // generates a random salt
  final hashed = BCrypt.hashpw(password, salt);

  return hashed;
}

bool checkPwd(String req, String current) => BCrypt.checkpw(req, current);

String? setEnv(String name) {
  final env = dotenv.env[name];
  if (env!.isNotEmpty) {
    return env;
  }

  return null;
}

String getInitials(String name) {
  // 1) Remove any non-letter characters (like periods, commas, etc.)
  final cleaned = name.replaceAll(RegExp(r'[^A-Za-z\s]'), '').trim();
  if (cleaned.isEmpty) return '';

  // 2) Split on whitespace
  final parts = cleaned.split(RegExp(r'\s+'));

  String initials;
  if (parts.length >= 2) {
    // Multi-word: first letter of first + first letter of last
    initials = parts.first[0] + parts.last[0];
  } else {
    // Single word: first two letters (or just one, if it's only one letter long)
    initials = parts.first.substring(0, parts.first.length.clamp(1, 2));
  }

  return initials.toUpperCase();
}

String txToTm(String name, {String? format}) =>
    dtToTx(strToDt(name), format: format ?? 'h:mm a');

String dtToTm(DateTime name, {String? format}) =>
    dtToTx(name, format: format ?? 'h:mm a');

String dtToTx(DateTime date, {String? format}) =>
    DateFormat(format ?? 'd MMMM yyyy').format(date);

DateTime dtNow() => DateTime.now();

bool dtCheck(String provided, DateTime selected) {
  final str = strToDt(provided);
  final providedDate = DateFormat.yMd().format(str);
  final selectedDate = DateFormat.yMd().format(selected);

  if (providedDate == selectedDate) {
    return true;
  }

  return false;
}

Color colorFromInt(int code) => Color(code);
int colorToInt(Color code) => code.toARGB32();

//from text to datetime
DateTime strToDt(String str) => DateTime.parse(str);

//datetime to text
String dtToStr(DateTime dt) => dt.toIso8601String();

int tmSplit(String time, int index) =>
    int.parse(time.toString().split(':')[index]);

/// Tries to load an argument of type [T] from Get.arguments.
///
/// - If `arguments` *is* a T, returns it directly.
/// - If `arguments` is a Map and contains [mapKey], returns
///   `fromJson(arguments[mapKey])`.
/// - Otherwise returns null.
T? loadParams<T>(
  String mapKey, {
  required T Function(dynamic json) fromJson,
}) {
  final args = Get.arguments;
  if (args is T) {
    return args;
  }
  if (args is Map<String, dynamic> && args.containsKey(mapKey)) {
    return fromJson(args[mapKey]);
  }

  return null;
}
