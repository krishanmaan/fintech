import 'package:flutter/material.dart';
import '../../services/storage_service.dart';
import '../../services/advance_salary_service.dart';

/// Transaction History screen showing all user transactions with real API data
class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String _selectedFilter = 'All';
  final String _selectedPeriod = 'This month';
  int? _expandedTransactionIndex;

  // API related state
  bool _isLoading = true;
  List<AdvanceSalaryLoan> _loans = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final storageService = StorageService();
      final token = await storageService.getAccessToken();

      if (token == null) {
        throw Exception('Not authenticated. Please login again.');
      }

      final service = AdvanceSalaryService(authToken: token);
      final response = await service.getAllAdvanceSalaries(page: 1, limit: 50);

      if (mounted) {
        setState(() {
          _loans = response.data.data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        String errorMsg = e.toString();

        // Better error message for 401
        if (errorMsg.contains('401') || errorMsg.contains('blocked')) {
          errorMsg = 'Your session has expired. Please logout and login again.';
        } else if (errorMsg.contains('Not authenticated')) {
          errorMsg = 'Please login to view transactions.';
        }

        setState(() {
          _isLoading = false;
          _errorMessage = errorMsg;
        });
      }
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:${date.minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    // Show loading state
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Show error state
    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(_errorMessage!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchTransactions,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Purple gradient header
          Container(
            height: 120,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF241E63), Color(0xFF482983)],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Main content with header
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        _buildHeader(context),

                        const SizedBox(height: 20),

                        // Period filter
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: _buildPeriodFilter(),
                        ),

                        const SizedBox(height: 16),

                        // Category filters
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: _buildCategoryFilters(),
                        ),

                        const SizedBox(height: 16),

                        // Transaction list
                        Expanded(
                          child: _loans.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No transactions found',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  itemCount: _loans.length,
                                  itemBuilder: (context, index) {
                                    final loan = _loans[index];
                                    return _buildTransactionItem(loan, index);
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              size: 24,
              color: Color(0xFF101828),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Transaction History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF101828),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE9FE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _selectedPeriod,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Color(0xFF482983),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    final filters = ['All', 'Disbursed', 'Pending'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFEDE9FE) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF482983)
                      : const Color(0xFFE5E7EB),
                ),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFF482983)
                      : const Color(0xFF6B7280),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTransactionItem(AdvanceSalaryLoan loan, int index) {
    final isExpanded = _expandedTransactionIndex == index;

    // Format date and time
    final date = DateTime.parse(loan.createdAt);
    final formattedDate = _formatDate(date);
    final formattedTime = _formatTime(date);

    return GestureDetector(
      onTap: () {
        setState(() {
          _expandedTransactionIndex = isExpanded ? null : index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF3F4F6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rupee icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Color(0xFF482983),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.currency_rupee,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Transaction details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Advance Salary',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF101828),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        loan.lenderName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF98A2B3),
                        ),
                      ),
                      Text(
                        'Loan ID: ...${loan.loanId.substring(loan.loanId.length - 8)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),

                // Amount and status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${loan.requestedLoanAmount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF101828),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: loan.loanStatus == 'DISBURSED'
                            ? const Color(0xFFD1FAE5)
                            : const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        loan.loanStatus,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: loan.loanStatus == 'DISBURSED'
                              ? const Color(0xFF059669)
                              : const Color(0xFFDC2626),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$formattedDate $formattedTime',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF98A2B3),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // View details link
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                isExpanded ? 'Hide details' : 'View details',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF482983),
                ),
              ),
            ),

            // Expandable details section
            if (isExpanded) ...[
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFE5E7EB)),
              const SizedBox(height: 16),

              // Salary Advance Details
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Loan Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF101828),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Details rows
              _buildDetailRow(
                'Loan Amount',
                '₹ ${loan.totalDisbursedLoanAmount.toStringAsFixed(0)}',
              ),
              const SizedBox(height: 8),
              _buildDetailRow(
                'Interest',
                '₹ ${loan.totalLoanInterestInAmount.toStringAsFixed(0)}',
              ),
              const SizedBox(height: 8),
              _buildDetailRow('GST', '₹ ${loan.gstAmount.toStringAsFixed(0)}'),
              const SizedBox(height: 8),
              _buildDetailRow(
                'Amount You Received',
                '₹ ${loan.userReceivedLoanAmountAfterDeduction.toStringAsFixed(0)}',
                valueColor: const Color(0xFF10B981),
              ),
              const SizedBox(height: 8),
              _buildDetailRow('Company', loan.companyDetails.name),
              const SizedBox(height: 8),
              _buildDetailRow(
                'Billing Month',
                loan.companyDetails.billingMonth,
              ),
              const SizedBox(height: 8),
              _buildDetailRow(
                'Company Payable',
                '₹ ${loan.companyDetails.totalPayable.toStringAsFixed(0)}',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? const Color(0xFF101828),
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
