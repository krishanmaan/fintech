import 'package:flutter/material.dart';
import 'withdraw_confirmation_screen.dart';
import '../../services/storage_service.dart';
import '../../services/advance_salary_service.dart';

/// Withdraw money screen with beautiful gradient header and triangle design
class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  double _withdrawalAmount = 2000.0; // Will be updated after API call
  double _minAmount = 2000.0;
  double _maxAmount = 50000.0; // Default fallback
  double _availableLimit = 0.0;
  bool _showNoteBanner = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAvailableAmount();
  }

  Future<void> _fetchAvailableAmount() async {
    try {
      final storageService = StorageService();
      final token = await storageService.getAccessToken();

      if (token == null) {
        throw Exception('Not authenticated');
      }

      final service = AdvanceSalaryService(authToken: token);
      final response = await service.getAvailableAmount();

      if (mounted) {
        setState(() {
          _minAmount = response.data.minimumWithdrawLimit;
          _maxAmount = response.data.availableAmountLimit;
          _availableLimit = response.data.availableAmountLimit;

          // Ensure withdrawal amount is within valid range
          if (_withdrawalAmount > _maxAmount) {
            _withdrawalAmount = _maxAmount;
          }
          if (_withdrawalAmount < _minAmount) {
            _withdrawalAmount = _minAmount;
          }

          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Stack(
        children: [
          // Gradient background with curved triangle design
          const Positioned.fill(child: _WithdrawGradientBackground()),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const SizedBox(height: 10),

                // Main content with header inside
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
                        // Header with back button and title (on white background)
                        _buildHeader(context),

                        // Scrollable content
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),

                                // Note banner
                                if (_showNoteBanner)
                                  _NoteBanner(
                                    availableLimit: _availableLimit,
                                    onDismiss: () =>
                                        setState(() => _showNoteBanner = false),
                                  ),

                                const SizedBox(height: 20),

                                // Withdrawal amount card (Purple)
                                _WithdrawalAmountCard(
                                  amount: _withdrawalAmount,
                                  minAmount: _minAmount,
                                  maxAmount: _maxAmount,
                                  onAmountChanged: (value) {
                                    setState(() => _withdrawalAmount = value);
                                  },
                                ),

                                const SizedBox(height: 16),

                                // Promotional banner (Yellow)
                                const _PromoBanner(),

                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Continue button at bottom
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
                    child: _buildContinueButton(context),
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
          // Back button - dark color for white background
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

          // Title - dark color for white background
          const Text(
            'Withdraw money',
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

  Widget _buildContinueButton(BuildContext context) {
    return SizedBox(
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
            // Navigate to confirmation screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WithdrawConfirmationScreen(
                  withdrawAmount: _withdrawalAmount,
                ),
              ),
            );
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: const Text('Continue'),
        ),
      ),
    );
  }
}

/// Note banner dismissible component
class _NoteBanner extends StatelessWidget {
  const _NoteBanner({required this.onDismiss, required this.availableLimit});

  final VoidCallback onDismiss;
  final double availableLimit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Text(
            'Note: ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF101828),
            ),
          ),
          Expanded(
            child: Text(
              'Your available withdrawal limit is ₹${availableLimit.toStringAsFixed(0)}. Limits are determined by your employer.',
              style: const TextStyle(fontSize: 14, color: Color(0xFF7D8CA1)),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onDismiss,
            child: const Icon(Icons.close, size: 20, color: Color(0xFF7D8CA1)),
          ),
        ],
      ),
    );
  }
}

/// Purple card with withdrawal amount and slider
class _WithdrawalAmountCard extends StatelessWidget {
  const _WithdrawalAmountCard({
    required this.amount,
    required this.minAmount,
    required this.maxAmount,
    required this.onAmountChanged,
  });

  final double amount;
  final double minAmount;
  final double maxAmount;
  final ValueChanged<double> onAmountChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF482983),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Enter withdrawal amount',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 16),

          // Amount with edit icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹${amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Edit amount functionality
                },
                child: Icon(
                  Icons.edit_outlined,
                  size: 20,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Slider
          Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
                  thumbColor: Colors.white,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 10,
                  ),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: amount,
                  min: minAmount,
                  max: maxAmount,
                  onChanged: onAmountChanged,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹${minAmount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  Text(
                    '₹${maxAmount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Quick selection buttons - Dynamic based on limits
          Builder(
            builder: (context) {
              final range = maxAmount - minAmount;
              double amount1, amount2, amount3;

              if (range < 5000) {
                amount1 = minAmount;
                amount2 = (minAmount + maxAmount) / 2;
                amount3 = maxAmount;
              } else {
                amount1 = minAmount;
                amount2 =
                    (((minAmount + maxAmount) / 2) / 1000).round() * 1000.0;
                amount3 = ((maxAmount * 0.8) / 1000).round() * 1000.0;

                if (amount2 < minAmount) amount2 = minAmount;
                if (amount2 > maxAmount) amount2 = maxAmount;
                if (amount3 < minAmount) amount3 = minAmount;
                if (amount3 > maxAmount) amount3 = maxAmount;
              }

              return Row(
                children: [
                  Expanded(
                    child: _QuickAmountButton(
                      amount: amount1,
                      onTap: () => onAmountChanged(amount1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickAmountButton(
                      amount: amount2,
                      onTap: () => onAmountChanged(amount2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickAmountButton(
                      amount: amount3,
                      onTap: () => onAmountChanged(amount3),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 20),

          // See Breakdown button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                // Navigate to breakdown screen
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'See Breakdown',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Quick amount selection button
class _QuickAmountButton extends StatelessWidget {
  const _QuickAmountButton({required this.amount, required this.onTap});

  final double amount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '₹${amount.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Promotional banner (Yellow/Orange)
class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFFFC400), Color(0xFFFF9500)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Need more money?',
                  style: TextStyle(fontSize: 14, color: Color(0xFF482983)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Get up to ₹ 50000',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF482983),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Easy Tenures | Completely Online.',
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFF482983).withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 12),
                // Apply offer button
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD000),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Apply offer',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Goddess Durga illustration (placeholder)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.celebration,
              size: 40,
              color: Color(0xFF482983),
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------- GRADIENT BACKGROUND WITH TRIANGLE DESIGN --------------------------
class _WithdrawGradientBackground extends StatelessWidget {
  const _WithdrawGradientBackground();

  @override
  Widget build(BuildContext context) {
    final double headerHeight = MediaQuery.of(context).size.height * 0.35;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: _WithdrawWavePainter(headerHeight: headerHeight),
      ),
    );
  }
}

/// ------------------- CUSTOM WAVE PAINTER WITH TRIANGLE --------------------------
/// Triangle design jaise aadhaar_verify_identity_screen me use hua hai
class _WithdrawWavePainter extends CustomPainter {
  final double headerHeight;

  _WithdrawWavePainter({required this.headerHeight});

  @override
  void paint(Canvas canvas, Size size) {
    // Triangle wave path - same as aadhaar screen
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

    // Gradient paint - Purple gradient
    final Paint gradientPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF241E63), Color(0xFF482983)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, headerHeight));

    // Draw solid rectangle first
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, headerHeight * 0.4),
      gradientPaint,
    );

    // Draw curved triangle path
    canvas.drawPath(path, gradientPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
