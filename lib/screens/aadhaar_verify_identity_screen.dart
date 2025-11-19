import 'package:flutter/material.dart';

class AadhaarVerifyIdentityScreen extends StatefulWidget {
  const AadhaarVerifyIdentityScreen({super.key});

  @override
  State<AadhaarVerifyIdentityScreen> createState() =>
      _AadhaarVerifyIdentityScreenState();
}

class _AadhaarVerifyIdentityScreenState
    extends State<AadhaarVerifyIdentityScreen> {
  final TextEditingController _aadhaarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Stack(
        children: [
          const Positioned.fill(child: _AadhaarGradientBackground()),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),

                Expanded(
                  child: _AadhaarContentCard(
                    aadhaarController: _aadhaarController,
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

/// ---------------- BG GRADIENT ----------------
class _AadhaarGradientBackground extends StatelessWidget {
  const _AadhaarGradientBackground();

  @override
  Widget build(BuildContext context) {
    final double headerHeight = MediaQuery.of(context).size.height * 0.35;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: _AadhaarWavePainter(headerHeight: headerHeight),
      ),
    );
  }
}

/// ---------------- CONTENT CARD ----------------
class _AadhaarContentCard extends StatelessWidget {
  final TextEditingController aadhaarController;

  const _AadhaarContentCard({
    super.key,
    required this.aadhaarController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      margin: const EdgeInsets.only(top: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF171A58).withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepHeader(),
          const SizedBox(height: 25),

          const Text(
            "Identity Verification",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF101828),
            ),
          ),
          const SizedBox(height: 6),

          const Text(
            "Please provide you aadhaar details",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF7D8CA1),
            ),
          ),

          const SizedBox(height: 30),

          /// Dropdown-like card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Image.asset(
                  "assets/icons/aadhaar.png",
                  width: 35,
                ),
                const SizedBox(width: 12),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Uidai",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF7D8CA1),
                        ),
                      ),
                      Text(
                        "Aadhaar verification",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF101828),
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF7D8CA1)),
              ],
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            "Aadhaar Number",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 10),

          _AadhaarInputField(
            controller: aadhaarController,
            hint: "Enter 12-digit aadhaar number",
            icon: Icons.numbers_rounded,
          ),

          const Spacer(),

          const _VerifyButton(),
        ],
      ),
    );
  }
}

/// ---------------- AADHAAR INPUT FIELD ----------------
class _AadhaarInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;

  const _AadhaarInputField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      maxLength: 12,
      decoration: InputDecoration(
        counterText: "",
        filled: true,
        fillColor: const Color(0xFFF5F6FA),
        prefixIcon: Icon(icon, color: Colors.grey.shade600),
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

/// ---------------- HEADER STEPS ----------------
class _StepHeader extends StatelessWidget {
  const _StepHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _circle(true),
        _line(),
        _circle(true),
        _line(),
        _circle(false),
      ],
    );
  }

  Widget _circle(bool active) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? const Color(0xFF5B2B8F) : Colors.grey.shade300,
      ),
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.grey.shade400,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _line() {
    return Container(
      width: 50,
      height: 3,
      color: Colors.grey.shade300,
    );
  }
}

/// ---------------- VERIFY BUTTON ----------------
class _VerifyButton extends StatelessWidget {
  const _VerifyButton();

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
          borderRadius: BorderRadius.circular(28),
        ),
        child: TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: const Text("Verify Now"),
        ),
      ),
    );
  }
}

/// ---------------- CUSTOM WAVE PAINTER ----------------
class _AadhaarWavePainter extends CustomPainter {
  final double headerHeight;

  _AadhaarWavePainter({required this.headerHeight});

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
