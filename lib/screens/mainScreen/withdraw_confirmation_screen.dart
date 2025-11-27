import 'package:flutter/material.dart';

/// Withdraw confirmation screen showing breakdown and repayment details
class WithdrawConfirmationScreen extends StatefulWidget {
  final double withdrawAmount;

  const WithdrawConfirmationScreen({super.key, required this.withdrawAmount});

  @override
  State<WithdrawConfirmationScreen> createState() =>
      _WithdrawConfirmationScreenState();
}

class _WithdrawConfirmationScreenState
    extends State<WithdrawConfirmationScreen> {
  bool _agreedToTerms = false;
  int _selectedAccountIndex = 0;

  // Mock data
  final List<Map<String, String>> _accounts = [
    {'bankName': 'HDFC Bank', 'accountNumber': '******5602'},
    {'bankName': 'SBI Bank', 'accountNumber': '******7890'},
  ];

  @override
  Widget build(BuildContext context) {
    // Calculate fees
    final double fees = 250.0;
    final double gst = fees * 0.18;
    final double totalReceived = widget.withdrawAmount - fees - gst;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Stack(
        children: [
          // Gradient background
          const Positioned.fill(child: _ConfirmationGradientBackground()),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const SizedBox(height: 10),

                // Main content
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
                      children: [
                        // Header
                        _buildHeader(context),

                        // Scrollable content
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),

                                // Amount breakdown card
                                _AmountBreakdownCard(
                                  earnedSalary: widget.withdrawAmount,
                                  fees: fees,
                                  gst: gst,
                                  totalReceived: totalReceived,
                                ),

                                const SizedBox(height: 16),

                                // Key Details button
                                _KeyDetailsButton(),

                                const SizedBox(height: 24),

                                // Receiving Account section
                                _ReceivingAccountSection(
                                  accounts: _accounts,
                                  selectedIndex: _selectedAccountIndex,
                                  onAccountSelected: (index) {
                                    setState(
                                      () => _selectedAccountIndex = index,
                                    );
                                  },
                                ),

                                const SizedBox(height: 24),

                                // Repayment Bank section
                                _RepaymentBankSection(
                                  amount: widget.withdrawAmount,
                                ),

                                const SizedBox(height: 24),

                                // Terms agreement checkbox
                                _TermsCheckbox(
                                  agreed: _agreedToTerms,
                                  onChanged: (value) {
                                    setState(() => _agreedToTerms = value!);
                                  },
                                ),

                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Withdraw button at bottom
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: _buildWithdrawButton(context),
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
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.arrow_back,
                size: 24,
                color: Color(0xFF101828),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Confirmation',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF101828),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWithdrawButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _agreedToTerms
                ? const [Color(0xFF532C8C), Color(0xFF171A58)]
                : [Colors.grey.shade400, Colors.grey.shade400],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(28),
        ),
        child: TextButton(
          onPressed: _agreedToTerms
              ? () {
                  // Handle withdraw action
                  _showSuccessDialog(context);
                }
              : null,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: const Text('Withdraw'),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: const Text(
          'Withdrawal request submitted successfully!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to withdraw screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// Amount breakdown card
class _AmountBreakdownCard extends StatelessWidget {
  final double earnedSalary;
  final double fees;
  final double gst;
  final double totalReceived;

  const _AmountBreakdownCard({
    required this.earnedSalary,
    required this.fees,
    required this.gst,
    required this.totalReceived,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          _buildRow('Earned Salary', earnedSalary, isBold: false),
          const SizedBox(height: 12),
          _buildRow('Fees', fees, isBold: false),
          const SizedBox(height: 12),
          _buildRow('GST 18%', gst, isBold: false),
          const Divider(height: 24, color: Color(0xFFE5E7EB)),
          _buildRow('Total amount received:', totalReceived, isBold: true),
        ],
      ),
    );
  }

  Widget _buildRow(String label, double amount, {required bool isBold}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: const Color(0xFF6B7280),
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            color: const Color(0xFF101828),
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Key Details button
class _KeyDetailsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Show key details
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF482983),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Key Details',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, size: 16, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

/// Receiving Account section
class _ReceivingAccountSection extends StatelessWidget {
  final List<Map<String, String>> accounts;
  final int selectedIndex;
  final Function(int) onAccountSelected;

  const _ReceivingAccountSection({
    required this.accounts,
    required this.selectedIndex,
    required this.onAccountSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Receiving Account',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF101828),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(accounts.length, (index) {
            final account = accounts[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => onAccountSelected(index),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.account_balance,
                        color: Color(0xFF3B82F6),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Acc No: ${account['accountNumber']}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                    Icon(
                      selectedIndex == index
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: selectedIndex == index
                          ? const Color(0xFF482983)
                          : const Color(0xFF9CA3AF),
                      size: 24,
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              // Add new bank account
            },
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Color(0xFF3B82F6),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Add New Bank Account',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF3B82F6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Repayment Bank section with table
class _RepaymentBankSection extends StatelessWidget {
  final double amount;

  const _RepaymentBankSection({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                'Repayment Bank',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF101828),
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.edit, size: 16, color: Color(0xFF6B7280)),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Current Month',
            style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 16),
          _buildRepaymentTable(),
        ],
      ),
    );
  }

  Widget _buildRepaymentTable() {
    return Column(
      children: [
        // Table header
        Row(
          children: const [
            Expanded(
              flex: 2,
              child: Text(
                'Month',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Principal',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Interest',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                'Total amount',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
            ),
          ],
        ),
        const Divider(height: 16, color: Color(0xFFE5E7EB)),
        // Table rows
        _buildTableRow('May', '₹1000.00', '0%', '₹1000.00'),
        const SizedBox(height: 8),
        _buildTableRow('May', '₹1000.00', '0%', '₹1000.00'),
        const SizedBox(height: 8),
        _buildTableRow('May', '₹1000.00', '0%', '₹1000.00'),
      ],
    );
  }

  Widget _buildTableRow(
    String month,
    String principal,
    String interest,
    String total,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            month,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            principal,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            interest,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            total,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),
        ),
      ],
    );
  }
}

/// Terms checkbox
class _TermsCheckbox extends StatelessWidget {
  final bool agreed;
  final Function(bool?) onChanged;

  const _TermsCheckbox({required this.agreed, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: agreed,
          activeColor: const Color(0xFF482983),
          onChanged: onChanged,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF374151),
                  height: 1.5,
                ),
                children: [
                  TextSpan(text: 'By continuing, you agree to the updated '),
                  TextSpan(
                    text: 'Webfino',
                    style: TextStyle(
                      color: Color(0xFF3B82F6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: ', '),
                  TextSpan(
                    text: 'KFS',
                    style: TextStyle(
                      color: Color(0xFF3B82F6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text:
                        ', declare that you are not a politically exposed person, and agree to get salary advance information and notifications through WhatsApp.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Gradient background
class _ConfirmationGradientBackground extends StatelessWidget {
  const _ConfirmationGradientBackground();

  @override
  Widget build(BuildContext context) {
    final double headerHeight = MediaQuery.of(context).size.height * 0.35;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: _ConfirmationWavePainter(headerHeight: headerHeight),
      ),
    );
  }
}

/// Custom wave painter
class _ConfirmationWavePainter extends CustomPainter {
  final double headerHeight;

  _ConfirmationWavePainter({required this.headerHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, headerHeight * 0.6)
      ..cubicTo(
        size.width * 0.2,
        headerHeight * 0.8,
        size.width * 0.55,
        headerHeight * 0.3,
        size.width,
        headerHeight * 0.6,
      )
      ..lineTo(size.width, 0)
      ..close();

    final Paint gradientPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF241E63), Color(0xFF482983)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, headerHeight));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, headerHeight * 0.4),
      gradientPaint,
    );
    canvas.drawPath(path, gradientPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
