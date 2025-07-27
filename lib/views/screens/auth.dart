import 'dart:ui';

import 'package:dart_backend/controllers/auth_controller.dart';
import 'package:dart_backend/utils/index.dart';
import 'package:dart_backend/utils/animations.dart';
import 'package:dart_backend/views/widgets/login.dart';
import 'package:dart_backend/views/widgets/register.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _controller = Get.put(AuthController());

  // background chooser
  int _selectedIndex = 0;
  bool _showOption = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // ► FAB for background pick
        bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          height: 56,
          child: Row(
            children: [
              Expanded(child: _buildBgList()),
              const SizedBox(width: 12),
              _buildToggleButton(),
            ],
          ),
        ),
        body: Stack(
          children: [
            // ► Fullscreen background
            Positioned.fill(
              child: Image.asset(bgList[_selectedIndex], fit: BoxFit.cover),
            ),
            // ► Frosted glass container
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(color: Colors.black.withValues(alpha: 0.3)),
              ),
            ),
            // ► Main content
            SafeArea(
              child: Column(
                children: [
                  const Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // ► Tabs
                  TabBar(
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    tabs: const [
                      Tab(text: 'Login'),
                      Tab(text: 'Register'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        LoginForm(controller: _controller),
                        RegisterForm(controller: _controller),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBgList() {
    if (!_showOption) return const SizedBox();
    return ShowUpAnimation(
      delay: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: bgList.length,
        itemBuilder: (ctx, i) {
          final selected = i == _selectedIndex;
          return GestureDetector(
            onTap: () => setState(() => _selectedIndex = i),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: CircleAvatar(
                radius: selected ? 30 : 26,
                backgroundColor: selected ? Colors.white : Colors.white24,
                child: CircleAvatar(
                  radius: 26,
                  backgroundImage: AssetImage(bgList[i]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildToggleButton() {
    return GestureDetector(
      onTap: () => setState(() => _showOption = !_showOption),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(
          _showOption ? Icons.close : Icons.palette,
          color: Colors.black87,
        ),
      ),
    );
  }
}
