import 'package:dart_backend/controllers/auth_controller.dart';
import 'package:dart_backend/controllers/user_controller.dart';
import 'package:dart_backend/models/user_response.dart';
import 'package:dart_backend/utils/index.dart';
import 'package:dart_backend/views/functions/toastification.dart';
import 'package:dart_backend/views/widgets/ui/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideBar extends StatelessWidget {
  final UserResponse? me;

  const SideBar({super.key, this.me});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4db6ac), Color(0xFF43cea2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.blueGrey,
              child: Text(
                getInitials(me?.name ?? 'Mrr. Dev'),
                style: TextStyle(color: Colors.white),
              ),
            ),
            accountName: Text('My name: ${me?.name ?? 'Dev'}'),
            accountEmail: Wrap(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My email: ${me?.email ?? 'dev@g.me'}',
                      style: TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                    Text(
                      'Created at: ${dateStr(strDate(me!.createdAt))}',
                      style: TextStyle(fontSize: 12, color: Colors.white54),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          MenuItem(
            label: "Profile",
            goTo: () async {
              final ctrl = Get.find<UserController>();
              Get.back();
              await Get.toNamed('/users/profile',
                  arguments: UserParams(payload: ctrl, state: me));
            },
            icon: Icons.person,
            isActive: true,
          ),
          SizedBox(height: 24),
          MenuItem(
            label: "Log out",
            goTo: () async {
              final auth = Get.find<AuthController>();
              await auth.logout();
              Get.offAllNamed('/auth');
              if (!context.mounted) return;
              showToast(
                context,
                type: Toast.warning,
                title: 'Signed out!',
                message: auth.errorMessage.value,
              );
            },
            icon: Icons.logout,
            isActive: true,
          ),
        ],
      ),
    );
  }
}
