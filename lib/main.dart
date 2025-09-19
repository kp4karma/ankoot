import 'package:ankoot_new/api/api_client.dart';
import 'package:ankoot_new/api/firebase_options.dart';
import 'package:ankoot_new/api/services/fcm_service.dart';
import 'package:ankoot_new/screens/mobile/login_screen.dart';
import 'package:ankoot_new/screens/mobile/splash_screen.dart';
import 'package:ankoot_new/theme/storage_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'theme/app_theme.dart';
import 'package:get/get.dart';
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  ApiClient.init();
  UserStorageHelper.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  if(kIsWeb){
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.web);
  }else {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }// Initialize services
  Get.put(FirebaseMessagingService());
  Get.put(NotificationService());

  runApp(const MyApp());
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {



  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HP-Prasadam',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        child = ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 800, name: MOBILE),
            const Breakpoint(start: 801, end: double.infinity, name: DESKTOP),
          ],
        );
        return EasyLoading.init()(context, child);
      },
      home: SplashScreen(),
    );
  }
}
