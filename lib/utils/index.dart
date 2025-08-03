import 'package:bcrypt/bcrypt.dart';
import 'package:dart_backend/controllers/event_controller.dart';
import 'package:dart_backend/models/event.dart';
import 'package:dart_backend/models/user.dart';
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

enum Status { pending, loading, completed, failed, cancel }

class StatusItem {
  final int id;
  final String name;
  final Status status;

  const StatusItem({
    required this.id,
    required this.name,
    required this.status,
  });
}

final statusList = [
  StatusItem(id: 0, name: 'Pending...', status: Status.pending),
  StatusItem(id: 1, name: 'Loading...', status: Status.loading),
  StatusItem(id: 2, name: 'Completed', status: Status.completed),
  StatusItem(id: 3, name: 'Failed', status: Status.failed),
  StatusItem(id: 4, name: 'Cancel', status: Status.cancel),
];

class UserParams {
  final User? info;

  UserParams({this.info});
}

class EventParams {
  final int? id;
  final Event? state;
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

String timeStr(String name, {String? format}) =>
    dateStr(strDate(name), format: format ?? 'h:mm a');

String dateStr(DateTime date, {String? format}) =>
    DateFormat(format ?? 'd MMMM yyyy').format(date);

DateTime strDate(String name) => DateTime.parse(name);

DateTime dateNow() => DateTime.now();

bool dateCheck(String provided, DateTime selected) {
  final str = strDate(provided);
  final providedDate = DateFormat.yMd().format(str);
  final selectedDate = DateFormat.yMd().format(selected);

  if (providedDate == selectedDate) {
    return true;
  }

  return false;
}

int timeSplit(String time, int index) =>
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


        // return DataTableView<Task>(
        //   items: ctrl.tasks,
        //   isLoading: ctrl.isLoading.value,
        //   hasError: ctrl.errorMessage.value,
        //   notFound: ctrl.tasks,
        //   isSelected: (t) => t.done,
        //   columns: const [
        //     DataColumn(label: Text('Id')),
        //     DataColumn(label: Text('Title')),
        //     DataColumn(label: Text('Done')),
        //   ],
        //   rowBuilder: (t, i) => [
        //     DataCell(Text('${i + 1}')),
        //     DataCell(Text(t.title)),
        //     DataCell(
        //       Checkbox(
        //         value: t.done,
        //         onChanged: (v) => ctrl.change(t.copyWith(done: v!)),
        //       ),
        //     ),
        //   ],
        //   onEdit: (t) => taskForm(context, task: t),
        //   onDelete: (t) => confirmDelete<Task>(
        //     title: t.title,
        //     onConfirm: () async => await ctrl.remove(t.id!),
        //   ),
        // );