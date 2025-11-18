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
  void dispose() {
    _businessNameController.dispose();
    _businessCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double topSpacing = MediaQuery.of(context).size.height * 0;

    return Scaffold(
      backgroundColor:  Colors.white,
      body: Stack(
        children: [
          const Positioned.fill(child: _EmployeeGradientBackground()),
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: topSpacing * 0.2),
                Expanded(
                  child: _DetailsCard(
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

class _EmployeeGradientBackground extends StatelessWidget {
  const _EmployeeGradientBackground();

  @override
  Widget build(BuildContext context) {
    final double headerHeight = MediaQuery.of(context).size.height * 0.4;
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: _EmployeeWavePainter(headerHeight: headerHeight),
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final TextEditingController businessNameController;
  final TextEditingController businessCodeController;

  const _DetailsCard({
    required this.businessNameController,
    required this.businessCodeController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo/logo-light.png',
            width: 110,
            color: const Color(0xFF171A58),
            colorBlendMode: BlendMode.srcIn,
          ),
          const SizedBox(height: 20),
          const _ScreenTitle(),
          const SizedBox(height: 24),

          const _FieldLabel(text: 'Business name'),
          const SizedBox(height: 8),
          _InputField(
            controller: businessNameController,
            hintText: 'Nests India (nests)',
            prefixIcon: Icons.search,
          ),
          const SizedBox(height: 20),

          const _OrDivider(),
          const SizedBox(height: 20),

          const _FieldLabel(text: 'Business Code'),
          const SizedBox(height: 8),
          _InputField(
            controller: businessCodeController,
            hintText: 'Enter business code',
            suffixIcon: Icons.info_outline_rounded,
          ),

          const Spacer(),

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
                onPressed: () {},
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
          ),
        ],
      ),
    );
  }
}

class _ScreenTitle extends StatelessWidget {
  const _ScreenTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          'Enter Company Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF171A58),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          'Add Your Workplace Info',
          style: TextStyle(fontSize: 14, color: Color(0xFF7D8CA1)),
          textAlign: TextAlign.center,
        ),
      ],
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

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Color(0xFF101828),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;

  const _InputField({
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        filled: true,
        fillColor: Colors.white,
        prefixIcon:
            prefixIcon != null ? Icon(prefixIcon, color: const Color(0xFF7D8CA1)) : null,
        suffixIcon:
            suffixIcon != null ? Icon(suffixIcon, color: const Color(0xFF7D8CA1)) : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Color(0xFF532C8C), width: 1.5),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: Divider(color: Color(0xFFE2E8F0))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Or',
            style: TextStyle(fontSize: 12, color: Color(0xFF7D8CA1)),
          ),
        ),
        Expanded(child: Divider(color: Color(0xFFE2E8F0))),
      ],
    );
  }
}
