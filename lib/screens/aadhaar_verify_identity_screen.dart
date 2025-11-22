import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'pan_verify_identity_screen.dart';

/// Aadhaar verification entry screen for the KYC funnel.
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
            bottom: false,
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

  const _AadhaarContentCard({required this.aadhaarController});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            style: TextStyle(fontSize: 14, color: Color(0xFF7D8CA1)),
          ),

          const SizedBox(height: 30),

          /// Pre-selected verification provider tile.
          const _VerificationProviderTile(),

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

          /// Continue to the PAN verification step.
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: const [
          _StepItem(label: '1', isCompleted: true, isCurrent: true),
          _StepConnector(isCompleted: false),
          _StepItem(label: '2', isCompleted: false),
          _StepConnector(isCompleted: false),
          _StepItem(label: '3', isCompleted: false),
        ],
      ),
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

    // Current step gets a soft fill while completed steps are fully colored.
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
      width: 40,
      height: 40,
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PanVerifyIdentityScreen(),
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

class _VerificationProviderTile extends StatelessWidget {
  const _VerificationProviderTile();

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
            color: const Color(0xFF101828).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SvgPicture.string(_aadhaarSvgIcon, width: 48, height: 48),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Uidai",
                  style: TextStyle(fontSize: 12, color: Color(0xFF7D8CA1)),
                ),
                SizedBox(height: 4),
                Text(
                  "Aadhaar verification",
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

const String _aadhaarSvgIcon = '''
<svg width="48" height="48" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
<rect width="48" height="48" rx="3.5" fill="#F6F6F6"/>
<g clip-path="url(#clip0_179_609)">
<path d="M1.05005 31.8658C1.4587 31.6335 1.81215 31.3188 2.08688 30.9424C2.44527 30.4862 2.84972 30.0664 3.29409 29.6896C3.92402 29.1661 4.68825 28.8213 5.50401 28.6927C5.31921 29.7406 5.22594 30.8021 5.22519 31.8655L1.05005 31.8658ZM4.16337 20.4981C4.63574 20.4967 5.10241 20.3971 5.53248 20.2058C6.0761 19.9859 6.64093 19.8201 7.21844 19.7109C8.03638 19.5645 8.87972 19.6415 9.6559 19.9335C8.25759 21.5686 7.15624 23.4266 6.3998 25.4264C5.7587 24.9158 5.27272 24.2431 4.99461 23.4812C4.80244 22.9375 4.66679 22.3762 4.58975 21.8058C4.54425 21.3452 4.39889 20.8994 4.16337 20.4981ZM12.6708 12.1761C13.0809 12.4065 13.5364 12.5487 14.0071 12.5933C14.5899 12.6686 15.1635 12.8013 15.7191 12.9892C16.5018 13.2622 17.1926 13.7411 17.7154 14.3733C15.67 15.11 13.7689 16.1848 12.0949 17.5509C11.7957 16.7915 11.7167 15.966 11.8665 15.1654C11.9779 14.6005 12.1474 14.048 12.3724 13.5164C12.5681 13.0955 12.6699 12.6386 12.6708 12.1761ZM24.2924 9.13C24.53 9.53023 24.8523 9.87608 25.2377 10.1444C25.704 10.495 26.1331 10.8907 26.5186 11.3253C27.0574 11.9457 27.4109 12.6996 27.54 13.5041C25.3911 13.1434 23.1953 13.1434 21.0465 13.5041C21.1754 12.6995 21.5289 11.9455 22.0679 11.3251C22.4533 10.8905 22.8823 10.4948 23.3485 10.1442C23.7333 9.87577 24.0551 9.53 24.2924 9.13ZM35.9135 12.1759C35.9147 12.6384 36.0166 13.0953 36.2125 13.5162C36.4372 14.0478 36.6066 14.6003 36.7182 15.1652C36.8676 15.9657 36.7885 16.7911 36.4896 17.5505C34.8152 16.1845 32.9138 15.1097 30.8682 14.3729C31.3914 13.7407 32.0825 13.2619 32.8656 12.9892C33.4215 12.801 33.9954 12.6682 34.5785 12.5929C35.0487 12.5483 35.5037 12.4062 35.9133 12.1759H35.9135ZM44.4211 20.4977C44.1858 20.8988 44.0405 21.3444 43.995 21.8048C43.9178 22.3751 43.7822 22.9363 43.5901 23.4799C43.312 24.2419 42.8259 24.9146 42.1847 25.4251C41.4284 23.4256 40.3271 21.568 38.9288 19.9333C39.7046 19.6415 40.5474 19.5644 41.365 19.7105C41.9424 19.8197 42.5072 19.9855 43.0507 20.2054C43.4811 20.397 43.9483 20.4966 44.4211 20.4977ZM43.0809 28.6927C43.8968 28.8215 44.661 29.1663 45.2911 29.6898C45.7355 30.0666 46.1399 30.4863 46.4983 30.9427C46.7729 31.3191 47.1264 31.6339 47.5351 31.866H43.3602C43.3591 30.8024 43.2656 29.7408 43.0807 28.6927H43.0809ZM29.8338 15.526C33.3483 16.6626 36.4092 18.8516 38.5838 21.7837C40.7584 24.7158 41.9369 28.2428 41.9526 31.8662H38.4803C38.7115 25.2126 35.7416 19.2069 29.8338 15.526Z" fill="#FAB401"/>
<path d="M30.5323 31.8666H32.3341C32.4211 29.9382 32.2533 27.6542 31.6198 25.6584C31.4976 25.2708 31.3539 24.89 31.1893 24.5177C30.8026 23.6629 30.2925 22.867 29.6746 22.1543C28.9841 21.3395 28.1684 20.6347 27.2567 20.0653C26.9845 19.8969 26.7033 19.7428 26.4143 19.6036C26.1242 19.4638 25.8261 19.3404 25.5216 19.2339H25.5203C22.0115 18.0057 18.4607 18.878 15.483 20.4736C14.9025 20.7844 14.3438 21.1227 13.8118 21.4779C13.2798 21.8332 12.7736 22.2055 12.2973 22.5859C11.6004 23.1431 10.9415 23.7443 10.3247 24.3855C10.1869 24.5292 10.0506 24.6755 9.91849 24.8238C9.56404 25.2191 9.01835 25.7733 9.1796 26.3466C9.30804 26.8015 9.90349 26.6673 10.1112 26.5105C10.456 26.3141 10.7801 26.0848 11.0788 25.8261C11.4841 25.4882 11.8668 25.124 12.2679 24.7821C13.7576 23.4864 15.4364 22.4156 17.2489 21.605C17.6123 21.4475 17.9753 21.3057 18.3381 21.1795C18.7009 21.0532 19.0596 20.9456 19.4143 20.8565H19.4158C22.5165 20.0634 25.8858 20.5774 28.0434 23.0672C30.1212 25.4657 30.5006 28.6762 30.5323 31.8666ZM8.1695 29.1555C8.38474 28.9476 8.58412 28.7246 8.76604 28.4882C8.88713 28.3624 8.97022 28.2063 9.00605 28.0371C9.04189 27.8678 9.02907 27.6922 8.96902 27.5297C8.92779 27.4383 8.86589 27.3573 8.78799 27.2927C8.71268 27.2305 8.62327 27.1867 8.52721 27.1651C8.38407 27.1413 8.23697 27.1584 8.10348 27.2142C7.96998 27.2701 7.85574 27.3624 7.77441 27.4802C7.50515 27.8029 7.1331 28.3543 7.05726 28.8417C7.04273 28.9289 7.03995 29.0175 7.049 29.1053C7.0572 29.185 7.08034 29.2625 7.11724 29.334C7.14478 29.3886 7.1875 29.4344 7.24047 29.4663C7.29345 29.4981 7.35454 29.5147 7.4167 29.514C7.44733 29.515 7.47798 29.5137 7.50841 29.5102C7.54325 29.5063 7.5778 29.5003 7.61186 29.4921H7.61338C7.82494 29.428 8.01633 29.3121 8.1695 29.1555ZM26.8655 31.8666H28.653C28.7379 29.7882 28.3978 27.6416 27.4164 25.7841C26.5239 24.0945 25.0476 22.9459 23.1383 22.6683C20.3498 22.264 17.536 23.4254 15.1576 25.0887C12.5674 26.8985 10.4296 29.3585 8.56133 31.8666L10.9225 31.8636C13.0483 28.8964 17.9382 24.3919 21.5349 24.3624C22.681 24.353 23.8465 24.6177 24.7077 25.375C25.3321 25.9235 26.089 26.9889 26.0519 27.8533C26.0301 28.366 25.5679 28.523 25.1248 28.3639C24.7805 28.2405 24.538 27.9305 24.2966 27.605C23.9278 27.0905 23.4194 26.6872 22.8288 26.4406C22.2382 26.194 21.589 26.1139 20.9544 26.2094C19.3573 26.4245 17.3778 27.6455 16.101 28.756C15.0053 29.7204 13.9811 30.7599 13.0362 31.8666H15.5747C16.4671 30.7599 17.5406 29.8056 18.7517 29.0424C19.1944 28.7655 19.6671 28.5376 20.1612 28.3628C21.4662 27.9208 22.7651 28.0329 23.3417 29.6332C23.5683 30.2622 23.6024 30.8141 23.5355 31.8244V31.8655H25.2621L25.2665 31.8136C25.2678 31.2605 25.2556 30.8869 25.3062 30.338C25.3497 29.8648 25.4992 29.3747 25.9454 29.3168C26.8922 29.1219 26.8468 31.1992 26.8655 31.8666ZM14.6969 37.238H13.2941L12.9464 38.4417H11.8287L13.3078 33.8328H14.7247L16.246 38.4419H15.079L14.6969 37.238ZM13.4538 36.4583H14.5302C14.2477 35.5579 14.0648 34.9402 13.9815 34.605H13.9676L13.7455 35.4805L13.4538 36.4583ZM9.54448 37.238H8.1419L7.79419 38.4417H6.67651L8.15559 33.8326H9.57208L11.0933 38.4417H9.92631L9.54448 37.238ZM8.30141 36.4583H9.37758C9.09535 35.5579 8.91259 34.9402 8.82928 34.605H8.81537L8.59327 35.4805L8.30141 36.4583ZM17.3143 38.4211V33.894C17.8064 33.8238 18.3032 33.7896 18.8006 33.7917C19.7983 33.7917 20.5145 33.9974 20.949 34.4087C21.1661 34.6183 21.3361 34.8701 21.4481 35.1478C21.5601 35.4255 21.6116 35.723 21.5994 36.0213C21.5994 36.8055 21.3525 37.413 20.8586 37.8439C20.3647 38.2748 19.6022 38.4901 18.5713 38.49C18.1513 38.4931 17.7313 38.47 17.3143 38.4211ZM18.3909 34.6463V37.6486C18.5197 37.667 18.6499 37.6741 18.7799 37.6699C19.0047 37.6837 19.23 37.654 19.4431 37.5826C19.6562 37.5112 19.8528 37.3993 20.0217 37.2535C20.1748 37.0953 20.2929 36.9078 20.3683 36.7028C20.4438 36.4977 20.4751 36.2796 20.4602 36.0621C20.4743 35.8641 20.4459 35.6654 20.377 35.4788C20.308 35.2921 20.2001 35.1216 20.0599 34.9782C19.7392 34.7113 19.3246 34.5776 18.9046 34.6055C18.7325 34.6022 18.5602 34.6158 18.3909 34.6463ZM22.7514 33.8326H23.8282V35.6035H25.6685V33.8328H26.7449V38.4419H25.6685V36.5204H23.8282V38.4419H22.7516L22.7514 33.8326ZM30.6473 37.238H29.2445L28.8968 38.4417H27.7791L29.2582 33.8326H30.6749L32.1961 38.4417H31.0296L30.6473 37.238ZM29.4042 36.4583H30.4804C30.1982 35.5579 30.0153 34.9402 29.9319 34.605H29.918L29.6957 35.4805L29.4042 36.4583ZM35.7995 37.238H34.3967L34.049 38.4417H32.9318L34.4108 33.8326H35.8275L37.3488 38.4417H36.1807L35.7995 37.238ZM34.5562 36.4583H35.6326C35.3504 35.5579 35.1675 34.9402 35.0841 34.605H35.0704L34.8481 35.4805L34.5562 36.4583ZM38.4169 38.4417V33.894C38.8968 33.8194 39.3823 33.7852 39.8682 33.7917C40.5766 33.7917 41.0859 33.9067 41.3961 34.1368C41.5499 34.252 41.6727 34.4023 41.7538 34.5745C41.8348 34.7467 41.8718 34.9356 41.8614 35.125C41.8635 35.3744 41.7814 35.6176 41.6278 35.8166C41.4762 36.0197 41.2644 36.1721 41.0213 36.2532V36.2806C41.3129 36.3877 41.5236 36.6703 41.6532 37.1284C41.8916 37.9537 42.0212 38.3915 42.0422 38.4417H40.945C40.7956 38.0963 40.6838 37.7364 40.6116 37.368C40.577 37.1571 40.4859 36.9589 40.3478 36.7936C40.2741 36.733 40.1888 36.6873 40.097 36.6591C40.0052 36.631 39.9086 36.6208 39.8127 36.6293H39.4796V38.4417H38.4169ZM39.4794 34.6053V35.8705H39.9238C40.1504 35.8827 40.3745 35.819 40.5592 35.69C40.6346 35.6335 40.695 35.5602 40.7355 35.4761C40.776 35.3921 40.7954 35.2998 40.792 35.2069C40.7971 35.1178 40.7808 35.0288 40.7444 34.9471C40.7079 34.8653 40.6524 34.793 40.5823 34.7361C40.4088 34.6157 40.1984 34.5574 39.9862 34.5708C39.8166 34.5644 39.6464 34.5758 39.4794 34.6053ZM20.4205 31.8706L21.853 31.8664C22.0412 30.675 21.6731 29.7574 20.4491 29.9759C19.4173 30.1606 18.3092 31.1696 17.6398 31.8664L19.5288 31.8583C19.7394 31.7219 20.1512 31.5666 20.3205 31.6823C20.352 31.7031 20.3777 31.7312 20.3954 31.7641C20.4131 31.797 20.4222 31.8336 20.422 31.8708L20.4205 31.8706ZM35.0391 31.8672H35.0521H35.0587C35.2009 31.8699 35.3412 31.8352 35.4651 31.7668C35.589 31.6984 35.6919 31.5988 35.7632 31.4783C35.8036 31.4105 35.8352 31.338 35.8575 31.2626C35.8846 31.1706 35.9013 31.076 35.9071 30.9805L35.9082 30.9592C36.0514 26.0299 34.5173 21.9492 31.9154 19.1765C31.4145 18.6427 30.8674 18.1525 30.28 17.7113C29.6994 17.2753 29.0803 16.8908 28.43 16.5624L28.4198 16.5571C26.225 15.4741 23.7636 15.0164 21.316 15.2364C20.366 15.3154 19.4266 15.489 18.5126 15.7546L18.5063 15.7566C15.9463 16.5385 13.6298 17.9416 11.7724 19.8353C11.4024 20.2055 11.0498 20.5917 10.7145 20.9939C10.5484 21.1934 10.3867 21.3964 10.2295 21.603C11.5348 20.4821 12.9621 19.505 14.4855 18.6893C14.8222 18.5115 15.1604 18.3452 15.5001 18.1902C15.8399 18.0351 16.184 17.8909 16.5324 17.7574H16.5337C17.7929 17.2672 19.1124 16.9404 20.4583 16.7856C21.7661 16.6427 23.0878 16.6755 24.3865 16.883C25.309 17.0219 26.2115 17.2669 27.0752 17.613C27.2358 17.6787 27.394 17.7489 27.5488 17.8227C27.7035 17.8966 27.8517 17.9734 27.999 18.0551L28.0012 18.0563C30.9176 19.6275 32.9426 22.8529 33.8349 26.4943C34.1853 27.9264 34.3576 29.3947 34.3478 30.8673V30.9098C34.3389 31.0747 34.3693 31.2393 34.4365 31.3906C34.5037 31.542 34.6059 31.676 34.7351 31.7821C34.7789 31.8101 34.8267 31.8316 34.877 31.8459C34.9302 31.8608 34.9853 31.868 35.0406 31.8674L35.0391 31.8672Z" fill="#D32828"/>
</g>
<defs>
<clipPath id="clip0_179_609">
<rect width="45.9" height="29.738" fill="white" transform="translate(1.05005 9.13098)"/>
</clipPath>
</defs>
</svg>
''';

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
