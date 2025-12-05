import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_api_service.dart';

class KycApiService {
  static const String baseUrl = 'https://api.webfino.com/api/v1';

  final String authToken;

  KycApiService({required this.authToken});

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $authToken',
  };

  Future<AadhaarVerificationResponse> verifyAadhaar({
    required String aadhaarNumber,
    required String aadhaarName,
    required String dateOfBirth,
    required String address,
    bool isVerified = true,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/employee/my/kyc/aadhaar');
      final payload = {
        'aadhaar_number': aadhaarNumber,
        'aadhaar_name': aadhaarName,
        'date_of_birth': dateOfBirth,
        'address': address,
        'is_verified': isVerified,
      };

      print('🔍 Verifying Aadhaar');
      print('📡 Request URL: $url');
      print('📤 Request payload: ${jsonEncode(payload)}');

      final response = await http.put(
        url,
        headers: _headers,
        body: jsonEncode(payload),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return AadhaarVerificationResponse.fromJson(jsonResponse);
      } else {
        final errorBody = jsonDecode(response.body);
        throw ApiException(
          errorBody['message'] ?? 'Failed to verify Aadhaar',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ Error in verifyAadhaar: $e');
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<PanVerificationResponse> verifyPan({
    required String panNumber,
    required String panName,
    required String dateOfBirth,
    bool isVerified = true,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/employee/my/kyc/pan');
      final payload = {
        'pan_number': panNumber,
        'pan_name': panName,
        'date_of_birth': dateOfBirth,
        'is_verified': isVerified,
      };

      print('🔍 Verifying PAN');
      print('📡 Request URL: $url');
      print('📤 Request payload: ${jsonEncode(payload)}');

      final response = await http.put(
        url,
        headers: _headers,
        body: jsonEncode(payload),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return PanVerificationResponse.fromJson(jsonResponse);
      } else {
        final errorBody = jsonDecode(response.body);
        throw ApiException(
          errorBody['message'] ?? 'Failed to verify PAN',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ Error in verifyPan: $e');
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<BankVerificationResponse> verifyBank({
    required String accountHolderName,
    required String accountNumber,
    required String ifscCode,
    required String bankName,
    required String branchName,
    required String accountType,
    bool isVerified = true,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/employee/my/bank');
      final payload = {
        'account_holder_name': accountHolderName,
        'account_number': accountNumber,
        'ifsc_code': ifscCode,
        'bank_name': bankName,
        'branch_name': branchName,
        'account_type': accountType,
        'is_verified': isVerified,
      };

      print('🔍 Verifying Bank Account');
      print('📡 Request URL: $url');
      print('📤 Request payload: ${jsonEncode(payload)}');

      final response = await http.put(
        url,
        headers: _headers,
        body: jsonEncode(payload),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return BankVerificationResponse.fromJson(jsonResponse);
      } else {
        final errorBody = jsonDecode(response.body);
        throw ApiException(
          errorBody['message'] ?? 'Failed to verify bank account',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ Error in verifyBank: $e');
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }
}

class AadhaarVerificationResponse {
  final int status;
  final String message;
  final AadhaarVerificationData data;

  AadhaarVerificationResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AadhaarVerificationResponse.fromJson(Map<String, dynamic> json) {
    return AadhaarVerificationResponse(
      status: json['status'],
      message: json['message'],
      data: AadhaarVerificationData.fromJson(json['data']),
    );
  }
}

class AadhaarVerificationData {
  final bool aadhaarVerified;
  final String kycStatus;
  final String nextStep;
  final bool canProceed;

  AadhaarVerificationData({
    required this.aadhaarVerified,
    required this.kycStatus,
    required this.nextStep,
    required this.canProceed,
  });

  factory AadhaarVerificationData.fromJson(Map<String, dynamic> json) {
    return AadhaarVerificationData(
      aadhaarVerified: json['aadhaar_verified'],
      kycStatus: json['kyc_status'],
      nextStep: json['next_step'],
      canProceed: json['can_proceed'],
    );
  }
}

class PanVerificationResponse {
  final int status;
  final String message;
  final PanVerificationData data;

  PanVerificationResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PanVerificationResponse.fromJson(Map<String, dynamic> json) {
    return PanVerificationResponse(
      status: json['status'],
      message: json['message'],
      data: PanVerificationData.fromJson(json['data']),
    );
  }
}

class PanVerificationData {
  final bool panVerified;
  final String kycStatus;
  final String nextStep;
  final bool canProceed;

  PanVerificationData({
    required this.panVerified,
    required this.kycStatus,
    required this.nextStep,
    required this.canProceed,
  });

  factory PanVerificationData.fromJson(Map<String, dynamic> json) {
    return PanVerificationData(
      panVerified: json['pan_verified'],
      kycStatus: json['kyc_status'],
      nextStep: json['next_step'],
      canProceed: json['can_proceed'],
    );
  }
}

class BankVerificationResponse {
  final int status;
  final String message;
  final BankVerificationData data;

  BankVerificationResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BankVerificationResponse.fromJson(Map<String, dynamic> json) {
    return BankVerificationResponse(
      status: json['status'],
      message: json['message'],
      data: BankVerificationData.fromJson(json['data']),
    );
  }
}

class BankVerificationData {
  final bool bankVerified;
  final String verificationMessage;
  final String kycStatus;
  final bool canAccessApp;
  final String nextStep;

  BankVerificationData({
    required this.bankVerified,
    required this.verificationMessage,
    required this.kycStatus,
    required this.canAccessApp,
    required this.nextStep,
  });

  factory BankVerificationData.fromJson(Map<String, dynamic> json) {
    return BankVerificationData(
      bankVerified: json['bank_verified'],
      verificationMessage: json['verification_message'],
      kycStatus: json['kyc_status'],
      canAccessApp: json['can_access_app'],
      nextStep: json['next_step'],
    );
  }
}
