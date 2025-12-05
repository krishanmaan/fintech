import 'package:flutter/material.dart';
import '../../utils/animations.dart';
import 'verify_identity_screen.dart';

class EmployeeIdScreen extends StatefulWidget {
  const EmployeeIdScreen({super.key});

  @override
  State<EmployeeIdScreen> createState() => _EmployeeIdScreenState();
}

class _EmployeeIdScreenState extends State<EmployeeIdScreen> {
  final TextEditingController _businessNameController = TextEditingController(
    text: '',
  );

  final TextEditingController _employeeIdController = TextEditingController();

  final TextEditingController _businessCodeController = TextEditingController();

  @override
  void dispose() {
    _businessNameController.dispose();
    _employeeIdController.dispose();
    _businessCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Stack(
        children: [
          const Positioned.fill(child: _EmployeeGradientBackground()),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const SizedBox(height: 20),

                Expanded(
                  child: _EmployeeContentCard(
                    businessNameController: _businessNameController,
                    employeeIdController: _employeeIdController,
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

class _EmployeeContentCard extends StatelessWidget {
  final TextEditingController businessNameController;
  final TextEditingController employeeIdController;
  final TextEditingController businessCodeController;

  void _handleContinue(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const VerifyIdentityScreen()),
    );
  }

  const _EmployeeContentCard({
    required this.businessNameController,
    required this.employeeIdController,
    required this.businessCodeController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF171A58).withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const _HeaderLogo(),

          FadeInAnimation(
            delay: const Duration(milliseconds: 100),
            child: const Text(
              "Enter Company Details",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF161616),
              ),
            ),
          ),

          const SizedBox(height: 8),
          FadeInAnimation(
            delay: const Duration(milliseconds: 200),
            child: const Text(
              "Add Your Workplace Info",
              style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
            ),
          ),

          const SizedBox(height: 30),

          SlideInAnimation(
            delay: const Duration(milliseconds: 300),
            offsetY: 30,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Company name",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                _CustomInputField(
                  controller: businessNameController,
                  hint: "Search Business",
                  icon: Icons.search,
                  iconOnRight: false,
                ),

                const SizedBox(height: 24),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Employee ID",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                _CustomInputField(
                  controller: employeeIdController,
                  hint: "",
                  icon: Icons.help_outline,
                  iconOnRight: true,
                ),

                const SizedBox(height: 20),
                const Text(
                  "Or",
                  style: TextStyle(fontSize: 14, color: Color(0xFF7D8CA1)),
                ),
                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Employee Code",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                _CustomInputField(
                  controller: businessCodeController,
                  hint: "",
                  icon: Icons.help_outline,
                  iconOnRight: true,
                ),
              ],
            ),
          ),

          const Spacer(),

          SlideInAnimation(
            delay: const Duration(milliseconds: 400),
            offsetY: 30,
            child: _ContinueButton(onPressed: () => _handleContinue(context)),
          ),
        ],
      ),
    );
  }
}

class _HeaderLogo extends StatelessWidget {
  const _HeaderLogo();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logo/logo-light.png',
      width: 220,

      colorBlendMode: BlendMode.srcIn,
    );
  }
}

class _CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool iconOnRight;

  const _CustomInputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.iconOnRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF171A58),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: iconOnRight
            ? null
            : Icon(icon, color: Color(0xFF7D8CA1), size: 22),
        suffixIcon: iconOnRight
            ? Icon(icon, color: Color(0xFF7D8CA1), size: 22)
            : null,
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 15,
          color: Colors.grey.shade400,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8E8E8), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8E8E8), width: 2),
        ),
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ContinueButton({required this.onPressed});

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
          onPressed: onPressed,
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
