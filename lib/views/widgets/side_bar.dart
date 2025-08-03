import 'package:dart_backend/controllers/auth_controller.dart';
import 'package:dart_backend/utils/index.dart';
import 'package:dart_backend/utils/toastification.dart';
import 'package:dart_backend/views/widgets/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideBar extends StatelessWidget {
  final String? name, email, createdAt;

  const SideBar({super.key, this.name, this.email, this.createdAt});

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
                getInitials(name ?? 'Mrr. Dev'),
                style: TextStyle(color: Colors.white),
              ),
            ),
            accountName: Text('My name: ${name ?? 'Dev'}'),
            accountEmail: Wrap(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My email: ${email ?? 'dev@g.me'}',
                      style: TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                    Text(
                      'Created at: ${dateStr(strDate(createdAt!))}',
                      style: TextStyle(fontSize: 12, color: Colors.white54),
                    )
                  ],
                ),
              ],
            ),
          ),
          MenuItem(
            label: "Log out".toUpperCase(),
            goTo: () async {
              final me = Get.find<AuthController>();
              await me.logout();
              Get.offAllNamed('/auth');
              if (!context.mounted) return;
              showToast(
                context,
                type: Toast.warning,
                title: 'Signed out!',
                message: me.errorMessage.value,
              );
            },
            icon: Icons.logout,
          ),
        ],
      ),
    );
  }
}
