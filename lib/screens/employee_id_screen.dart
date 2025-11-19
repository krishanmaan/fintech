import 'package:flutter/material.dart';

class EmployeeIdScreen extends StatefulWidget {
  const EmployeeIdScreen({super.key});

  @override
  State<EmployeeIdScreen> createState() => _EmployeeIdScreenState();
}

class _EmployeeIdScreenState extends State<EmployeeIdScreen> {
  final TextEditingController _businessNameController =
      TextEditingController(text: 'Nests India (nests)');

  final TextEditingController _businessCodeController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Stack(
        children: [
          const Positioned.fill(child: _EmployeeGradientBackground()),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),

                /// CARD FULL SCREEN TAK EXPAND
                Expanded(
                  child: _EmployeeContentCard(
                    businessNameController: _businessNameController,
                    businessCodeController: _businessCodeController,
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

/// ------------------- GRADIENT BG --------------------------
class _EmployeeGradientBackground extends StatelessWidget {
  const _EmployeeGradientBackground();

  @override
  Widget build(BuildContext context) {
    final double headerHeight = MediaQuery.of(context).size.height * 0.35;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: _EmployeeWavePainter(headerHeight: headerHeight),
      ),
    );
  }
}

/// ------------------- CONTENT CARD --------------------------
class _EmployeeContentCard extends StatelessWidget {
  final TextEditingController businessNameController;
  final TextEditingController businessCodeController;

  const _EmployeeContentCard({
    super.key,
    required this.businessNameController,
    required this.businessCodeController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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

      /// COMPLETE UI INSIDE CARD
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const _HeaderLogo(),
          const SizedBox(height: 20),

          const Text(
            "Enter Company Details",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF101828),
            ),
          ),

          const SizedBox(height: 8),
          const Text(
            "Add Your Workplace Info",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF7D8CA1),
            ),
          ),

          const SizedBox(height: 30),

          /// Business Name
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Business name",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),

          _CustomInputField(
            controller: businessNameController,
            hint: "Search Business",
            icon: Icons.search,
          ),

          const SizedBox(height: 20),
          const Text("Or",
              style: TextStyle(fontSize: 14, color: Color(0xFF7D8CA1))),
          const SizedBox(height: 20),

          /// Business Code
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Business Code",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),

          _CustomInputField(
            controller: businessCodeController,
            hint: "",
            icon: Icons.info_outline,
          ),

          const Spacer(),

          /// Continue Button
          _ContinueButton(),
        ],
      ),
    );
  }
}

/// ------------------- HEADER LOGO --------------------------
class _HeaderLogo extends StatelessWidget {
  const _HeaderLogo();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logo/logo-light.png',
      width: 120,
      color: const Color(0xFF171A58),
      colorBlendMode: BlendMode.srcIn,
    );
  }
}

/// ------------------- INPUT FIELD --------------------------
class _CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;

  const _CustomInputField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
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

/// ------------------- CONTINUE BUTTON --------------------------
class _ContinueButton extends StatelessWidget {
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
          child: const Text("Continue"),
        ),
      ),
    );
  }
}

/// ------------------- CUSTOM WAVE PAINTER --------------------------
class _EmployeeWavePainter extends CustomPainter {
  final double headerHeight;

  _EmployeeWavePainter({required this.headerHeight});

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
