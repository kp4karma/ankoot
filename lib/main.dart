// lib/main.dart - Simple Mobile and Web only
import 'package:ankoot_new/screens/main_screen.dart';
import 'package:ankoot_new/screens/mobile/login_screen.dart';
import 'package:ankoot_new/screens/mobile/mobile_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'theme/app_theme.dart';

void main() {
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
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 800, name: MOBILE),
          const Breakpoint(start: 801, end: double.infinity, name: DESKTOP),
        ],
      ),
      home: const LoginScreen(),
    );
  }
}