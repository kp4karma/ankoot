// lib/main.dart
import 'package:ankoot_new/api/api_client.dart';
import 'package:ankoot_new/screens/main_screen.dart';
import 'package:ankoot_new/screens/mobile/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'theme/app_theme.dart';

void main() {
  ApiClient.init();
  runApp(const DeliveryDashApp());
}

class DeliveryDashApp extends StatelessWidget {
  const DeliveryDashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliveryDash',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        // 👇 Wrap ResponsiveFramework first, then EasyLoading
        child = ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 800, name: MOBILE),
            const Breakpoint(start: 801, end: double.infinity, name: DESKTOP),
          ],
        );
        return EasyLoading.init()(context, child);
      },
      home: const LoginScreen(),
    );
  }
}
