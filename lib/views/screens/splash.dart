import 'package:dart_backend/views/widgets/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(seconds: 3));
    // either…
    Get.offAllNamed('/app-shell');
  }

  @override
  Widget build(BuildContext context) {
    // You can show your logo or animation here
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image(image: AssetImage("assets/images/browser.png")),
            ),
            SizedBox(height: 24.h),
            LoadingAnimation(
              type: LoadingType.cupertino,
              label: "Please Wait...",
            ),
          ],
        ),
      ),
    );
  }
}
