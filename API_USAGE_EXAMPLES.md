# API Usage Examples

This document contains practical code examples for using the authentication APIs in your Flutter application.

## Table of Contents
- [Basic Setup](#basic-setup)
- [Authentication Flow](#authentication-flow)
- [Storage Operations](#storage-operations)
- [Error Handling](#error-handling)
- [Widget Integration](#widget-integration)
- [Auto-Login Check](#auto-login-check)

---

## Basic Setup

First, import the necessary services in your Dart file:

```dart
import 'package:fintech/services/auth_api_service.dart';
import 'package:fintech/services/storage_service.dart';
```

Initialize the services:

```dart
final authService = AuthApiService();
final storageService = StorageService();
```

---

## Authentication Flow

### Step 1: Check if Phone Number Exists

```dart
Future<void> stepCheckPhone() async {
  try {
    final response = await authService.checkPhone('9988776655');
    
    print('User exists: ${response.data.userExists}');
    print('Next step: ${response.data.nextStep}');
    
    if (response.data.nextStep == 'SEND_OTP') {
      // Proceed to send OTP
    }
  } on ApiException catch (e) {
    print('Error: ${e.message}');
  }
}
```

### Step 2: Send OTP to Phone Number

```dart
Future<String?> stepSendOtp() async {
  try {
    final response = await authService.sendOtp('9988776655');
    
    print('OTP: ${response.data.otp}');
    print('Expires in: ${response.data.expiresIn}');
    
    // Return OTP for testing (in production, user enters it)
    return response.data.otp;
  } on ApiException catch (e) {
    print('Error: ${e.message}');
    return null;
  }
}
```

### Step 3: Verify OTP and Login

```dart
Future<void> stepVerifyOtpAndLogin(String otp) async {
  try {
    final response = await authService.verifyOtp('9988776655', otp);
    
    // Save all login data to local storage
    await storageService.saveLoginData(response.data);
    
    print('Login successful!');
    print('User: ${response.data.user.firstName} ${response.data.user.lastName}');
    print('Role: ${response.data.currentUserRole}');
    print('Can access app: ${response.data.appAccess.canAccessApp}');
    
    // Navigate to home screen
  } on ApiException catch (e) {
    print('Error: ${e.message}');
  }
}
```

### Complete Login Flow

```dart
Future<void> completeLoginFlow(String phoneNumber) async {
  try {
    // Step 1: Check phone
    final checkResponse = await authService.checkPhone(phoneNumber);
    
    if (checkResponse.data.nextStep != 'SEND_OTP') {
      print('Cannot proceed: ${checkResponse.data.nextStep}');
      return;
    }
    
    // Step 2: Send OTP
    final otpResponse = await authService.sendOtp(phoneNumber);
    final otp = otpResponse.data.otp; // In production, wait for user input
    
    // Step 3: Verify OTP
    final loginResponse = await authService.verifyOtp(phoneNumber, otp);
    
    // Step 4: Save login data
    await storageService.saveLoginData(loginResponse.data);
    
    print('✅ Complete flow successful!');
  } catch (e) {
    print('❌ Error: $e');
  }
}
```

---

## Storage Operations

### Get Stored User Data

```dart
Future<void> getStoredUserData() async {
  final token = await storageService.getAccessToken();
  final role = await storageService.getUserRole();
  final userData = await storageService.getUserData();
  final employeeData = await storageService.getEmployeeData();
  final companyData = await storageService.getCompanyData();
  final kycStatus = await storageService.getKycStatus();
  
  print('Token: $token');
  print('Role: $role');
  print('User: $userData');
  print('Employee: $employeeData');
  print('Company: $companyData');
  print('KYC: $kycStatus');
}
```

### Check Login Status

```dart
Future<bool> checkLoginStatus() async {
  final isLoggedIn = await storageService.isLoggedIn();
  return isLoggedIn;
}
```

### Logout User

```dart
Future<void> logout() async {
  await storageService.clearAll();
  print('User logged out');
  // Navigate to login screen
}
```

---

## Error Handling

### Comprehensive Error Handling Example

```dart
Future<void> loginWithErrorHandling(String phoneNumber, String otp) async {
  try {
    // Try to verify OTP
    final response = await authService.verifyOtp(phoneNumber, otp);
    await storageService.saveLoginData(response.data);
    
    // Success - navigate to home
    print('✅ Login successful');
    
  } on ApiException catch (e) {
    // API-specific errors
    if (e.statusCode == 400) {
      print('Invalid OTP or phone number');
    } else if (e.statusCode == 401) {
      print('OTP expired');
    } else if (e.statusCode == 429) {
      print('Too many attempts');
    } else {
      print('API Error: ${e.message}');
    }
  } catch (e) {
    // Network or other errors
    print('Unexpected error: $e');
  }
}
```

---

## Widget Integration

### Login Button Example

```dart
import 'package:flutter/material.dart';
import 'package:fintech/services/auth_api_service.dart';
import 'package:fintech/screens/accountScreen/otp_verification_screen.dart';

class LoginButton extends StatelessWidget {
  final String phoneNumber;
  
  const LoginButton({super.key, required this.phoneNumber});
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          // Check phone
          final checkResult = await AuthApiService().checkPhone(phoneNumber);
          
          if (checkResult.data.nextStep == 'SEND_OTP') {
            // Send OTP
            final otpResult = await AuthApiService().sendOtp(phoneNumber);
            
            // Show OTP (dev mode)
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('OTP: ${otpResult.data.otp}')),
            );
            
            // Navigate to OTP screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpVerificationScreen(
                  phoneNumber: phoneNumber,
                  otpFromApi: otpResult.data.otp,
                ),
              ),
            );
          }
        } on ApiException catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.message}')),
          );
        }
      },
      child: const Text('Login'),
    );
  }
}
```

### OTP Verification Button Example

```dart
import 'package:flutter/material.dart';
import 'package:fintech/services/auth_api_service.dart';
import 'package:fintech/services/storage_service.dart';
import 'package:fintech/screens/accountScreen/employee_id_screen.dart';

class VerifyOtpButton extends StatelessWidget {
  final String phoneNumber;
  final String otp;
  
  const VerifyOtpButton({
    super.key,
    required this.phoneNumber,
    required this.otp,
  });
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          // Verify OTP
          final result = await AuthApiService().verifyOtp(phoneNumber, otp);
          
          // Save login data
          await StorageService().saveLoginData(result.data);
          
          // Show success
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful!')),
          );
          
          // Navigate to home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const EmployeeIdScreen()),
          );
        } on ApiException catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.message}')),
          );
        }
      },
      child: const Text('Verify OTP'),
    );
  }
}
```

---

## Auto-Login Check

### Check for Existing Login on App Startup

```dart
import 'package:flutter/material.dart';
import 'package:fintech/services/storage_service.dart';
import 'package:fintech/screens/mainScreen/home.dart';
import 'package:fintech/screens/accountScreen/login_screen.dart';

Future<Widget> determineStartScreen() async {
  final storage = StorageService();
  final isLoggedIn = await storage.isLoggedIn();
  
  if (isLoggedIn) {
    // User is already logged in
    final token = await storage.getAccessToken();
    
    // Optional: Verify token is still valid
    // If valid, go to home screen
    return const HomeScreen();
  } else {
    // User needs to login
    return const LoginScreen();
  }
}
```

### Usage in main.dart

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final startScreen = await determineStartScreen();
  
  runApp(MyApp(home: startScreen));
}

class MyApp extends StatelessWidget {
  final Widget home;
  
  const MyApp({super.key, required this.home});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fintech App',
      home: home,
    );
  }
}
```

---

## Testing Examples

### Test All APIs with Test Phone Number

```dart
Future<void> testAllAPIs() async {
  const testPhone = '9988776655';
  final authService = AuthApiService();
  
  print('🧪 Testing Check Phone API...');
  await authService.checkPhone(testPhone);
  
  print('\n🧪 Testing Send OTP API...');
  final otpResponse = await authService.sendOtp(testPhone);
  
  print('\n🧪 Testing Verify OTP API...');
  await authService.verifyOtp(testPhone, otpResponse.data.otp);
  
  print('\n✅ All tests passed!');
}
```

### Using ApiTestHelper

```dart
import 'package:fintech/utils/api_test_helper.dart';

Future<void> runTests() async {
  final tester = ApiTestHelper();
  
  // Test individual APIs
  await tester.testCheckPhone('9988776655');
  await tester.testSendOtp('9988776655');
  await tester.testVerifyOtp('9988776655', '569930');
  
  // Test complete flow
  await tester.testFullAuthFlow('9988776655');
  
  // Check stored data
  await tester.checkStoredData();
}
```

---

## Quick Reference

### Common Status Codes

| Code | Meaning |
|------|---------|
| 200 | Success |
| 400 | Bad Request (invalid data) |
| 401 | Unauthorized (expired OTP) |
| 404 | Not Found (user doesn't exist) |
| 429 | Too Many Requests (rate limited) |
| 500 | Server Error |

### Test Credentials

```
Phone Number: 9988776655
OTP: Displayed in app (changes each time)
```

---

## Best Practices

1. **Always use try-catch blocks** for API calls
2. **Check `context.mounted`** before showing SnackBars after async operations
3. **Save user data immediately** after successful login
4. **Clear storage on logout** using `storageService.clearAll()`
5. **Validate input** before making API calls
6. **Handle loading states** to improve UX
7. **Display error messages** in a user-friendly format

---

For more information, see:
- `API_IMPLEMENTATION.md` - Complete API documentation
- `README_API.md` - Quick start guide
- `FLOW_DIAGRAM.txt` - Visual flow diagram
