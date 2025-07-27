import 'package:bcrypt/bcrypt.dart';
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
