class CheckPhoneRequest {
  final String phoneNumber;

  CheckPhoneRequest({required this.phoneNumber});

  Map<String, dynamic> toJson() => {'phoneNumber': phoneNumber};
}

class CheckPhoneResponse {
  final int status;
  final String message;
  final CheckPhoneData data;

  CheckPhoneResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CheckPhoneResponse.fromJson(Map<String, dynamic> json) {
    return CheckPhoneResponse(
      status: json['status'] as int,
      message: json['message'] as String,
      data: CheckPhoneData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class CheckPhoneData {
  final bool userExists;
  final String? userId;
  final bool requiresRegistration;
  final String nextStep;

  CheckPhoneData({
    required this.userExists,
    this.userId,
    required this.requiresRegistration,
    required this.nextStep,
  });

  factory CheckPhoneData.fromJson(Map<String, dynamic> json) {
    return CheckPhoneData(
      userExists: json['user_exists'] as bool,
      userId: json['user_id'] as String?,
      requiresRegistration: json['requires_registration'] as bool,
      nextStep: json['next_step'] as String,
    );
  }
}

class SendOtpRequest {
  final String phoneNumber;

  SendOtpRequest({required this.phoneNumber});

  Map<String, dynamic> toJson() => {'phoneNumber': phoneNumber};
}

class SendOtpResponse {
  final int status;
  final String message;
  final SendOtpData data;

  SendOtpResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) {
    return SendOtpResponse(
      status: json['status'] as int,
      message: json['message'] as String,
      data: SendOtpData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class SendOtpData {
  final String otp;
  final String expiresIn;
  final String nextStep;

  SendOtpData({
    required this.otp,
    required this.expiresIn,
    required this.nextStep,
  });

  factory SendOtpData.fromJson(Map<String, dynamic> json) {
    return SendOtpData(
      otp: json['otp'] as String,
      expiresIn: json['expires_in'] as String,
      nextStep: json['next_step'] as String,
    );
  }
}

class VerifyOtpRequest {
  final String phoneNumber;
  final String otp;

  VerifyOtpRequest({required this.phoneNumber, required this.otp});

  Map<String, dynamic> toJson() => {'phoneNumber': phoneNumber, 'otp': otp};
}

class VerifyOtpResponse {
  final int status;
  final String message;
  final LoginData data;

  VerifyOtpResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      status: json['status'] as int,
      message: json['message'] as String,
      data: LoginData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class LoginData {
  final String accessToken;
  final String currentUserRole;
  final User user;
  final Employee employee;
  final Company company;
  final KycStatus kycStatus;
  final AppAccess appAccess;

  LoginData({
    required this.accessToken,
    required this.currentUserRole,
    required this.user,
    required this.employee,
    required this.company,
    required this.kycStatus,
    required this.appAccess,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      accessToken: json['access_token'] as String,
      currentUserRole: json['current_user_role'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      employee: Employee.fromJson(json['employee'] as Map<String, dynamic>),
      company: Company.fromJson(json['company'] as Map<String, dynamic>),
      kycStatus: KycStatus.fromJson(json['kyc_status'] as Map<String, dynamic>),
      appAccess: AppAccess.fromJson(json['app_access'] as Map<String, dynamic>),
    );
  }
}

class User {
  final String userId;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final bool isPhoneVerified;
  final bool isEmailVerified;
  final bool isActive;

  User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.isPhoneVerified,
    required this.isEmailVerified,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      phoneNumber: json['phone_number'] as String,
      email: json['email'] as String,
      isPhoneVerified: json['is_phone_verified'] as bool,
      isEmailVerified: json['is_email_verified'] as bool,
      isActive: json['is_active'] as bool,
    );
  }
}

class Employee {
  final String employeeId;
  final String employeeCode;
  final String designation;
  final String department;
  final double salary;
  final double eligibleAdvanceLimit;
  final bool isActive;

  Employee({
    required this.employeeId,
    required this.employeeCode,
    required this.designation,
    required this.department,
    required this.salary,
    required this.eligibleAdvanceLimit,
    required this.isActive,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      employeeId: json['employee_id'] as String,
      employeeCode: json['employee_code'] as String,
      designation: json['designation'] as String,
      department: json['department'] as String,
      salary: (json['salary'] as num).toDouble(),
      eligibleAdvanceLimit: (json['eligible_advance_limit'] as num).toDouble(),
      isActive: json['is_active'] as bool,
    );
  }
}

class Company {
  final String companyId;
  final String name;
  final String code;
  final String industry;

  Company({
    required this.companyId,
    required this.name,
    required this.code,
    required this.industry,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      companyId: json['company_id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      industry: json['industry'] as String,
    );
  }
}

class KycStatus {
  final KycSteps steps;
  final int overallCompletion;
  final List<String> requiredSteps;
  final String kycStatus;

  KycStatus({
    required this.steps,
    required this.overallCompletion,
    required this.requiredSteps,
    required this.kycStatus,
  });

  factory KycStatus.fromJson(Map<String, dynamic> json) {
    return KycStatus(
      steps: KycSteps.fromJson(json['steps'] as Map<String, dynamic>),
      overallCompletion: json['overall_completion'] as int,
      requiredSteps: (json['required_steps'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      kycStatus: json['kyc_status'] as String,
    );
  }
}

class KycSteps {
  final bool aadhaarVerified;
  final bool panVerified;
  final bool addressProofVerified;
  final bool bankDetailsAdded;
  final bool bankVerified;

  KycSteps({
    required this.aadhaarVerified,
    required this.panVerified,
    required this.addressProofVerified,
    required this.bankDetailsAdded,
    required this.bankVerified,
  });

  factory KycSteps.fromJson(Map<String, dynamic> json) {
    return KycSteps(
      aadhaarVerified: json['aadhaar_verified'] as bool,
      panVerified: json['pan_verified'] as bool,
      addressProofVerified: json['address_proof_verified'] as bool,
      bankDetailsAdded: json['bank_details_added'] as bool,
      bankVerified: json['bank_verified'] as bool,
    );
  }
}

class AppAccess {
  final bool canAccessApp;

  AppAccess({required this.canAccessApp});

  factory AppAccess.fromJson(Map<String, dynamic> json) {
    return AppAccess(canAccessApp: json['can_access_app'] as bool);
  }
}
