import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../utils/animations.dart';
import 'package:flutter/services.dart';
import '../../services/auth_api_service.dart';
import '../../services/storage_service.dart';
import 'employee_id_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String otpFromApi;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.otpFromApi,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final authApiService = AuthApiService();
  final storageService = StorageService();
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isLoading = false;
  String? _errorMessage;

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
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _handleVerifyOtp() async {
    final otp = _otpControllers.map((c) => c.text).join('');

    if (otp.length != 6) {
      setState(() {
        _errorMessage = 'Please enter complete OTP';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await authApiService.verifyOtp(widget.phoneNumber, otp);

      debugPrint('✅ OTP verified successfully');
      debugPrint('Access Token: ${response.data.accessToken}');
      debugPrint('User Role: ${response.data.currentUserRole}');
      debugPrint(
        'User: ${response.data.user.firstName} ${response.data.user.lastName}',
      );
      debugPrint('KYC Status: ${response.data.kycStatus.kycStatus}');
      debugPrint('Can Access App: ${response.data.appAccess.canAccessApp}');

      await storageService.saveLoginData(response.data);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        SmoothPageRoute(page: const EmployeeIdScreen()),
      );
    } on ApiException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleResendOtp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await authApiService.sendOtp(widget.phoneNumber);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP resent successfully! (DEV: ${response.data.otp})'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 5),
        ),
      );
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  FadeInAnimation(
                    delay: const Duration(milliseconds: 100),
                    child: const Text(
                      'Verify OTP Now',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF171A58),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FadeInAnimation(
                    delay: const Duration(milliseconds: 200),
                    child: const Text(
                      'Enter the OTP code we just sent you on your registered Email/Phone number',
                      style: TextStyle(fontSize: 14, color: Color(0xFF7D8CA1)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SlideInAnimation(
                    delay: const Duration(milliseconds: 300),
                    offsetY: 30,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(6, (index) {
                            return Container(
                              margin: EdgeInsets.only(
                                right: index < 5 ? 12 : 0,
                              ),
                              width: 48,
                              height: 56,
                              child: TextField(
                                controller: _otpControllers[index],
                                focusNode: _focusNodes[index],
                                enabled: !_isLoading,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
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
                                      color: Color(0xFFB08BFF),
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
                                onChanged: (value) =>
                                    _onOtpChanged(index, value),
                              ),
                            );
                          }),
                        ),
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        const SizedBox(height: 12),
                        Text(
                          'DEV MODE: OTP is ${widget.otpFromApi}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SlideInAnimation(
                    delay: const Duration(milliseconds: 400),
                    offsetY: 30,
                    child: Column(
                      children: [
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
                              onPressed: _isLoading ? null : _handleVerifyOtp,
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Verify'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF7D8CA1),
                            ),
                            children: [
                              const TextSpan(text: 'Don\'t get OTP? '),
                              TextSpan(
                                text: 'Resend OTP',
                                style: const TextStyle(
                                  color: Color(0xFF1D4ED8),
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _handleResendOtp,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 90),
                      ],
                    ),
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

class _OtpHeader extends StatelessWidget {
  final double screenHeight;

  const _OtpHeader({required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    final headerHeight = screenHeight * 0.2;

    return SizedBox(
      height: headerHeight,
      width: double.infinity,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, headerHeight),
            painter: _OtpWavePainter(),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Image.asset(
                'assets/logo/logo-light.png',
                width: 220,

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

class _OtpWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final mainWavePath = _createBottomWave(size);

    final mainPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF241E63), Color(0xFF482983)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(mainWavePath, mainPaint);

    final firstStrokePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color.fromRGBO(95, 46, 151, 0.49),
          const Color.fromRGBO(0, 30, 64, 0.49),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(mainWavePath, firstStrokePaint);

    final secondStrokePaint = Paint()
      ..color = const Color(0xFFB8A8E0).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(mainWavePath, secondStrokePaint);
  }

  Path _createBottomWave(Size size) {
    final path = Path();
    path.moveTo(size.width * 1.422, size.height * 0.7446);
    path.cubicTo(
      size.width * 1.532,
      size.height * 0.491,
      size.width * 1.713,
      size.height * 0.437,
      size.width * 1.825,
      size.height * 0.443,
    );
    path.cubicTo(
      size.width * 1.853,
      size.height * 0.4445,
      size.width * 1.867,
      size.height * 0.4455,
      size.width * 1.875,
      size.height * 0.431,
    );
    path.cubicTo(
      size.width * 1.883,
      size.height * 0.4165,
      size.width * 1.883,
      size.height * 0.392,
      size.width * 1.883,
      size.height * 0.344,
    );
    path.lineTo(size.width * 1.883, size.height * 0.036);
    path.cubicTo(
      size.width * 1.883,
      size.height * -0.056,
      size.width * 1.883,
      size.height * -0.104,
      size.width * 1.876,
      size.height * -0.128,
    );
    path.cubicTo(
      size.width * 1.868,
      size.height * -0.154,
      size.width * 1.856,
      size.height * -0.154,
      size.width * 1.833,
      size.height * -0.154,
    );
    path.lineTo(size.width * -0.098, size.height * -0.154);
    path.cubicTo(
      size.width * -0.121,
      size.height * -0.154,
      size.width * -0.132,
      size.height * -0.154,
      size.width * -0.14,
      size.height * -0.128,
    );
    path.cubicTo(
      size.width * -0.147,
      size.height * -0.104,
      size.width * -0.147,
      size.height * -0.056,
      size.width * -0.147,
      size.height * 0.036,
    );
    path.lineTo(size.width * -0.147, size.height * 0.494);
    path.cubicTo(
      size.width * -0.147,
      size.height * 0.535,
      size.width * -0.147,
      size.height * 0.554,
      size.width * -0.14,
      size.height * 0.571,
    );
    path.cubicTo(
      size.width * -0.134,
      size.height * 0.586,
      size.width * -0.123,
      size.height * 0.588,
      size.width * -0.101,
      size.height * 0.5895,
    );
    path.cubicTo(
      size.width * 0.190,
      size.height * 0.626,
      size.width * 0.702,
      size.height * 0.852,
      size.width * 0.932,
      size.height * 0.967,
    );
    path.cubicTo(
      size.width * 1.041,
      size.height * 1.018,
      size.width * 1.289,
      size.height * 1.045,
      size.width * 1.422,
      size.height * 0.7446,
    );
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
