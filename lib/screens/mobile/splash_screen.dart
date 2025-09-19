import 'package:ankoot_new/screens/main_screen.dart';
import 'package:ankoot_new/screens/mobile/login_screen.dart';
import 'package:ankoot_new/screens/mobile/mobile_admin_home_screen.dart';
import 'package:ankoot_new/screens/mobile/mobile_home_screen.dart';
import 'package:ankoot_new/theme/storage_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _slideController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Set status bar style for splash
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    // Fade animation controller
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Scale animation controller
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Slide animation controller
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Scale animation with bounce effect
    _scaleAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Slide animation for subtitle
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 2.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));
  }

  void _startSplashSequence() async {
    // Start fade animation
    _fadeController.forward();

    // Delay and start scale animation
    await Future.delayed(const Duration(milliseconds: 300));
    _scaleController.forward();

    // Delay and start slide animation
    await Future.delayed(const Duration(milliseconds: 500));
    _slideController.forward();

    // Wait for animations to complete and show splash for a moment
    await Future.delayed(const Duration(milliseconds: 3000));

    print("${UserStorageHelper.getUserData()?.data?.user?.userMobile.toString()}");
    // Navigate to main screen
    if (mounted) {


      if(kIsWeb){
        if(UserStorageHelper.getUserData()?.data?.user?.userType != null){
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (context) => MainScreen()),
          );
        }else{
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (context) => LoginScreen()),
          );
        }

      }else{
        if(UserStorageHelper.getUserData()?.data?.user?.userType != null){
          if( UserStorageHelper.getUserData()?.data?.user?.userType.toString().toLowerCase() == "admin" ){
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(builder: (context) => MobileAdminHomeScreen()),
            );
          }else{
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(builder: (context) => MobileHomeScreen()),
            );
          }
        }else{
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (context) => LoginScreen()),
          );
        }

      }

    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepOrange.shade200, // Light deep orange
              Colors.deepOrange.shade300,
              Colors.deepOrange.shade400,

            ],
            stops: const [0.0, 0.25, 0.5, ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo/Icon Section
              AnimatedBuilder(
                animation: _scaleController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        width: kIsWeb ? MediaQuery.of(context).size.width * 0.10:MediaQuery.of(context).size.width * 0.40,
                        height:kIsWeb ? MediaQuery.of(context).size.width * 0.10: MediaQuery.of(context).size.width * 0.40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Image.asset("assets/hpprasadm.png"),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              // Main Title
              AnimatedBuilder(
                animation: _fadeController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Column(
                        children: [
                          Text(
                            "HP-Prasadam",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: const Offset(2, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),




                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 80),

              // Loading indicator
              AnimatedBuilder(
                animation: _fadeController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Loading...",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
