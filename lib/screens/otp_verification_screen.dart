import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _OtpHeader(screenHeight: screenHeight),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  const Text(
                    'Verify OTP Now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Color(0xFF171A58),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Enter the OTP code we just sent you on your registered Email/Phone number',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF7D8CA1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Container(
                        margin: EdgeInsets.only(
                          right: index < 3 ? 12 : 0,
                        ),
                        width: 60,
                        height: 60,
                        child: TextField(
                          controller: _otpControllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF171A58),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF532C8C),
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF532C8C),
                                width: 2,
                              ),
                            ),
                          ),
                          onChanged: (value) => _onOtpChanged(index, value),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF532C8C), Color(0xFF171A58)],
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
                        child: const Text('Verify'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7D8CA1),
                      ),
                      children: [
                        const TextSpan(
                          text: 'Don\'t get OTP? ',
                        ),
                        TextSpan(
                          text: 'Resend OTP',
                          style: const TextStyle(
                            color: Color(0xFF532C8C),
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OtpHeader extends StatelessWidget {
  final double screenHeight;

  const _OtpHeader({required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    final headerHeight = screenHeight * 0.35;

    return SizedBox(
      height: headerHeight,
      width: double.infinity,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, headerHeight),
            painter: _HeaderWavePainter(),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Image.asset(
                'assets/logo/logo-light.png',
                width: 93,
                height: 35,
                fit: BoxFit.contain,
                color: Colors.white,
                colorBlendMode: BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path buildPath(double offsetFactor) {
      final offset = size.height * offsetFactor;
      final path = Path();
      path.moveTo(size.width * 0.083, size.height * 0.76 + offset);
      path.cubicTo(
        size.width * 0.017,
        size.height * 0.54 + offset,
        size.width * -0.085,
        size.height * 0.48 + offset,
        size.width * -0.158,
        size.height * 0.47 + offset,
      );
      path.cubicTo(
        size.width * -0.188,
        size.height * 0.47 + offset,
        size.width * -0.202,
        size.height * 0.47 + offset,
        size.width * -0.209,
        size.height * 0.45 + offset,
      );
      path.cubicTo(
        size.width * -0.216,
        size.height * 0.44 + offset,
        size.width * -0.216,
        size.height * 0.41 + offset,
        size.width * -0.216,
        size.height * 0.35 + offset,
      );
      path.lineTo(size.width * -0.216, size.height * 0.10 + offset);
      path.cubicTo(
        size.width * -0.216,
        size.height * 0.05 + offset,
        size.width * -0.216,
        size.height * 0.02 + offset,
        size.width * -0.209,
        size.height * 0.01 + offset,
      );
      path.cubicTo(
        size.width * -0.202,
        offset,
        size.width * -0.19,
        offset,
        size.width * -0.1679,
        offset,
      );
      path.lineTo(size.width * 1.056, offset);
      path.cubicTo(
        size.width * 1.078,
        offset,
        size.width * 1.089,
        offset,
        size.width * 1.096,
        size.height * 0.01 + offset,
      );
      path.cubicTo(
        size.width * 1.104,
        size.height * 0.02 + offset,
        size.width * 1.104,
        size.height * 0.05 + offset,
        size.width * 1.104,
        size.height * 0.10 + offset,
      );
      path.lineTo(size.width * 1.104, size.height * 0.50 + offset);
      path.cubicTo(
        size.width * 1.104,
        size.height * 0.55 + offset,
        size.width * 1.104,
        size.height * 0.57 + offset,
        size.width * 1.098,
        size.height * 0.59 + offset,
      );
      path.cubicTo(
        size.width * 1.092,
        size.height * 0.61 + offset,
        size.width * 1.081,
        size.height * 0.61 + offset,
        size.width * 1.061,
        size.height * 0.61 + offset,
      );
      path.cubicTo(
        size.width * 0.867,
        size.height * 0.66 + offset,
        size.width * 0.548,
        size.height * 0.86 + offset,
        size.width * 0.402,
        size.height * 0.97 + offset,
      );
      path.cubicTo(
        size.width * 0.332,
        size.height * 1.02 + offset,
        size.width * 0.168,
        size.height * 1.04 + offset,
        size.width * 0.083,
        size.height * 0.76 + offset,
      );
      path.close();
      return path;
    }

    final farWavePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
        colors: [
          Color.fromRGBO(95, 46, 151, 0.24),
          Color.fromRGBO(0, 30, 64, 0.24),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final middleWavePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
        colors: [
          Color.fromRGBO(95, 46, 151, 0.49),
          Color.fromRGBO(0, 30, 64, 0.49),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final primaryPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment(1.8, -1.5),
        end: Alignment(0.8, 2.5),
        colors: [Color(0xFF241E63), Color(0xFF482983)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(buildPath(0.09), farWavePaint);
    canvas.drawPath(buildPath(0.05), middleWavePaint);
    canvas.drawPath(buildPath(0.0), primaryPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

