# API Implementation Guide - Developer Mode

## Overview
This document explains the complete authentication API implementation for the fintech app.

## API Endpoints Implemented

### 1. Check Phone API
**Endpoint:** `POST https://api.webfino.com/api/v1/auth/check-phone`

**Request:**
```json
{
  "phoneNumber": "9988776655"
}
```

**Response:**
```json
{
  "status": 200,
  "message": "User found",
  "data": {
    "user_exists": true,
    "user_id": "692f197242d124dbf8a22fcd",
    "requires_registration": false,
    "next_step": "SEND_OTP"
  }
}
```

### 2. Send OTP API
**Endpoint:** `POST https://api.webfino.com/api/v1/auth/send-otp`

**Request:**
```json
{
  "phoneNumber": "9988776655"
}
```

**Response:**
```json
{
  "status": 200,
  "message": "OTP sent successfully",
  "data": {
    "otp": "569930",
    "expires_in": "10 minutes",
    "next_step": "VERIFY_OTP"
  }
}
```

### 3. Verify OTP API
**Endpoint:** `POST https://api.webfino.com/api/v1/auth/verify-otp`

**Request:**
```json
{
  "phoneNumber": "9988776655",
  "otp": "569930"
}
```

**Response:**
```json
{
  "status": 200,
  "message": "Login successful",
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "current_user_role": "EMPLOYEE",
    "user": {
      "user_id": "692f197242d124dbf8a22fcd",
      "first_name": "Rajesh",
      "last_name": "Kumar",
      "phone_number": "9988776655",
      "email": "rajesh.kumar@techcorp.com",
      "is_phone_verified": true,
      "is_email_verified": false,
      "is_active": true
    },
    "employee": {
      "employee_id": "692f197242d124dbf8a22fcf",
      "employee_code": "EMP001",
      "designation": "Senior Software Engineer",
      "department": "Engineering",
      "salary": 80000,
      "eligible_advance_limit": 60000,
      "is_active": true
    },
    "company": {
      "company_id": "692f183942d124dbf8a22fbb",
      "name": "TechCorp Solutions Pvt Ltd",
      "code": "TECHCORP001",
      "industry": "IT Services"
    },
    "kyc_status": {
      "steps": {
        "aadhaar_verified": false,
        "pan_verified": false,
        "address_proof_verified": false,
        "bank_details_added": false,
        "bank_verified": false
      },
      "overall_completion": 0,
      "required_steps": [
        "Complete Aadhaar verification via DigiLocker API",
        "Complete PAN verification via government API",
        "Add bank account details",
        "Complete bank account verification"
      ],
      "kyc_status": "PENDING"
    },
    "app_access": {
      "can_access_app": false
    }
  }
}
```

## File Structure

```
lib/
├── models/
│   └── auth_models.dart          # All data models for API requests/responses
├── services/
│   ├── auth_api_service.dart     # API service for authentication
│   └── storage_service.dart      # Local storage for tokens and user data
├── screens/
│   └── accountScreen/
│       ├── login_screen.dart             # Login screen with phone input
│       └── otp_verification_screen.dart  # OTP verification screen
└── utils/
    └── api_test_helper.dart      # Testing utility for API debugging
```

## Implementation Details

### 1. Data Models (`lib/models/auth_models.dart`)
Complete type-safe models for:
- `CheckPhoneRequest` / `CheckPhoneResponse`
- `SendOtpRequest` / `SendOtpResponse`
- `VerifyOtpRequest` / `VerifyOtpResponse`
- All nested models: `User`, `Employee`, `Company`, `KycStatus`, etc.

### 2. Auth API Service (`lib/services/auth_api_service.dart`)
Features:
- ✅ HTTP client using `http` package
- ✅ Comprehensive error handling with `ApiException`
- ✅ Detailed console logging for debugging
- ✅ JSON serialization/deserialization
- ✅ Three main methods:
  - `checkPhone(phoneNumber)`
  - `sendOtp(phoneNumber)`
  - `verifyOtp(phoneNumber, otp)`

### 3. Storage Service (`lib/services/storage_service.dart`)
Features:
- ✅ Uses `shared_preferences` for local persistence
- ✅ Stores access token, user data, employee data, company data
- ✅ Helper methods to retrieve stored data
- ✅ `isLoggedIn()` check
- ✅ `clearAll()` for logout

### 4. Login Screen (`lib/screens/accountScreen/login_screen.dart`)
Features:
- ✅ Phone number input with validation
- ✅ Loading state with spinner
- ✅ Error message display
- ✅ "Remember me" checkbox
- ✅ Calls `checkPhone` → `sendOtp` APIs
- ✅ Shows OTP in SnackBar (developer mode)
- ✅ Navigates to OTP screen with phone number and OTP

### 5. OTP Verification Screen (`lib/screens/accountScreen/otp_verification_screen.dart`)
Features:
- ✅ 6-digit OTP input fields
- ✅ Auto-focus to next field
- ✅ Displays OTP in developer mode
- ✅ Verify button calls `verifyOtp` API
- ✅ Resend OTP functionality
- ✅ Saves login data to local storage
- ✅ Navigates to next screen on success

## Developer Mode Features

### 1. Console Logging
All API calls log:
- 📡 Request URL
- 📤 Request payload
- 📥 Response status
- 📥 Response body
- ✅/❌ Success/Error indicators

### 2. OTP Display
- OTP is shown in SnackBar after sending
- OTP is displayed on verification screen
- Format: "DEV MODE: OTP is XXXXXX"

### 3. Error Messages
- Network errors
- API errors with status codes
- Validation errors
- User-friendly error messages in UI

## How to Test

### Using the App:
1. Run the app: `flutter run`
2. Navigate to Login screen
3. Enter phone number: `9988776655`
4. Click "Log In"
5. Check console for API logs
6. Note the OTP from SnackBar
7. Enter OTP on verification screen
8. Click "Verify"
9. Check console for complete user data

### Using Test Helper:
```dart
import 'package:fintech/utils/api_test_helper.dart';

// In your code
final tester = ApiTestHelper();

// Test individual APIs
await tester.testCheckPhone('9988776655');
await tester.testSendOtp('9988776655');
await tester.testVerifyOtp('9988776655', '569930');

// Test complete flow
await tester.testFullAuthFlow('9988776655');

// Check stored data
await tester.checkStoredData();
```

## Error Handling

### Network Errors
```dart
try {
  await authService.checkPhone(phoneNumber);
} on ApiException catch (e) {
  print('API Error: ${e.message}');
  print('Status Code: ${e.statusCode}');
} catch (e) {
  print('Network Error: $e');
}
```

### Common Errors:
- **No Internet**: "Network error: ..."
- **Invalid Phone**: API returns error message
- **Invalid OTP**: API returns "Invalid OTP"
- **Expired OTP**: API returns "OTP expired"

## Next Steps

### 1. Add Logout Functionality
```dart
await storageService.clearAll();
// Navigate to login screen
```

### 2. Add Auto-Login Check
```dart
// In main.dart or splash screen
final isLoggedIn = await storageService.isLoggedIn();
if (isLoggedIn) {
  // Navigate to home screen
} else {
  // Navigate to login screen
}
```

### 3. Add Token Refresh
```dart
// Implement token refresh before expiry
// Check JWT expiry and refresh token
```

### 4. Add Authenticated Requests
```dart
Future<Response> makeAuthenticatedRequest(String url) async {
  final token = await storageService.getAccessToken();
  return await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );
}
```

## Dependencies Added

```yaml
dependencies:
  http: ^1.1.0              # For API calls
  shared_preferences: ^2.2.2 # For local storage
```

## API Base URL
```dart
static const String baseUrl = 'https://api.webfino.com/api/v1';
```

## Security Notes

⚠️ **Developer Mode Features** (Remove in production):
- OTP displayed in console logs
- OTP shown in SnackBar
- OTP displayed on screen
- Detailed API logging

🔒 **Production Checklist**:
- [ ] Remove all OTP display features
- [ ] Remove console.log statements
- [ ] Add request timeout handling
- [ ] Implement rate limiting
- [ ] Add biometric authentication
- [ ] Encrypt stored tokens
- [ ] Implement certificate pinning
- [ ] Add request/response encryption

## Troubleshooting

### Issue: API not responding
**Solution:** Check internet connection, verify API URL

### Issue: OTP not received
**Solution:** Check phone number format, check API response in console

### Issue: Invalid OTP error
**Solution:** Ensure OTP is correct, check if OTP expired

### Issue: Data not persisting
**Solution:** Check SharedPreferences initialization, verify storage permissions

## Contact
For API issues or questions, contact the backend team or refer to API documentation.
