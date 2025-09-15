import 'package:ankoot_new/screens/main_screen.dart';
import 'package:ankoot_new/screens/mobile/mobile_admin_home_screen.dart';
import 'package:ankoot_new/screens/mobile/mobile_home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import '../../api/server/general_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController(text: "9099929109");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  // Check if running on web or desktop
  bool get isWebOrDesktop => kIsWeb ||
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS);

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (value.length != 10) {
      return 'Phone number must be 10 digits';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Call your login service
      final success = await GeneralService.systemUserLogin(
        context: context,
        userMobile: _phoneController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (success) {
        // Navigate based on platform
        if (kIsWeb) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (context) => MainScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (context) => MobileHomeScreen()),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 768;

    return Scaffold(
      backgroundColor: isLargeScreen ? Colors.grey.shade100 : Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isLargeScreen ? 32 : 24,
              vertical: 24,
            ),
            child: Container(
              width: isLargeScreen ? 480 : double.infinity,
              child: Card(
                elevation: isLargeScreen ? 8 : 0,
                shadowColor: Colors.black.withAlpha(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isLargeScreen ? 16 : 0),
                ),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(isLargeScreen ? 48 : 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // App Logo/Icon
                        Icon(
                          Icons.celebration,
                          size: isLargeScreen ? 100 : 80,
                          color: Colors.deepOrange,
                        ),
                        SizedBox(height: isLargeScreen ? 32 : 24),

                        // App Title
                        Text(
                          'Ankoot',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isLargeScreen ? 48 : 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(height: isLargeScreen ? 12 : 8),

                        // Subtitle
                        Text(
                          isLargeScreen
                              ? 'Welcome back to your event management platform!'
                              : 'Welcome back!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isLargeScreen ? 18 : 16,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: isLargeScreen ? 64 : 48),

                        // Phone Number Label
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Phone Number',
                            style: TextStyle(
                              fontSize: isLargeScreen ? 18 : 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(height: isLargeScreen ? 12 : 8),

                        // Phone Number TextField
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          validator: _validatePhoneNumber,
                          decoration: InputDecoration(
                            hintText: 'Enter your 10-digit phone number',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: isLargeScreen ? 16 : 14,
                            ),
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Colors.deepOrange,
                              size: isLargeScreen ? 24 : 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.deepOrange, width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.red, width: 1),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.red, width: 2),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: isLargeScreen ? 20 : 16,
                              horizontal: 16,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          style: TextStyle(
                            fontSize: isLargeScreen ? 18 : 16,
                            color: Colors.black87,
                          ),
                          onFieldSubmitted: (_) => _handleLogin(),
                        ),
                        SizedBox(height: isLargeScreen ? 40 : 32),

                        // Login Button
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: isLargeScreen ? 20 : 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            shadowColor: Colors.deepOrange.withAlpha(50),
                            disabledBackgroundColor: Colors.grey.shade300,
                          ),
                          child: _isLoading
                              ? SizedBox(
                            height: isLargeScreen ? 24 : 20,
                            width: isLargeScreen ? 24 : 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : Text(
                            'Login',
                            style: TextStyle(
                              fontSize: isLargeScreen ? 20 : 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        SizedBox(height:24),


                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}