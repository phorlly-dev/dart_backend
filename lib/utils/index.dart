import 'package:bcrypt/bcrypt.dart';
import 'package:dart_backend/models/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

class Params {
  final User? info;

  Params({this.info});
}

String hashPwd(String password) {
  final salt = BCrypt.gensalt(); // generates a random salt
  final hashed = BCrypt.hashpw(password, salt);

  return hashed;
}

bool checkPwd(String req, String current) {
  return BCrypt.checkpw(req, current);
}

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
