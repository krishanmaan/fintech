import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../utils/animations.dart';
import '../../services/auth_api_service.dart';
import '../../services/storage_service.dart';
import 'otp_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final authApiService = AuthApiService();
  final storageService = StorageService();
  bool _rememberMe = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final phoneNumber = _phoneController.text.trim();

    if (phoneNumber.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your phone number';
      });
      return;
    }

    if (phoneNumber.length != 10) {
      setState(() {
        _errorMessage = 'Please enter a valid 10-digit phone number';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final checkPhoneResponse = await authApiService.checkPhone(phoneNumber);

      debugPrint('✅ Phone check successful');
      debugPrint('User exists: ${checkPhoneResponse.data.userExists}');
      debugPrint('Next step: ${checkPhoneResponse.data.nextStep}');

      if (checkPhoneResponse.data.nextStep == 'SEND_OTP') {
        final sendOtpResponse = await authApiService.sendOtp(phoneNumber);

        debugPrint('✅ OTP sent successfully');
        debugPrint('OTP (DEV MODE): ${sendOtpResponse.data.otp}');
        debugPrint('Expires in: ${sendOtpResponse.data.expiresIn}');

        await storageService.savePhoneNumber(phoneNumber);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'OTP sent successfully! (DEV: ${sendOtpResponse.data.otp})',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
          ),
        );

        Navigator.push(
          context,
          SmoothPageRoute(
            page: OtpVerificationScreen(
              phoneNumber: phoneNumber,
              otpFromApi: sendOtpResponse.data.otp,
            ),
          ),
        );
      }
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _LoginHeader(screenHeight: screenHeight),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  FadeInAnimation(
                    delay: const Duration(milliseconds: 100),
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Color(0xFF171A58),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FadeInAnimation(
                    delay: const Duration(milliseconds: 200),
                    child: const Text(
                      'Create an account or log in to explore about our app',
                      style: TextStyle(fontSize: 12, color: Color(0xFF7D8CA1)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SlideInAnimation(
                    delay: const Duration(milliseconds: 300),
                    offsetY: 30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Enter your mobile no',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF101828),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          enabled: !_isLoading,
                          decoration: InputDecoration(
                            hintText: '9876543210',
                            counterText: '',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28),
                              borderSide: BorderSide(
                                color: _errorMessage != null
                                    ? Colors.red
                                    : const Color(0xFFE2E8F0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28),
                              borderSide: const BorderSide(
                                color: Color(0xFF532C8C),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 4),
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              activeColor: const Color(0xFF532C8C),
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Remember me',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF475467),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SlideInAnimation(
                    delay: const Duration(milliseconds: 400),
                    offsetY: 30,
                    child: SizedBox(
                      width: double.infinity,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF532C8C), Color(0xFF171A58)],
                          ),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: TextButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
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
                              : const Text('Log In'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7D8CA1),
                  ),
                  children: [
                    const TextSpan(text: 'By signing up, you agree to the '),
                    TextSpan(
                      text: 'Terms of Service',
                      style: const TextStyle(
                        color: Color(0xFF532C8C),
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Data Processing Agreement.',
                      style: const TextStyle(
                        color: Color(0xFF532C8C),
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginHeader extends StatelessWidget {
  final double screenHeight;

  const _LoginHeader({required this.screenHeight});

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
            painter: _HeaderWavePainter(),
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
