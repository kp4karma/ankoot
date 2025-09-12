import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:toastification/toastification.dart';

void showToast({required BuildContext context, required String title, required String message, required ToastType type}) {
  // Determine device type
  final breakpoint = ResponsiveBreakpoints.of(context);

  final bool isMobile = breakpoint.isMobile;
  final bool isTablet = breakpoint.isTablet;
  final bool isDesktop = breakpoint.isDesktop;

  // Size & alignment responsiveness
  final Alignment alignment = isMobile ? Alignment.bottomCenter : (isTablet ? Alignment.bottomRight : Alignment.topRight);

  final double fontSize = isMobile ? 12 : (isTablet ? 14 : 16);

  final EdgeInsets padding = isMobile ? const EdgeInsets.symmetric(horizontal: 10, vertical: 14) : const EdgeInsets.symmetric(horizontal: 16, vertical: 20);

  final EdgeInsets margin = isMobile ? const EdgeInsets.symmetric(horizontal: 8, vertical: 6) : const EdgeInsets.symmetric(horizontal: 12, vertical: 8);

  Color primaryColor;
  IconData icon;

  switch (type.toToastificationType) {
    case ToastificationType.success:
      primaryColor = Colors.green;
      icon = Icons.check_circle;
      break;
    case ToastificationType.error:
      primaryColor = Colors.red;
      icon = Icons.error;
      break;
    case ToastificationType.warning:
      primaryColor = Colors.orange;
      icon = Icons.warning_amber_rounded;
      break;
    default:
      primaryColor = Colors.blue;
      icon = Icons.info;
  }

  toastification.show(
    context: context,
    type: type.toToastificationType,
    style: ToastificationStyle.minimal,
    autoCloseDuration: const Duration(seconds: 2),
    title: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
    ),
    description: Text(
      message,
      style: TextStyle(color: Colors.black, fontSize: fontSize - 2),
    ),
    alignment: alignment,
    direction: TextDirection.ltr,
    animationDuration: const Duration(milliseconds: 300),
    icon: Icon(icon, color: primaryColor),
    showIcon: true,
    primaryColor: primaryColor,
    progressBarTheme: ProgressIndicatorThemeData(linearTrackColor: primaryColor.withAlpha(25), color: primaryColor),
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    padding: padding,
    margin: margin,
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [BoxShadow(color: Color(0x07000000), blurRadius: 16, offset: Offset(0, 16), spreadRadius: 3)],
    showProgressBar: true,
    closeButtonShowType: CloseButtonShowType.onHover,
    closeOnClick: false,
    pauseOnHover: false,
    dragToClose: true,
    applyBlurEffect: false,
  );
}

enum ToastType { success, error, warning, info }

extension ToastTypeMapper on ToastType {
  ToastificationType get toToastificationType {
    switch (this) {
      case ToastType.success:
        return ToastificationType.success;
      case ToastType.error:
        return ToastificationType.error;
      case ToastType.warning:
        return ToastificationType.warning;
      case ToastType.info:
      default:
        return ToastificationType.info;
    }
  }
}
