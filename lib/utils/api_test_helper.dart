import '../../services/auth_api_service.dart';
import '../../services/storage_service.dart';

class ApiTestHelper {
  final authService = AuthApiService();
  final storageService = StorageService();

  Future<void> testCheckPhone(String phoneNumber) async {
    print('\n========== TESTING CHECK PHONE API ==========');
    print('Phone Number: $phoneNumber');
    print('API URL: https://api.webfino.com/api/v1/auth/check-phone');

    try {
      final response = await authService.checkPhone(phoneNumber);
      print('\n✅ SUCCESS!');
      print('Status: ${response.status}');
      print('Message: ${response.message}');
      print('User Exists: ${response.data.userExists}');
      print('User ID: ${response.data.userId}');
      print('Requires Registration: ${response.data.requiresRegistration}');
      print('Next Step: ${response.data.nextStep}');
      return;
    } catch (e) {
      print('\n❌ FAILED!');
      print('Error: $e');
      rethrow;
    }
  }

  Future<void> testSendOtp(String phoneNumber) async {
    print('\n========== TESTING SEND OTP API ==========');
    print('Phone Number: $phoneNumber');
    print('API URL: https://api.webfino.com/api/v1/auth/send-otp');

    try {
      final response = await authService.sendOtp(phoneNumber);
      print('\n✅ SUCCESS!');
      print('Status: ${response.status}');
      print('Message: ${response.message}');
      print('OTP: ${response.data.otp}');
      print('Expires In: ${response.data.expiresIn}');
      print('Next Step: ${response.data.nextStep}');
      return;
    } catch (e) {
      print('\n❌ FAILED!');
      print('Error: $e');
      rethrow;
    }
  }

  Future<void> testVerifyOtp(String phoneNumber, String otp) async {
    print('\n========== TESTING VERIFY OTP API ==========');
    print('Phone Number: $phoneNumber');
    print('OTP: $otp');
    print('API URL: https://api.webfino.com/api/v1/auth/verify-otp');

    try {
      final response = await authService.verifyOtp(phoneNumber, otp);
      print('\n✅ SUCCESS!');
      print('Status: ${response.status}');
      print('Message: ${response.message}');
      print('\n--- USER DATA ---');
      print('User ID: ${response.data.user.userId}');
      print(
        'Name: ${response.data.user.firstName} ${response.data.user.lastName}',
      );
      print('Phone: ${response.data.user.phoneNumber}');
      print('Email: ${response.data.user.email}');
      print('Phone Verified: ${response.data.user.isPhoneVerified}');
      print('Email Verified: ${response.data.user.isEmailVerified}');

      print('\n--- EMPLOYEE DATA ---');
      print('Employee ID: ${response.data.employee.employeeId}');
      print('Employee Code: ${response.data.employee.employeeCode}');
      print('Designation: ${response.data.employee.designation}');
      print('Department: ${response.data.employee.department}');
      print('Salary: ₹${response.data.employee.salary}');
      print('Advance Limit: ₹${response.data.employee.eligibleAdvanceLimit}');

      print('\n--- COMPANY DATA ---');
      print('Company ID: ${response.data.company.companyId}');
      print('Name: ${response.data.company.name}');
      print('Code: ${response.data.company.code}');
      print('Industry: ${response.data.company.industry}');

      print('\n--- KYC STATUS ---');
      print('Overall Status: ${response.data.kycStatus.kycStatus}');
      print('Completion: ${response.data.kycStatus.overallCompletion}%');
      print(
        'Aadhaar Verified: ${response.data.kycStatus.steps.aadhaarVerified}',
      );
      print('PAN Verified: ${response.data.kycStatus.steps.panVerified}');
      print(
        'Bank Details Added: ${response.data.kycStatus.steps.bankDetailsAdded}',
      );
      print('Bank Verified: ${response.data.kycStatus.steps.bankVerified}');
      print('Required Steps:');
      for (var step in response.data.kycStatus.requiredSteps) {
        print('  - $step');
      }

      print('\n--- APP ACCESS ---');
      print('Can Access App: ${response.data.appAccess.canAccessApp}');

      print('\n--- ACCESS TOKEN ---');
      print('Token: ${response.data.accessToken}');
      print('User Role: ${response.data.currentUserRole}');

      return;
    } catch (e) {
      print('\n❌ FAILED!');
      print('Error: $e');
      rethrow;
    }
  }

  Future<void> testFullAuthFlow(String phoneNumber) async {
    print('\n========================================');
    print('TESTING COMPLETE AUTHENTICATION FLOW');
    print('========================================');

    try {
      await testCheckPhone(phoneNumber);

      await Future.delayed(const Duration(seconds: 1));

      final sendOtpResponse = await authService.sendOtp(phoneNumber);
      print('\n✅ OTP sent successfully!');
      print('OTP to use: ${sendOtpResponse.data.otp}');

      await Future.delayed(const Duration(seconds: 1));

      await testVerifyOtp(phoneNumber, sendOtpResponse.data.otp);

      print('\n========================================');
      print('✅ COMPLETE FLOW SUCCESSFUL!');
      print('========================================');
    } catch (e) {
      print('\n========================================');
      print('❌ FLOW FAILED!');
      print('Error: $e');
      print('========================================');
    }
  }

  Future<void> checkStoredData() async {
    print('\n========== STORED DATA ==========');

    final token = await storageService.getAccessToken();
    print('Access Token: ${token?.substring(0, 50)}...');

    final role = await storageService.getUserRole();
    print('User Role: $role');

    final userData = await storageService.getUserData();
    if (userData != null) {
      print('User Name: ${userData['first_name']} ${userData['last_name']}');
      print('Phone: ${userData['phone_number']}');
    }

    final isLoggedIn = await storageService.isLoggedIn();
    print('Is Logged In: $isLoggedIn');
  }
}
