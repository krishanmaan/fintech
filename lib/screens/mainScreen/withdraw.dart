import 'package:flutter/material.dart';
import '../../utils/responsive.dart';

/// Withdraw money screen jo user ko paise withdraw karne ki facility deti hai.
class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  double _withdrawalAmount = 5600.0;
  final double _minAmount = 500.0;
  final double _maxAmount = 5600.0;
  bool _showNoteBanner = true;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: Stack(
        children: [
          // Gradient background (EmployeeIdScreen jaisa)
          const Positioned.fill(child: _WithdrawGradientBackground()),
          
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Header with back button and title
                _Header(responsive: responsive),
                
                // Note banner
                if (_showNoteBanner) _NoteBanner(
                  responsive: responsive,
                  onDismiss: () => setState(() => _showNoteBanner = false),
                ),
                
                // Main scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: responsive.padding(24)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: responsive.height(20)),
                        
                        // Withdrawal amount card (Purple)
                        _WithdrawalAmountCard(
                          responsive: responsive,
                          amount: _withdrawalAmount,
                          minAmount: _minAmount,
                          maxAmount: _maxAmount,
                          onAmountChanged: (value) {
                            setState(() => _withdrawalAmount = value);
                          },
                        ),
                        
                        SizedBox(height: responsive.height(16)),
                        
                        // Promotional banner (Yellow)
                        _PromoBanner(responsive: responsive),
                        
                        SizedBox(height: responsive.height(20)),
                      ],
                    ),
                  ),
                ),
                
                // Continue button at bottom
                Container(
                  padding: EdgeInsets.all(responsive.padding(24)),
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
                    child: _ContinueButton(responsive: responsive),
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

/// Header with back button and title
/// Gradient background ke upar white color me dikhna chahiye
class _Header extends StatelessWidget {
  const _Header({required this.responsive});

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.padding(24),
        vertical: responsive.height(16),
      ),
      child: Row(
        children: [
          // Back button - white color gradient background ke liye
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(responsive.width(8)),
              child: Icon(
                Icons.arrow_back,
                size: responsive.width(24),
                color: Colors.white,
              ),
            ),
          ),
          
          SizedBox(width: responsive.width(16)),
          
          // Title - white color gradient background ke liye
          Text(
            'Withdraw money',
            style: TextStyle(
              fontSize: responsive.fontSize(20),
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// Note banner jo dismiss ho sakta hai
class _NoteBanner extends StatelessWidget {
  const _NoteBanner({
    required this.responsive,
    required this.onDismiss,
  });

  final Responsive responsive;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: responsive.padding(24)),
      padding: EdgeInsets.all(responsive.padding(16)),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(responsive.radius(12)),
      ),
      child: Row(
        children: [
          Text(
            'Note: ',
            style: TextStyle(
              fontSize: responsive.fontSize(14),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF101828),
            ),
          ),
          Expanded(
            child: Text(
              'Your withdrawal limit may differ from your actual salary, as determined by your employer.',
              style: TextStyle(
                fontSize: responsive.fontSize(14),
                color: const Color(0xFF7D8CA1),
              ),
            ),
          ),
          SizedBox(width: responsive.width(8)),
          GestureDetector(
            onTap: onDismiss,
            child: Icon(
              Icons.close,
              size: responsive.width(20),
              color: const Color(0xFF7D8CA1),
            ),
          ),
        ],
      ),
    );
  }
}

/// Purple card with withdrawal amount and slider
class _WithdrawalAmountCard extends StatelessWidget {
  const _WithdrawalAmountCard({
    required this.responsive,
    required this.amount,
    required this.minAmount,
    required this.maxAmount,
    required this.onAmountChanged,
  });

  final Responsive responsive;
  final double amount;
  final double minAmount;
  final double maxAmount;
  final ValueChanged<double> onAmountChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(responsive.padding(20)),
      decoration: BoxDecoration(
        color: const Color(0xFF482983),
        borderRadius: BorderRadius.circular(responsive.radius(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Enter withdrawal amount',
            style: TextStyle(
              fontSize: responsive.fontSize(16),
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          
          SizedBox(height: responsive.height(16)),
          
          // Amount with edit icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹${amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: responsive.fontSize(32),
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
                  size: responsive.width(20),
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          
          SizedBox(height: responsive.height(24)),
          
          // Slider
          Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
                  thumbColor: Colors.white,
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: responsive.width(10),
                  ),
                  trackHeight: responsive.height(4),
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
                      fontSize: responsive.fontSize(12),
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  Text(
                    '₹${maxAmount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: responsive.fontSize(12),
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          SizedBox(height: responsive.height(20)),
          
          // Quick selection buttons
          Row(
            children: [
              Expanded(
                child: _QuickAmountButton(
                  responsive: responsive,
                  amount: 1000,
                  onTap: () => onAmountChanged(1000),
                ),
              ),
              SizedBox(width: responsive.width(12)),
              Expanded(
                child: _QuickAmountButton(
                  responsive: responsive,
                  amount: 3000,
                  onTap: () => onAmountChanged(3000),
                ),
              ),
              SizedBox(width: responsive.width(12)),
              Expanded(
                child: _QuickAmountButton(
                  responsive: responsive,
                  amount: 2500,
                  onTap: () => onAmountChanged(2500),
                ),
              ),
            ],
          ),
          
          SizedBox(height: responsive.height(20)),
          
          // See Breakdown button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                // Navigate to breakdown screen
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: responsive.height(12)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(responsive.radius(8)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'See Breakdown',
                    style: TextStyle(
                      fontSize: responsive.fontSize(14),
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: responsive.width(8)),
                  Icon(
                    Icons.arrow_forward,
                    size: responsive.width(16),
                    color: Colors.white,
                  ),
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
  const _QuickAmountButton({
    required this.responsive,
    required this.amount,
    required this.onTap,
  });

  final Responsive responsive;
  final double amount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: responsive.height(10)),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(responsive.radius(8)),
        ),
        child: Center(
          child: Text(
            '₹${amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: responsive.fontSize(14),
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Promotional banner (Yellow)
class _PromoBanner extends StatelessWidget {
  const _PromoBanner({required this.responsive});

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(responsive.padding(20)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFFFC400), Color(0xFFFF5500)],
        ),
        borderRadius: BorderRadius.circular(responsive.radius(16)),
      ),
      child: Row(
        children: [
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need more money?',
                  style: TextStyle(
                    fontSize: responsive.fontSize(14),
                    color: const Color(0xFF482983),
                  ),
                ),
                SizedBox(height: responsive.height(8)),
                Text(
                  'Get up to ₹ 50000',
                  style: TextStyle(
                    fontSize: responsive.fontSize(20),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF482983),
                  ),
                ),
                SizedBox(height: responsive.height(4)),
                Text(
                  'Easy Tenures Completely Online.',
                  style: TextStyle(
                    fontSize: responsive.fontSize(12),
                    color: const Color(0xFF482983).withValues(alpha: 0.8),
                  ),
                ),
                SizedBox(height: responsive.height(12)),
                // Apply offer button
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.padding(16),
                    vertical: responsive.height(8),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD000),
                    borderRadius: BorderRadius.circular(responsive.radius(4)),
                  ),
                  child: Text(
                    'Apply offer',
                    style: TextStyle(
                      fontSize: responsive.fontSize(12),
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(width: responsive.width(16)),
          
          // Goddess image
          SizedBox(
            width: responsive.width(80),
            height: responsive.height(80),
            child: Image.asset(
              'assets/goddess_durga.jpg',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Continue button
class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.responsive});

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF532C8C), Color(0xFF171A58)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(responsive.radius(28)),
        ),
        child: TextButton(
          onPressed: () {
            // Handle continue action
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: responsive.height(18)),
            foregroundColor: Colors.white,
            textStyle: TextStyle(
              fontSize: responsive.fontSize(16),
              fontWeight: FontWeight.w600,
            ),
          ),
          child: const Text('Continue'),
        ),
      ),
    );
  }
}

/// ------------------- GRADIENT BG --------------------------
/// EmployeeIdScreen jaisa gradient background
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

/// ------------------- CUSTOM WAVE PAINTER --------------------------
class _WithdrawWavePainter extends CustomPainter {
  final double headerHeight;

  _WithdrawWavePainter({required this.headerHeight});

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
