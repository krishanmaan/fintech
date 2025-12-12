import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/accountScreen/login_screen.dart';
import 'screens/accountScreen/verify_identity_screen.dart';
import 'screens/mainScreen/home.dart';
import 'services/storage_service.dart';
import 'splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WFino',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF532C8C)),
        useMaterial3: true,
      ),
      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: child ?? const SizedBox.shrink(),
      ),
      home: const AuthChecker(),
    );
  }
}

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  Future<Widget> _determineInitialScreen() async {
    final storageService = StorageService();
    final isLoggedIn = await storageService.getLoginState();
    
    print('🔐 Login check: $isLoggedIn');

    if (!isLoggedIn) {
      print('❌ User not logged in - navigating to LoginScreen');
      return const LoginScreen();
    }

    // User is logged in, check KYC status
    final kycStatus = await storageService.getKycStatus();
    final kycStatusValue = kycStatus?['kyc_status'] as String?;
    
    print('📋 KYC Status: $kycStatusValue');

    if (kycStatusValue == 'COMPLETED') {
      print('✅ KYC completed - navigating to HomeScreen');
      return const HomeScreen();
    } else {
      print('⚠️ KYC not verified - navigating to VerifyIdentityScreen');
      return const VerifyIdentityScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _determineInitialScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final targetScreen = snapshot.data ?? const LoginScreen();
        final splashDuration = targetScreen is LoginScreen ? 3 : 2;

        return SplashScreen(
          duration: splashDuration,
          child: targetScreen,
        );
      },
    );
  }
}
