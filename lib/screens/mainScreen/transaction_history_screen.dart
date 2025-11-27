import 'package:flutter/material.dart';


/// Transaction History screen showing all user transactions
class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String _selectedFilter = 'Completed';
  String _selectedPeriod = 'This week';
  int? _expandedTransactionIndex; // Track which transaction is expanded


  final List<Map<String, dynamic>> _transactions = [
    {
      'title': 'On-Demand salary',
      'transactionId': '698094554317',
      'amount': 5600.00,
      'status': 'Completed',
      'date': '17 Sep 2023',
      'time': '11:21 AM',
    },
    {
      'title': 'On-Demand salary',
      'transactionId': '698094554317',
      'amount': 5600.00,
      'status': 'Completed',
      'date': '17 Sep 2025',
      'time': '11:21 AM',
    },
    {
      'title': 'On-Demand salary',
      'transactionId': '698094554317',
      'amount': 5600.00,
      'status': 'Completed',
      'date': '17 Sep 2025',
      'time': '11:21 AM',
    },
    {
      'title': 'On-Demand salary',
      'transactionId': '698094554317',
      'amount': 5600.00,
      'status': 'Completed',
      'date': '17 Sep 2025',
      'time': '11:21 AM',
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                        // Header (now inside white container)
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
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            itemCount: _transactions.length,
                            itemBuilder: (context, index) {
                              final transaction = _transactions[index];
                              
                              // Show date header
                              bool showDateHeader = index == 0 ||
                                  _transactions[index - 1]['date'] !=
                                      transaction['date'];

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (showDateHeader) ...[
                                    if (index != 0) const SizedBox(height: 16),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: Text(
                                        transaction['date'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ),
                                  ],
                                  _buildTransactionItem(transaction),
                                ],
                              );
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
          // Search icon
          GestureDetector(
            onTap: () {
              // Handle search
            },
            child: const Icon(
              Icons.search,
              size: 24,
              color: Color(0xFF101828),
            ),
          ),
          const SizedBox(width: 16),
          // Filter icon
          GestureDetector(
            onTap: () {
              _showFilterBottomSheet(context);
            },
            child: const Icon(
              Icons.tune,
              size: 24,
              color: Color(0xFF101828),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FilterBottomSheet(
        selectedPeriod: _selectedPeriod,
        onApplyFilters: (period, statusFilters) {
          setState(() {
            _selectedPeriod = period;
          });
        },
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
    final filters = ['Completed', 'My loan', 'Gold', 'Payment'];

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

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final index = _transactions.indexOf(transaction);
    final isExpanded = _expandedTransactionIndex == index;

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
                  decoration: BoxDecoration(
                    color: const Color(0xFF482983),
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
                      Text(
                        transaction['title'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF101828),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Transaction ID',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF98A2B3),
                        ),
                      ),
                      Text(
                        transaction['transactionId'],
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
                      '₹${transaction['amount'].toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF101828),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1FAE5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        transaction['status'],
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF059669),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${transaction['date']} ${transaction['time']}',
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
                  'Salary Advance Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF101828),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Early Salary',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Details rows
              _buildDetailRow('Loan Amount', '₹ 2,373.00'),
              const SizedBox(height: 8),
              _buildDetailRow('Due: Sep 1, 2025', 'Auto Pay', 
                  valueColor: const Color(0xFF482983)),
              const SizedBox(height: 8),
              _buildDetailRow('Fee (Incl. GST)', '₹ 42.00'),
              const SizedBox(height: 8),
              _buildDetailRow('Amount You\'ll Receive', '₹ 2,331.00',
                  valueColor: const Color(0xFF10B981)),
              const SizedBox(height: 8),
              _buildDetailRow('Tenure', '1 Month'),
              const SizedBox(height: 8),
              _buildDetailRow('Repayment Date', 'As Per Schedule'),

              const SizedBox(height: 20),

              // Repayment Schedule
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Repayment Schedule',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF101828),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color:
                            const Color(0xFF482983).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.calendar_month,
                        color: Color(0xFF482983),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Repayment',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Dec 1',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF101828),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      '₹ 2,373.00',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF101828),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Late Payment Charges
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFBBF24)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text(
                          'Late Payment Charges',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFD97706),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildWarningItem(
                      'Rate of annualized penal charges in case of delayed payment is 36% per annum for each day of delay',
                    ),
                    const SizedBox(height: 6),
                    _buildWarningItem(
                      'On Late Payment there will be charge of ₹500/- per late payment OR dishonor of Cheque/ECS/NACH',
                    ),
                  ],
                ),
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
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF6B7280),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? const Color(0xFF101828),
          ),
        ),
      ],
    );
  }

  Widget _buildWarningItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFD97706),
            size: 14,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF92400E),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

/// Filter Bottom Sheet
class _FilterBottomSheet extends StatefulWidget {
  final String selectedPeriod;
  final Function(String period, List<String> statusFilters) onApplyFilters;

  const _FilterBottomSheet({
    required this.selectedPeriod,
    required this.onApplyFilters,
  });

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  late String _selectedPeriod;
  late List<String> _selectedStatuses;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _selectedPeriod = widget.selectedPeriod;
    _selectedStatuses = ['Completed'];
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filters',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF101828),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedPeriod = 'This week';
                    _selectedStatuses = ['Completed'];
                    _startDate = null;
                    _endDate = null;
                  });
                },
                child: const Text(
                  'Clear',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF482983),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Period section
          const Text(
            'Period',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF101828),
            ),
          ),

          const SizedBox(height: 12),

          // Period options
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: ['This week', 'This month', 'Previous month', 'This year']
                .map((period) {
              final isSelected = _selectedPeriod == period;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedPeriod = period);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFEDE9FE)
                        : const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF482983)
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
                  child: Text(
                    period,
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

          const SizedBox(height: 20),

          // Select period label
          const Text(
            'Select period',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),

          const SizedBox(height: 12),

          // Date range pickers
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _startDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() => _startDate = date);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 16, color: Color(0xFF6B7280)),
                        const SizedBox(width: 8),
                        Text(
                          _startDate != null
                              ? _formatDate(_startDate!)
                              : '1 Sep 2024',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF101828),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.arrow_forward,
                    size: 16, color: Color(0xFF6B7280)),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _endDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() => _endDate = date);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 16, color: Color(0xFF6B7280)),
                        const SizedBox(width: 8),
                        Text(
                          _endDate != null
                              ? _formatDate(_endDate!)
                              : '20 Sep 2024',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF101828),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Status section
          const Text(
            'Status',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF101828),
            ),
          ),

          const SizedBox(height: 12),

          // Status options
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: ['Completed', 'Pending', 'Canceled'].map((status) {
              final isSelected = _selectedStatuses.contains(status);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedStatuses.remove(status);
                    } else {
                      _selectedStatuses.add(status);
                    }
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFEDE9FE)
                        : const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF482983)
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
                  child: Text(
                    status,
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

          const SizedBox(height: 32),

          // Show results button
          SizedBox(
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF532C8C), Color(0xFF171A58)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: TextButton(
                onPressed: () {
                  widget.onApplyFilters(_selectedPeriod, _selectedStatuses);
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: Text('Show results (${_selectedStatuses.length})'),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
