import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'varify_statius_screen.dart';

/// Final bank verification step in the KYC wizard.
class BankVerifyIdentityScreen extends StatefulWidget {
  const BankVerifyIdentityScreen({super.key});

  @override
  State<BankVerifyIdentityScreen> createState() =>
      _BankVerifyIdentityScreenState();
}

class _BankVerifyIdentityScreenState extends State<BankVerifyIdentityScreen> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _cardController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const Positioned.fill(child: _BankGradientBackground()),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: _BankContentCard(
                    accountController: _accountController,
                    ifscController: _ifscController,
                    branchController: _branchController,
                    cardController: _cardController,
                    cvvController: _cvvController,
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

class _BankGradientBackground extends StatelessWidget {
  const _BankGradientBackground();

  @override
  Widget build(BuildContext context) {
    final double headerHeight = MediaQuery.of(context).size.height * 0.35;
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: _BankWavePainter(headerHeight: headerHeight),
      ),
    );
  }
}

class _BankContentCard extends StatelessWidget {
  final TextEditingController accountController;
  final TextEditingController ifscController;
  final TextEditingController branchController;
  final TextEditingController cardController;
  final TextEditingController cvvController;

  const _BankContentCard({
    required this.accountController,
    required this.ifscController,
    required this.branchController,
    required this.cardController,
    required this.cvvController,
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _StepHeader(),
            const SizedBox(height: 28),
            const Text(
              "Add your Bank",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF101828),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Please provide you bank details",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF7D8CA1),
              ),
            ),
            const SizedBox(height: 28),
            /// Bank selector tile – static for now.
            const _BankProviderTile(),
            const SizedBox(height: 24),
            const _FieldLabel("Account Number"),
            const SizedBox(height: 8),
            _FormInputField(
              controller: accountController,
              hint: "Add account number",
            ),
            const SizedBox(height: 20),
            const _FieldLabel("IFC Code"),
            const SizedBox(height: 8),
            _FormInputField(
              controller: ifscController,
              hint: "Add ifc code",
            ),
            const SizedBox(height: 20),
            const _FieldLabel("Branch"),
            const SizedBox(height: 8),
            _FormInputField(
              controller: branchController,
              hint: "write branch",
            ),
            const SizedBox(height: 20),
            const _FieldLabel("Card Number"),
            const SizedBox(height: 8),
            _FormInputField(
              controller: cardController,
              hint: "Card Number",
            ),
            const SizedBox(height: 20),
            const _FieldLabel("Cvv"),
            const SizedBox(height: 8),
            _CvvInputField(
              controller: cvvController,
              hint: "Add cvv number",
            ),
            const SizedBox(height: 32),
            /// Submit and move to the verification status summary.
            const _VerifyButton(),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
    );
  }
}

class _FormInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _FormInputField({
    required this.controller,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF5F6FA),
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _CvvInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _CvvInputField({
    required this.controller,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF5F6FA),
        hintText: hint,
        suffixIcon: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.info_outline_rounded,
            color: Color(0xFF5B2B8F),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _BankProviderTile extends StatelessWidget {
  const _BankProviderTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E7EC)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF101828).withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SvgPicture.string(
            _bankSvgIcon,
            width: 48,
            height: 48,
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "State Bank Of India 6200",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7D8CA1),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Vikash shing",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF101828),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF7D8CA1),
          ),
        ],
      ),
    );
  }
}

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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const VarifyStatiusScreen(status: KycStatus.completed),
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
          child: const Text("Verify Now"),
        ),
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _StepItem(label: '1', isCompleted: true),
        _StepConnector(isCompleted: true),
        _StepItem(label: '2', isCompleted: true),
        _StepConnector(isCompleted: true),
        _StepItem(label: '3', isCompleted: true, isCurrent: true),
      ],
    );
  }
}

class _StepItem extends StatelessWidget {
  final String label;
  final bool isCompleted;
  final bool isCurrent;

  const _StepItem({
    required this.label,
    required this.isCompleted,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = const Color(0xFF5B2B8F);
    final Color inactiveColor = Colors.grey.shade300;

    Color backgroundColor;
    Color textColor;

    // Completed steps are filled; current step gets a lighter background cue.
    if (isCurrent) {
      backgroundColor = const Color(0xFFEDEBFF);
      textColor = activeColor;
    } else if (isCompleted) {
      backgroundColor = activeColor;
      textColor = Colors.white;
    } else {
      backgroundColor = Colors.white;
      textColor = const Color(0xFF98A2B3);
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isCompleted ? activeColor : inactiveColor,
          width: 2,
        ),
        color: backgroundColor,
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _StepConnector extends StatelessWidget {
  final bool isCompleted;

  const _StepConnector({required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 3,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          gradient: isCompleted
              ? const LinearGradient(
                  colors: [Color(0xFF5B2B8F), Color(0xFF7F56D9)],
                )
              : null,
          color: isCompleted ? null : Colors.grey.shade200,
        ),
      ),
    );
  }
}

class _BankWavePainter extends CustomPainter {
  final double headerHeight;

  _BankWavePainter({required this.headerHeight});

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

const String _bankSvgIcon = '''
<svg width="48" height="48" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
<rect width="48" height="48" rx="3.5" fill="#F6F6F6"/>
<g clip-path="url(#clip0_185_204)">
<path d="M24.7453 12.9469C24.2859 12.6844 23.7187 12.6844 23.2546 12.9469L12.7546 18.9469C12.164 19.2844 11.8734 19.9781 12.0468 20.6344C12.2203 21.2906 12.8203 21.75 13.4999 21.75H14.9999V31.5L12.5999 33.3C12.2203 33.5812 11.9999 34.0266 11.9999 34.5C11.9999 35.3297 12.6703 36 13.4999 36H34.4999C35.3296 36 35.9999 35.3297 35.9999 34.5C35.9999 34.0266 35.7796 33.5812 35.3999 33.3L32.9999 31.5V21.75H34.4999C35.1796 21.75 35.7749 21.2906 35.9484 20.6344C36.1218 19.9781 35.8312 19.2844 35.2406 18.9469L24.7406 12.9469H24.7453ZM30.7499 21.75V31.5H27.7499V21.75H30.7499ZM25.4999 21.75V31.5H22.4999V21.75H25.4999ZM20.2499 21.75V31.5H17.2499V21.75H20.2499ZM23.9999 16.5C24.3978 16.5 24.7793 16.658 25.0606 16.9393C25.3419 17.2206 25.4999 17.6022 25.4999 18C25.4999 18.3978 25.3419 18.7794 25.0606 19.0607C24.7793 19.342 24.3978 19.5 23.9999 19.5C23.6021 19.5 23.2206 19.342 22.9393 19.0607C22.658 18.7794 22.4999 18.3978 22.4999 18C22.4999 17.6022 22.658 17.2206 22.9393 16.9393C23.2206 16.658 23.6021 16.5 23.9999 16.5Z" fill="black"/>
</g>
<defs>
<clipPath id="clip0_185_204">
<rect width="24" height="24" fill="white" transform="translate(12 12)"/>
</clipPath>
</defs>
</svg>
''';

