import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_models.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class AuthApiService {
  static const String baseUrl = 'https://api.webfino.com/api/v1';

  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
  };

  Future<CheckPhoneResponse> checkPhone(String phoneNumber) async {
    try {
      final url = Uri.parse('$baseUrl/auth/check-phone');
      final request = CheckPhoneRequest(phoneNumber: phoneNumber);

      print('🔍 Checking phone: $phoneNumber');
      print('📡 Request URL: $url');
      print('📤 Request payload: ${jsonEncode(request.toJson())}');

      final response = await http.post(
        url,
        headers: _defaultHeaders,
        body: jsonEncode(request.toJson()),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return CheckPhoneResponse.fromJson(jsonResponse);
      } else {
        final errorBody = jsonDecode(response.body);
        throw ApiException(
          errorBody['message'] ?? 'Failed to check phone number',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ Error in checkPhone: $e');
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<SendOtpResponse> sendOtp(String phoneNumber) async {
    try {
      final url = Uri.parse('$baseUrl/auth/send-otp');
      final request = SendOtpRequest(phoneNumber: phoneNumber);

      print('📲 Sending OTP to: $phoneNumber');
      print('📡 Request URL: $url');
      print('📤 Request payload: ${jsonEncode(request.toJson())}');

      final response = await http.post(
        url,
        headers: _defaultHeaders,
        body: jsonEncode(request.toJson()),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return SendOtpResponse.fromJson(jsonResponse);
      } else {
        final errorBody = jsonDecode(response.body);
        throw ApiException(
          errorBody['message'] ?? 'Failed to send OTP',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ Error in sendOtp: $e');
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<VerifyOtpResponse> verifyOtp(String phoneNumber, String otp) async {
    try {
      final url = Uri.parse('$baseUrl/auth/verify-otp');
      final request = VerifyOtpRequest(phoneNumber: phoneNumber, otp: otp);

      print('✅ Verifying OTP for: $phoneNumber');
      print('📡 Request URL: $url');
      print('📤 Request payload: ${jsonEncode(request.toJson())}');

      final response = await http.post(
        url,
        headers: _defaultHeaders,
        body: jsonEncode(request.toJson()),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return VerifyOtpResponse.fromJson(jsonResponse);
      } else {
        final errorBody = jsonDecode(response.body);
        throw ApiException(
          errorBody['message'] ?? 'Failed to verify OTP',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ Error in verifyOtp: $e');
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }
}
