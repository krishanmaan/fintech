import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

/// Explore Cards Screen - EMI Calculator with visual breakdown
class ExploreCardsScreen extends StatefulWidget {
  const ExploreCardsScreen({super.key});

  @override
  State<ExploreCardsScreen> createState() => _ExploreCardsScreenState();
}

class _ExploreCardsScreenState extends State<ExploreCardsScreen>
    with SingleTickerProviderStateMixin {
  double _loanAmount = 50000;
  double _interestRate = 8.0;
  int _loanTenure = 10; // in years

  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _progressAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // EMI Calculation: [P x R x (1+R)^N]/[(1+R)^N-1]
  double _calculateEMI() {
    final p = _loanAmount;
    final r = _interestRate / (12 * 100); // Monthly interest rate
    final n = _loanTenure * 12; // Number of months

    if (r == 0) return p / n;

    final emi = (p * r * math.pow(1 + r, n)) / (math.pow(1 + r, n) - 1);
    return emi;
  }

  double _calculateTotalAmount() {
    final emi = _calculateEMI();
    final n = _loanTenure * 12;
    return emi * n;
  }

  double _calculateTotalInterest() {
    return _calculateTotalAmount() - _loanAmount;
  }

  // Calculate percentages for the chart
  Map<String, double> _getBreakdown() {
    final totalAmount = _calculateTotalAmount();
    final interest = _calculateTotalInterest();

    // Assuming taxes = 25.2% and others = 8.3% of total for visual purposes
    final taxes = totalAmount * 0.252;
    final others = totalAmount * 0.083;

    return {
      'interest': (interest / totalAmount) * 100,
      'taxes': (taxes / totalAmount) * 100,
      'others': (others / totalAmount) * 100,
    };
  }

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
                        // Header
                        _buildHeader(context),

                        // Scrollable content
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                _buildEMIChart(),
                                const SizedBox(height: 24),
                                _buildEMICalculatorCard(),
                                const SizedBox(height: 16),
                                _buildInstantEMICard(),
                                const SizedBox(height: 32),
                                _buildExploreFeaturesSection(),
                                const SizedBox(height: 24),
                              ],
                            ),
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
          // Calculator Icon
          SvgPicture.string(_calculatorIconSvg, width: 45, height: 45),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'EMI Calc',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF101828),
              ),
            ),
          ),
          // Notification Icon
          SvgPicture.string(_notificationIconSvg, width: 26, height: 26),
          const SizedBox(width: 16),
          // Menu Icon
          SvgPicture.string(_menuIconSvg, width: 26, height: 26),
        ],
      ),
    );
  }

  // SVG Icons
  static const String _calculatorIconSvg = '''
<svg width="45" height="45" viewBox="0 0 45 45" fill="none" xmlns="http://www.w3.org/2000/svg">
<rect x="0.525724" y="0.525724" width="43.1093" height="43.1093" rx="12.0916" fill="#FAF5FF"/>
<rect x="0.525724" y="0.525724" width="43.1093" height="43.1093" rx="12.0916" stroke="#F3E8FF" stroke-width="1.05145"/>
<path d="M27.3377 13.3184H16.8232C15.8554 13.3184 15.0708 14.1029 15.0708 15.0708V29.0901C15.0708 30.0579 15.8554 30.8425 16.8232 30.8425H27.3377C28.3055 30.8425 29.0901 30.0579 29.0901 29.0901V15.0708C29.0901 14.1029 28.3055 13.3184 27.3377 13.3184Z" stroke="#482983" stroke-width="1.75241" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M18.5757 16.8231H25.5853" stroke="#482983" stroke-width="1.75241" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M25.5854 23.8328V27.3376" stroke="#482983" stroke-width="1.75241" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M25.5854 20.328H25.5938" stroke="#482983" stroke-width="1.75241" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M22.0806 20.328H22.0889" stroke="#482983" stroke-width="1.75241" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M18.5757 20.328H18.584" stroke="#482983" stroke-width="1.75241" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M22.0806 23.8328H22.0889" stroke="#482983" stroke-width="1.75241" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M18.5757 23.8328H18.584" stroke="#482983" stroke-width="1.75241" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M22.0806 27.3376H22.0889" stroke="#482983" stroke-width="1.75241" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M18.5757 27.3376H18.584" stroke="#482983" stroke-width="1.75241" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  static const String _notificationIconSvg = '''
<svg width="26" height="26" viewBox="0 0 26 26" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M10.7964 22.0804C10.981 22.4001 11.2464 22.6655 11.5661 22.8501C11.8858 23.0346 12.2484 23.1318 12.6175 23.1318C12.9866 23.1318 13.3492 23.0346 13.6689 22.8501C13.9886 22.6655 14.254 22.4001 14.4386 22.0804" stroke="#9CA3AF" stroke-width="2.10289" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M3.42998 16.1145C3.29263 16.265 3.20198 16.4523 3.16907 16.6534C3.13616 16.8545 3.16241 17.0608 3.24462 17.2473C3.32683 17.4338 3.46146 17.5924 3.63213 17.7037C3.8028 17.8151 4.00216 17.8745 4.20595 17.8746H21.0291C21.2329 17.8747 21.4323 17.8155 21.6031 17.7044C21.7738 17.5932 21.9086 17.4348 21.9911 17.2485C22.0735 17.0621 22.1 16.8558 22.0673 16.6547C22.0347 16.4536 21.9443 16.2663 21.8072 16.1155C20.4087 14.674 18.9262 13.142 18.9262 8.41159C18.9262 6.73842 18.2615 5.13378 17.0784 3.95068C15.8953 2.76757 14.2907 2.10291 12.6175 2.10291C10.9444 2.10291 9.33972 2.76757 8.15662 3.95068C6.97351 5.13378 6.30885 6.73842 6.30885 8.41159C6.30885 13.142 4.82525 14.674 3.42998 16.1145Z" stroke="#9CA3AF" stroke-width="2.10289" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  static const String _menuIconSvg = '''
<svg width="26" height="26" viewBox="0 0 26 26" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M4.20557 5.2572H21.0287" stroke="#9CA3AF" stroke-width="2.10289" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M4.20557 12.6173H21.0287" stroke="#9CA3AF" stroke-width="2.10289" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M4.20557 19.9775H21.0287" stroke="#9CA3AF" stroke-width="2.10289" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  Widget _buildEMIChart() {
    final totalAmount = _calculateTotalAmount();
    final breakdown = _getBreakdown();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: const Border(
          top: BorderSide(color: Color(0xFF482983), width: 3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Circular Chart
          SizedBox(
            height: 200,
            width: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Animated circular progress
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      size: const Size(200, 200),
                      painter: _EMIChartPainter(
                        breakdown: breakdown,
                        progress: _progressAnimation.value,
                      ),
                    );
                  },
                ),
                // Center text
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'TOTAL LOAN AMOUNT',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF98A2B3),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹${(totalAmount / 100000).toStringAsFixed(1)}L',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF101828),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem(
                '${breakdown['interest']!.toStringAsFixed(1)}%',
                'Interest',
                const Color(0xFF5F60EC),
              ),
              _buildLegendItem(
                '${breakdown['taxes']!.toStringAsFixed(1)}%',
                'Tenure',
                const Color(0xFFE03C89),
              ),
              _buildLegendItem(
                '${breakdown['others']!.toStringAsFixed(1)}%',
                'Amount',
                const Color(0xFFECA017),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String percentage, String label, Color color) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              percentage,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF101828),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xFF98A2B3),
          ),
        ),
      ],
    );
  }

  Widget _buildEMICalculatorCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF482983), Color(0xFF6B3E9F)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF482983).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calculate_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EMI Calculator',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Calculate your monthly payments',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Loan Amount Slider
          _buildSlider(
            label: 'Loan Amount',
            value: _loanAmount,
            min: 10000,
            max: 1000000,
            divisions: 99,
            displayValue: '₹ ${_loanAmount.toStringAsFixed(0)}',
            onChanged: (value) {
              setState(() {
                _loanAmount = value;
                _animationController.forward(from: 0);
              });
            },
          ),
          const SizedBox(height: 24),

          // Interest Rate Slider
          _buildSlider(
            label: 'Rate of Interest',
            value: _interestRate,
            min: 1.0,
            max: 20.0,
            divisions: 190,
            displayValue: '${_interestRate.toStringAsFixed(1)}%',
            onChanged: (value) {
              setState(() {
                _interestRate = value;
                _animationController.forward(from: 0);
              });
            },
          ),
          const SizedBox(height: 24),

          // Loan Tenure Slider
          _buildSlider(
            label: 'Loan Tenure',
            value: _loanTenure.toDouble(),
            min: 1,
            max: 30,
            divisions: 29,
            displayValue: '$_loanTenure years',
            onChanged: (value) {
              setState(() {
                _loanTenure = value.toInt();
                _animationController.forward(from: 0);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String displayValue,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            Text(
              displayValue,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
            thumbColor: Colors.white,
            overlayColor: Colors.white.withValues(alpha: 0.2),
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 2),
            activeTickMarkColor: Colors.white.withValues(alpha: 0.5),
            inactiveTickMarkColor: Colors.white.withValues(alpha: 0.3),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildInstantEMICard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8B5CF6), Color(0xFF6B3E9F)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.flash_on, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Instant EMI Check',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Get your interest rates instantly',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white.withValues(alpha: 0.8),
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildExploreFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Explore Features',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF101828),
          ),
        ),
        const SizedBox(height: 16),
        _buildDigitalGoldCard(),
        const SizedBox(height: 12),
        _buildCIBILScoreCard(),
        const SizedBox(height: 12),
        _buildPersonalLoanCard(),
        const SizedBox(height: 12),
        _buildFixedDepositCard(),
        const SizedBox(height: 12),
        _buildPrepaidCard(),
      ],
    );
  }

  Widget _buildDigitalGoldCard() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFB84D), Color(0xFFFF9F1C)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Content on the left
          Positioned(
            left: 20,
            top: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Top Rated',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Digital Gold',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Start investing with as low as\n₹1. Secure your future.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'italic',
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          // Icon at bottom right
          Positioned(
            right: 0,
            bottom: 0,
            child: SvgPicture.string(_goldCoinsSvg, width: 150, height: 150),
          ),
        ],
      ),
    );
  }

  Widget _buildCIBILScoreCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'FREE CHECK',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'CIBIL Score',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Detailed credit report analysis',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SvgPicture.string(_creditScoreSvg, width: 80, height: 80),
        ],
      ),
    );
  }

  Widget _buildPersonalLoanCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF10B981), Color(0xFF059669)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'FAST CASH',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Personal Loan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Instant approval for EMIs.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SvgPicture.string(_cashCardSvg, width: 80, height: 80),
        ],
      ),
    );
  }

  Widget _buildFixedDepositCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6B3E9F), Color(0xFF482983)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'HIGH RETURNS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Fixed Deposit',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Grow savings securely with up to\n7% p.a.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SvgPicture.string(_piggyBankSvg, width: 80, height: 80),
        ],
      ),
    );
  }

  Widget _buildPrepaidCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFCE7F3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.credit_card,
              color: Color(0xFFEC4899),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Prepaid Card',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF101828),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Easy payments & cashback',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          SvgPicture.string(_prepaidCardSvg, width: 60, height: 60),
        ],
      ),
    );
  }

  // Feature Card SVG Icons
  static const String _goldCoinsSvg = '''
<svg width="154" height="121" viewBox="0 0 154 121" fill="none" xmlns="http://www.w3.org/2000/svg">
<g filter="url(#filter0_d_1527_541)">
<path d="M128.4 103.4C143.864 103.4 156.4 90.8639 156.4 75.3999C156.4 59.9359 143.864 47.3999 128.4 47.3999C112.936 47.3999 100.4 59.9359 100.4 75.3999C100.4 90.8639 112.936 103.4 128.4 103.4Z" fill="#F59E0B" stroke="#B45309" stroke-width="1.12"/>
<path d="M128.4 97.8C140.771 97.8 150.8 87.7712 150.8 75.4C150.8 63.0288 140.771 53 128.4 53C116.029 53 106 63.0288 106 75.4C106 87.7712 116.029 97.8 128.4 97.8Z" stroke="white" stroke-opacity="0.4" stroke-width="2.24"/>
<path d="M89.2002 114.6C104.664 114.6 117.2 102.064 117.2 86.6001C117.2 71.1361 104.664 58.6001 89.2002 58.6001C73.7362 58.6001 61.2002 71.1361 61.2002 86.6001C61.2002 102.064 73.7362 114.6 89.2002 114.6Z" fill="#FBBF24" stroke="#D97706" stroke-width="1.12"/>
<path d="M89.1998 109C101.571 109 111.6 98.9711 111.6 86.6C111.6 74.2288 101.571 64.2 89.1998 64.2C76.8286 64.2 66.7998 74.2288 66.7998 86.6C66.7998 98.9711 76.8286 109 89.1998 109Z" stroke="white" stroke-opacity="0.4" stroke-width="2.24"/>
<path d="M111.6 134.76C128.92 134.76 142.96 120.72 142.96 103.4C142.96 86.0804 128.92 72.04 111.6 72.04C94.2806 72.04 80.2402 86.0804 80.2402 103.4C80.2402 120.72 94.2806 134.76 111.6 134.76Z" fill="#FFD700" stroke="#B45309" stroke-width="1.12"/>
<path d="M111.6 128.04C125.209 128.04 136.24 117.008 136.24 103.4C136.24 89.7917 125.209 78.76 111.6 78.76C97.9922 78.76 86.9604 89.7917 86.9604 103.4C86.9604 117.008 97.9922 128.04 111.6 128.04Z" stroke="white" stroke-opacity="0.5" stroke-width="2.24"/>
<path d="M108.24 94.4399L114.96 103.4L108.24 112.36" stroke="#B45309" stroke-width="2.24" stroke-linecap="round" stroke-linejoin="round"/>
<path opacity="0.3" d="M111.6 134.76C128.92 134.76 142.96 120.72 142.96 103.4C142.96 86.0804 128.92 72.04 111.6 72.04C94.2806 72.04 80.2402 86.0804 80.2402 103.4C80.2402 120.72 94.2806 134.76 111.6 134.76Z" fill="url(#paint0_linear_1527_541)"/>
</g>
<defs>
<filter id="filter0_d_1527_541" x="0" y="0" width="212" height="212" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
<feFlood flood-opacity="0" result="BackgroundImageFix"/>
<feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
<feOffset dy="25"/>
<feGaussianBlur stdDeviation="25"/>
<feColorMatrix type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.15 0"/>
<feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_1527_541"/>
<feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_1527_541" result="shape"/>
</filter>
<linearGradient id="paint0_linear_1527_541" x1="80.2402" y1="72.04" x2="142.96" y2="134.76" gradientUnits="userSpaceOnUse">
<stop stop-color="white" stop-opacity="0.8"/>
<stop offset="1" stop-color="white" stop-opacity="0"/>
</linearGradient>
</defs>
</svg>
''';

  static const String _creditScoreSvg = '''
<svg width="80" height="80" viewBox="0 0 80 80" fill="none" xmlns="http://www.w3.org/2000/svg">
<circle cx="40" cy="40" r="30" fill="white" opacity="0.2"/>
<path d="M25 50 L35 40 L45 45 L55 30" stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<circle cx="55" cy="30" r="3" fill="white"/>
<text x="40" y="48" text-anchor="middle" fill="white" font-size="14" font-weight="bold">750+</text>
</svg>
''';

  static const String _cashCardSvg = '''
<svg width="80" height="80" viewBox="0 0 80 80" fill="none" xmlns="http://www.w3.org/2000/svg">
<rect x="15" y="25" width="50" height="30" rx="4" fill="white" opacity="0.3"/>
<rect x="20" y="30" width="45" height="25" rx="3" fill="white"/>
<rect x="25" y="40" width="15" height="10" rx="2" fill="#10B981"/>
<line x1="45" y1="42" x2="50" y2="42" stroke="#10B981" stroke-width="2"/>
<line x1="45" y1="47" x2="50" y2="47" stroke="#10B981" stroke-width="2"/>
</svg>
''';

  static const String _piggyBankSvg = '''
<svg width="80" height="80" viewBox="0 0 80 80" fill="none" xmlns="http://www.w3.org/2000/svg">
<circle cx="40" cy="42" r="20" fill="white" opacity="0.3"/>
<ellipse cx="40" cy="45" rx="22" ry="18" fill="white"/>
<circle cx="35" cy="40" r="2" fill="#482983"/>
<path d="M50 38 L58 35" stroke="white" stroke-width="2" stroke-linecap="round"/>
<rect x="35" y="60" width="3" height="8" rx="1.5" fill="white"/>
<rect x="42" y="60" width="3" height="8" rx="1.5" fill="white"/>
</svg>
''';

  static const String _prepaidCardSvg = '''
<svg width="60" height="60" viewBox="0 0 60 60" fill="none" xmlns="http://www.w3.org/2000/svg">
<rect x="10" y="20" width="40" height="25" rx="3" fill="#EC4899"/>
<rect x="10" y="25" width="40" height="5" fill="#BE185D"/>
<circle cx="20" cy="35" r="3" fill="#FDE68A"/>
<rect x="28" y="33" width="15" height="2" rx="1" fill="white"/>
<rect x="28" y="37" width="10" height="2" rx="1" fill="white"/>
</svg>
''';
}

/// Custom painter for the EMI breakdown chart
class _EMIChartPainter extends CustomPainter {
  final Map<String, double> breakdown;
  final double progress;

  _EMIChartPainter({required this.breakdown, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const strokeWidth = 35.0;

    // Background circle
    final bgPaint = Paint()
      ..color = const Color(0xFFF3F4F6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Draw segments
    double startAngle = -math.pi / 2; // Start from top

    // Interest segment (purple)
    final interestAngle =
        (breakdown['interest']! / 100) * 2 * math.pi * progress;
    _drawSegment(
      canvas,
      center,
      radius,
      startAngle,
      interestAngle,
      const Color(0xFF8B5CF6),
      strokeWidth,
    );
    startAngle += interestAngle;

    // Taxes segment (orange)
    final taxesAngle = (breakdown['taxes']! / 100) * 2 * math.pi * progress;
    _drawSegment(
      canvas,
      center,
      radius,
      startAngle,
      taxesAngle,
      const Color(0xFFF97316),
      strokeWidth,
    );
    startAngle += taxesAngle;

    // Others segment (yellow)
    final othersAngle = (breakdown['others']! / 100) * 2 * math.pi * progress;
    _drawSegment(
      canvas,
      center,
      radius,
      startAngle,
      othersAngle,
      const Color(0xFFECA017),
      strokeWidth,
    );
  }

  void _drawSegment(
    Canvas canvas,
    Offset center,
    double radius,
    double startAngle,
    double sweepAngle,
    Color color,
    double strokeWidth,
  ) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(_EMIChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.breakdown != breakdown;
  }
}

/// Animation widget for fade in and slide up effect
class FadeInSlide extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;

  const FadeInSlide({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
  });

  @override
  State<FadeInSlide> createState() => _FadeInSlideState();
}

class _FadeInSlideState extends State<FadeInSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}
