import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_api_service.dart';

class AdvanceSalaryService {
  static const String baseUrl = 'https://api.webfino.com/api/v1';

  final String authToken;

  AdvanceSalaryService({required this.authToken});

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $authToken',
  };

  Future<AvailableAmountResponse> getAvailableAmount() async {
    try {
      final url = Uri.parse('$baseUrl/advance-salary/get/available/amount');
      print('🔍 Fetching Available Amount');
      print('📡 Request URL: $url');

      final response = await http.get(url, headers: _headers);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return AvailableAmountResponse.fromJson(jsonResponse);
      } else {
        final errorBody = jsonDecode(response.body);
        throw ApiException(
          errorBody['message'] ?? 'Failed to fetch available amount',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ Error in getAvailableAmount: $e');
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<SalaryBreakdownResponse> getSalaryBreakdown({
    required double amount,
  }) async {
    try {
      final url = Uri.parse(
        '$baseUrl/advance-salary/get/advance-salary/break-down?amount=$amount',
      );
      print('🔍 Fetching Salary Breakdown');
      print('📡 Request URL: $url');

      final response = await http.get(url, headers: _headers);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return SalaryBreakdownResponse.fromJson(jsonResponse);
      } else {
        final errorBody = jsonDecode(response.body);
        throw ApiException(
          errorBody['message'] ?? 'Failed to fetch salary breakdown',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ Error in getSalaryBreakdown: $e');
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<WithdrawResponse> withdrawAmount({
    required double amount,
    required bool haveUserLoanConsent,
    required bool haveDebitFreezeUserContent,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/advance-salary/withdraw/amount');
      final payload = {
        'amount': amount,
        'haveUserLoanConsent': haveUserLoanConsent,
        'haveDebitFreezeUserContent': haveDebitFreezeUserContent,
      };

      print('🔍 Requesting Withdrawal');
      print('📡 Request URL: $url');
      print('📤 Request payload: ${jsonEncode(payload)}');

      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(payload),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return WithdrawResponse.fromJson(jsonResponse);
      } else {
        final errorBody = jsonDecode(response.body);
        throw ApiException(
          errorBody['message'] ?? 'Failed to withdraw amount',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ Error in withdrawAmount: $e');
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<AllAdvanceSalariesResponse> getAllAdvanceSalaries({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final url = Uri.parse(
        '$baseUrl/advance-salary/get/all?page=$page&limit=$limit',
      );
      print('🔍 Fetching All Advance Salaries');
      print('📡 Request URL: $url');

      final response = await http.get(url, headers: _headers);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return AllAdvanceSalariesResponse.fromJson(jsonResponse);
      } else {
        final errorBody = jsonDecode(response.body);
        throw ApiException(
          errorBody['message'] ?? 'Failed to fetch advance salaries',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ Error in getAllAdvanceSalaries: $e');
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }
}

class AvailableAmountResponse {
  final int status;
  final String message;
  final AvailableAmountData data;

  AvailableAmountResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AvailableAmountResponse.fromJson(Map<String, dynamic> json) {
    return AvailableAmountResponse(
      status: json['status'],
      message: json['message'],
      data: AvailableAmountData.fromJson(json['data']),
    );
  }
}

class AvailableAmountData {
  final String employeeId;
  final String employeeName;
  final String companyName;
  final double salary;
  final double eligibleLimit;
  final double earnedSoFar;
  final double totalWithdrawnThisMonth;
  final double availableAmountLimit;
  final double minimumWithdrawLimit;
  final int numberOfLoansTakenThisMonth;

  AvailableAmountData({
    required this.employeeId,
    required this.employeeName,
    required this.companyName,
    required this.salary,
    required this.eligibleLimit,
    required this.earnedSoFar,
    required this.totalWithdrawnThisMonth,
    required this.availableAmountLimit,
    required this.minimumWithdrawLimit,
    required this.numberOfLoansTakenThisMonth,
  });

  factory AvailableAmountData.fromJson(Map<String, dynamic> json) {
    return AvailableAmountData(
      employeeId: json['employee_id'],
      employeeName: json['employee_name'],
      companyName: json['company_name'],
      salary: (json['salary'] as num).toDouble(),
      eligibleLimit: (json['eligible_limit'] as num).toDouble(),
      earnedSoFar: (json['earned_so_far'] as num).toDouble(),
      totalWithdrawnThisMonth: (json['total_withdrawn_this_month'] as num)
          .toDouble(),
      availableAmountLimit: (json['available_amount_limit'] as num).toDouble(),
      minimumWithdrawLimit: (json['minimum_withdraw_limit'] as num).toDouble(),
      numberOfLoansTakenThisMonth: json['number_of_loans_taken_this_month'],
    );
  }
}

class SalaryBreakdownResponse {
  final int status;
  final String message;
  final SalaryBreakdownData data;

  SalaryBreakdownResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SalaryBreakdownResponse.fromJson(Map<String, dynamic> json) {
    return SalaryBreakdownResponse(
      status: json['status'],
      message: json['message'],
      data: SalaryBreakdownData.fromJson(json['data']),
    );
  }
}

class SalaryBreakdownData {
  final double totalLoanAmount;
  final double totalLoanInterest;
  final double lenderInterestRate;
  final double platformInterestRate;
  final double gstRate;
  final double lenderInterestInAmount;
  final double platformInterestInAmount;
  final double gstAmount;
  final double userWillReceive;

  SalaryBreakdownData({
    required this.totalLoanAmount,
    required this.totalLoanInterest,
    required this.lenderInterestRate,
    required this.platformInterestRate,
    required this.gstRate,
    required this.lenderInterestInAmount,
    required this.platformInterestInAmount,
    required this.gstAmount,
    required this.userWillReceive,
  });

  factory SalaryBreakdownData.fromJson(Map<String, dynamic> json) {
    return SalaryBreakdownData(
      totalLoanAmount: (json['total_loan_amount'] as num).toDouble(),
      totalLoanInterest: (json['total_loan_interest'] as num).toDouble(),
      lenderInterestRate: (json['lender_interest_rate'] as num).toDouble(),
      platformInterestRate: (json['platform_interest_rate'] as num).toDouble(),
      gstRate: (json['gst_rate'] as num).toDouble(),
      lenderInterestInAmount: (json['lender_interest_in_amount'] as num)
          .toDouble(),
      platformInterestInAmount: (json['platform_interest_in_amount'] as num)
          .toDouble(),
      gstAmount: (json['gst_amount'] as num).toDouble(),
      userWillReceive: (json['user_will_receive'] as num).toDouble(),
    );
  }
}

class WithdrawResponse {
  final int status;
  final String message;
  final WithdrawData data;

  WithdrawResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory WithdrawResponse.fromJson(Map<String, dynamic> json) {
    return WithdrawResponse(
      status: json['status'],
      message: json['message'],
      data: WithdrawData.fromJson(json['data']),
    );
  }
}

class WithdrawData {
  final bool eligible;
  final String selectedLender;
  final double approvedAmount;
  final double userReceivedAmount;
  final double gstAmount;
  final double interestAmount;
  final double totalDeduction;
  final double earnedAsPlatform;
  final String loanStatus;

  WithdrawData({
    required this.eligible,
    required this.selectedLender,
    required this.approvedAmount,
    required this.userReceivedAmount,
    required this.gstAmount,
    required this.interestAmount,
    required this.totalDeduction,
    required this.earnedAsPlatform,
    required this.loanStatus,
  });

  factory WithdrawData.fromJson(Map<String, dynamic> json) {
    return WithdrawData(
      eligible: json['eligible'],
      selectedLender: json['selected_lender'],
      approvedAmount: (json['approved_amount'] as num).toDouble(),
      userReceivedAmount: (json['user_received_amount'] as num).toDouble(),
      gstAmount: (json['gst_amount'] as num).toDouble(),
      interestAmount: (json['interest_amount'] as num).toDouble(),
      totalDeduction: (json['total_deduction'] as num).toDouble(),
      earnedAsPlatform: (json['earned_as_platform'] as num).toDouble(),
      loanStatus: json['loan_status'],
    );
  }
}

// New models for getAllAdvanceSalaries API
class AllAdvanceSalariesResponse {
  final int status;
  final String message;
  final AllAdvanceSalariesData data;

  AllAdvanceSalariesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AllAdvanceSalariesResponse.fromJson(Map<String, dynamic> json) {
    return AllAdvanceSalariesResponse(
      status: json['status'],
      message: json['message'],
      data: AllAdvanceSalariesData.fromJson(json['data']),
    );
  }
}

class AllAdvanceSalariesData {
  final int total;
  final int page;
  final int limit;
  final List<AdvanceSalaryLoan> data;

  AllAdvanceSalariesData({
    required this.total,
    required this.page,
    required this.limit,
    required this.data,
  });

  factory AllAdvanceSalariesData.fromJson(Map<String, dynamic> json) {
    return AllAdvanceSalariesData(
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      data: (json['data'] as List)
          .map((item) => AdvanceSalaryLoan.fromJson(item))
          .toList(),
    );
  }
}

class AdvanceSalaryLoan {
  final String id;
  final String employeeId;
  final String companyId;
  final String loanId;
  final String lenderId;
  final String lenderName;
  final double requestedLoanAmount;
  final double totalDisbursedLoanAmount;
  final double totalLoanPercentage;
  final double totalLoanInterestInAmount;
  final double lenderInterestPercentage;
  final double lenderInterestInAmount;
  final double platformInterestPercentage;
  final double platformInterestInAmount;
  final double gstPercentage;
  final double gstAmount;
  final double userReceivedLoanAmountAfterDeduction;
  final double earnedAsPlatform;
  final String loanStatus;
  final int disbursedMonth;
  final int disbursedYear;
  final CompanyDetails companyDetails;
  final bool autoApproved;
  final bool isDeleted;
  final String createdAt;

  AdvanceSalaryLoan({
    required this.id,
    required this.employeeId,
    required this.companyId,
    required this.loanId,
    required this.lenderId,
    required this.lenderName,
    required this.requestedLoanAmount,
    required this.totalDisbursedLoanAmount,
    required this.totalLoanPercentage,
    required this.totalLoanInterestInAmount,
    required this.lenderInterestPercentage,
    required this.lenderInterestInAmount,
    required this.platformInterestPercentage,
    required this.platformInterestInAmount,
    required this.gstPercentage,
    required this.gstAmount,
    required this.userReceivedLoanAmountAfterDeduction,
    required this.earnedAsPlatform,
    required this.loanStatus,
    required this.disbursedMonth,
    required this.disbursedYear,
    required this.companyDetails,
    required this.autoApproved,
    required this.isDeleted,
    required this.createdAt,
  });

  factory AdvanceSalaryLoan.fromJson(Map<String, dynamic> json) {
    return AdvanceSalaryLoan(
      id: json['_id'],
      employeeId: json['employee_id'],
      companyId: json['company_id'],
      loanId: json['loan_id'],
      lenderId: json['lender_id'],
      lenderName: json['lender_name'],
      requestedLoanAmount: (json['requested_loan_amount'] as num).toDouble(),
      totalDisbursedLoanAmount: (json['total_disbursed_loan_amount'] as num)
          .toDouble(),
      totalLoanPercentage: (json['total_loan_percentage'] as num).toDouble(),
      totalLoanInterestInAmount: (json['total_loan_interest_in_amount'] as num)
          .toDouble(),
      lenderInterestPercentage: (json['lender_interest_percentage'] as num)
          .toDouble(),
      lenderInterestInAmount: (json['lender_interest_in_amount'] as num)
          .toDouble(),
      platformInterestPercentage: (json['platform_interest_percentage'] as num)
          .toDouble(),
      platformInterestInAmount: (json['platform_interest_in_amount'] as num)
          .toDouble(),
      gstPercentage: (json['gst_percentage'] as num).toDouble(),
      gstAmount: (json['gst_amount'] as num).toDouble(),
      userReceivedLoanAmountAfterDeduction:
          (json['user_received_loan_amount_after_deduction'] as num).toDouble(),
      earnedAsPlatform: (json['earned_as_platform'] as num).toDouble(),
      loanStatus: json['loan_status'],
      disbursedMonth: json['disbursed_month'],
      disbursedYear: json['disbursed_year'],
      companyDetails: CompanyDetails.fromJson(json['company_details']),
      autoApproved: json['auto_approved'],
      isDeleted: json['is_deleted'],
      createdAt: json['created_at'],
    );
  }
}

class CompanyDetails {
  final String name;
  final double totalPayable;
  final String billingMonth;
  final bool billGenerated;
  final bool billPaid;
  final String billDueDate;
  final double companyPaidForThisLoanTillNow;

  CompanyDetails({
    required this.name,
    required this.totalPayable,
    required this.billingMonth,
    required this.billGenerated,
    required this.billPaid,
    required this.billDueDate,
    required this.companyPaidForThisLoanTillNow,
  });

  factory CompanyDetails.fromJson(Map<String, dynamic> json) {
    return CompanyDetails(
      name: json['name'],
      totalPayable: (json['total_payable'] as num).toDouble(),
      billingMonth: json['billing_month'],
      billGenerated: json['bill_generated'],
      billPaid: json['bill_paid'],
      billDueDate: json['bill_due_date'],
      companyPaidForThisLoanTillNow:
          (json['company_paid_for_this_loan_till_now'] as num).toDouble(),
    );
  }
}
