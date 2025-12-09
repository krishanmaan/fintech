import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/auth_models.dart';

class StorageService {
  static const String _keyAccessToken = 'access_token';
  static const String _keyUserData = 'user_data';
  static const String _keyEmployeeData = 'employee_data';
  static const String _keyCompanyData = 'company_data';
  static const String _keyKycStatus = 'kyc_status';
  static const String _keyUserRole = 'user_role';
  static const String _keyPhoneNumber = 'phone_number';
  static const String _keyBankDetails = 'bank_details';

  // Save bank account details
  Future<void> saveBankDetails(Map<String, String> bankDetails) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyBankDetails, jsonEncode(bankDetails));
    print('💾 Bank details saved successfully');
  }

  // Get bank account details
  Future<Map<String, String>?> getBankDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final bankData = prefs.getString(_keyBankDetails);
    if (bankData != null) {
      final decoded = jsonDecode(bankData) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key, value.toString()));
    }
    return null;
  }

  Future<void> saveLoginData(LoginData loginData) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_keyAccessToken, loginData.accessToken);
    await prefs.setString(_keyUserRole, loginData.currentUserRole);
    await prefs.setString(_keyUserData, jsonEncode(_userToMap(loginData.user)));
    await prefs.setString(
      _keyEmployeeData,
      jsonEncode(_employeeToMap(loginData.employee)),
    );
    await prefs.setString(
      _keyCompanyData,
      jsonEncode(_companyToMap(loginData.company)),
    );
    await prefs.setString(
      _keyKycStatus,
      jsonEncode(_kycStatusToMap(loginData.kycStatus)),
    );

    print('💾 Login data saved successfully');
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken);
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserRole);
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_keyUserData);
    if (userData != null) {
      return jsonDecode(userData) as Map<String, dynamic>;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getEmployeeData() async {
    final prefs = await SharedPreferences.getInstance();
    final employeeData = prefs.getString(_keyEmployeeData);
    if (employeeData != null) {
      return jsonDecode(employeeData) as Map<String, dynamic>;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getCompanyData() async {
    final prefs = await SharedPreferences.getInstance();
    final companyData = prefs.getString(_keyCompanyData);
    if (companyData != null) {
      return jsonDecode(companyData) as Map<String, dynamic>;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getKycStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final kycStatus = prefs.getString(_keyKycStatus);
    if (kycStatus != null) {
      return jsonDecode(kycStatus) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> savePhoneNumber(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPhoneNumber, phoneNumber);
  }

  Future<String?> getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPhoneNumber);
  }

  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> saveLoginState({required bool isLoggedIn}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', isLoggedIn);
    print('💾 Login state saved: $isLoggedIn');
  }

  Future<bool> getLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  Future<void> clearLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_logged_in');
    print('🗑️ Login state cleared');
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('🗑️ All stored data cleared');
  }

  Map<String, dynamic> _userToMap(User user) {
    return {
      'user_id': user.userId,
      'first_name': user.firstName,
      'last_name': user.lastName,
      'phone_number': user.phoneNumber,
      'email': user.email,
      'is_phone_verified': user.isPhoneVerified,
      'is_email_verified': user.isEmailVerified,
      'is_active': user.isActive,
    };
  }

  Map<String, dynamic> _employeeToMap(Employee employee) {
    return {
      'employee_id': employee.employeeId,
      'employee_code': employee.employeeCode,
      'designation': employee.designation,
      'department': employee.department,
      'salary': employee.salary,
      'eligible_advance_limit': employee.eligibleAdvanceLimit,
      'is_active': employee.isActive,
    };
  }

  Map<String, dynamic> _companyToMap(Company company) {
    return {
      'company_id': company.companyId,
      'name': company.name,
      'code': company.code,
      'industry': company.industry,
    };
  }

  Map<String, dynamic> _kycStatusToMap(KycStatus kycStatus) {
    return {
      'steps': {
        'aadhaar_verified': kycStatus.steps.aadhaarVerified,
        'pan_verified': kycStatus.steps.panVerified,
        'address_proof_verified': kycStatus.steps.addressProofVerified,
        'bank_details_added': kycStatus.steps.bankDetailsAdded,
        'bank_verified': kycStatus.steps.bankVerified,
      },
      'overall_completion': kycStatus.overallCompletion,
      'required_steps': kycStatus.requiredSteps,
      'kyc_status': kycStatus.kycStatus,
    };
  }
}
