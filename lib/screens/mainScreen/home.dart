import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'components/bottom_nav.dart';
import '../../utils/responsive.dart';
import '../../services/storage_service.dart';
import 'withdraw.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();
  String _userName = 'User';
  double _salary = 0.0;
  String _kycStatus = 'NOT_STARTED';
  bool _isLoading = true;
  bool _isSalaryVisible = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _storageService.getUserData();
      final employeeData = await _storageService.getEmployeeData();
      final kycStatus = await _storageService.getKycStatus();

      if (mounted) {
        setState(() {
          if (userData != null) {
            _userName =
                '${userData['first_name'] ?? ''} ${userData['last_name'] ?? ''}'
                    .trim();
            if (_userName.isEmpty) _userName = 'User';
          }

          if (employeeData != null) {
            _salary = (employeeData['salary'] ?? 0).toDouble();
          }

          if (kycStatus != null) {
            _kycStatus = kycStatus['kyc_status'] ?? 'NOT_STARTED';
          }

          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F0FA),
      bottomNavigationBar: BottomNavBar(
        responsive: responsive,
        currentIndex: 0,
        onTap: (index) {
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WithdrawScreen()),
            );
          }
        },
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SvgPicture.string(
              _headerSvg,
              width: responsive.screenWidth,
              height: responsive.height(10) + statusBarHeight,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: PurpleShape(
                    height: responsive.height(150),
                    borderRadius: responsive.radius(42),
                  ),
                ),

                Positioned(
                  top: responsive.height(20),
                  left: responsive.padding(24),
                  right: responsive.padding(24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: responsive.width(50),
                              height: responsive.width(50),
                              child: CircleAvatar(
                                radius: responsive.width(50) / 2,
                                backgroundImage: const NetworkImage(
                                  'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=200',
                                ),
                              ),
                            ),
                            SizedBox(width: responsive.width(12)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Welcome,',
                                  style: TextStyle(
                                    fontSize: responsive.fontSize(14),
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                                SizedBox(height: responsive.height(4)),
                                Text(
                                  _isLoading ? 'Loading...' : _userName,
                                  style: TextStyle(
                                    fontSize: responsive.fontSize(18),
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      _ActionIcon(child: _HelpIcon(responsive: responsive)),
                      SizedBox(width: responsive.width(12)),
                      _NotificationIcon(responsive: responsive),
                    ],
                  ),
                ),
                Positioned(
                  top: responsive.height(100),
                  left: 0,
                  right: 0,
                  bottom: responsive.height(1),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.padding(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeInSlide(
                          duration: const Duration(milliseconds: 600),
                          child: _SummaryCard(
                            responsive: responsive,
                            salary: _salary,
                            kycStatus: _kycStatus,
                            isSalaryVisible: _isSalaryVisible,
                            onToggleVisibility: () {
                              setState(() {
                                _isSalaryVisible = !_isSalaryVisible;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: responsive.height(20)),
                        FadeInSlide(
                          duration: const Duration(milliseconds: 600),
                          delay: const Duration(milliseconds: 200),
                          child: _PromoBannerSlider(responsive: responsive),
                        ),
                        SizedBox(height: responsive.height(24)),
                        FadeInSlide(
                          duration: const Duration(milliseconds: 600),
                          delay: const Duration(milliseconds: 400),
                          child: _EssentialsSection(responsive: responsive),
                        ),
                        SizedBox(height: responsive.height(20)),
                      ],
                    ),
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

const String _headerSvg = '''
<svg width="375" height="210" viewBox="0 0 375 210" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M0 0H375V178C375 195.673 360.673 210 343 210H32C14.3269 210 0 195.673 0 178V0Z" fill="#482983"/>
</svg>
''';

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({this.icon, this.child})
    : assert(icon != null || child != null);

  final IconData? icon;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final iconSize = r.width(40);

    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
        ),
        child: Center(
          child: child ?? Icon(icon, color: Colors.white, size: r.fontSize(22)),
        ),
      ),
    );
  }
}

class _HelpIcon extends StatelessWidget {
  const _HelpIcon({required this.responsive});

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    final size = responsive.width(20);
    return SvgPicture.string(_helpIconSvg, width: size, height: size);
  }
}

const String _helpIconSvg = '''
<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<g clip-path="url(#clip0_213_994)">
<path d="M9.80157 2.25586C11.6089 2.25586 14.1062 2.49357 14.9073 2.65379C14.9099 2.65417 14.9126 2.65492 14.9152 2.65529C16.0071 2.86717 17.1272 3.93669 17.3657 4.99385C17.621 6.22732 17.7411 7.45669 17.7438 8.86236C17.7411 10.2677 17.621 11.4974 17.3657 12.7309C17.1272 13.7877 16.0071 14.8576 14.9152 15.0694C14.9126 15.0698 14.9099 15.0706 14.9073 15.0709C14.4281 15.1668 13.4211 15.2806 12.3412 15.3611C11.8938 15.3944 11.488 15.637 11.2469 16.0154C11.1178 16.2179 10.98 16.4306 10.837 16.6473C10.362 17.3668 9.94083 17.965 9.58333 18.4292C9.22582 17.965 8.80468 17.3668 8.32963 16.6473C8.18663 16.4306 8.0485 16.2179 7.91972 16.0154C7.67864 15.637 7.27322 15.3944 6.8255 15.3611C5.74588 15.2806 4.73851 15.1668 4.25934 15.0709C4.25672 15.0706 4.2541 15.0698 4.25148 15.0694C3.1595 14.8576 2.03945 13.788 1.80099 12.7309C1.54569 11.4974 1.42552 10.268 1.4229 8.86236C1.42552 7.45669 1.54569 6.22732 1.80099 4.99385C2.03945 3.93706 3.1595 2.86755 4.25148 2.65566C4.2541 2.65529 4.25672 2.65454 4.25934 2.65417C5.06082 2.49395 7.55772 2.25623 9.36508 2.25623C9.43396 2.25623 9.50134 2.25624 9.5676 2.25736H9.58333C9.58333 2.25736 9.59381 2.25736 9.59905 2.25736C9.66531 2.25661 9.73269 2.25623 9.80157 2.25623M9.36508 0.833336C7.53526 0.833336 4.93616 1.06768 3.98045 1.2586C2.34829 1.57529 0.77041 3.06633 0.409912 4.69399C0.204769 5.68227 0.00299479 7.02693 0 8.86236C0.00299479 10.6978 0.204769 12.0421 0.409912 13.0304C0.77041 14.658 2.34829 16.1491 3.98045 16.4658C4.51727 16.5732 5.5733 16.6941 6.71956 16.7795C6.84946 16.9835 6.99021 17.2006 7.14257 17.4308C7.75089 18.3521 8.21658 18.9941 8.56921 19.4415C8.8627 19.8136 9.2232 19.9996 9.58333 19.9996C9.94345 19.9996 10.3039 19.8136 10.5974 19.4415C10.9501 18.9941 11.4154 18.3521 12.0241 17.4308C12.1764 17.2002 12.3168 16.9835 12.4471 16.7795C13.5937 16.6941 14.6494 16.5732 15.1866 16.4658C16.8187 16.1491 18.3966 14.658 18.7571 13.0304C18.9623 12.0421 19.164 10.6978 19.167 8.86236C19.164 7.02693 18.9623 5.68265 18.7571 4.69437C18.3966 3.0667 16.8187 1.57567 15.1866 1.25897C14.2305 1.06768 11.6314 0.833336 9.80157 0.833336C9.72745 0.833336 9.65483 0.83371 9.58333 0.834459C9.5122 0.83371 9.4392 0.833336 9.36508 0.833336Z" fill="white"/>
<path d="M10.6422 14.4458C10.6018 14.6738 10.3951 14.8804 10.1672 14.9208C10.029 14.9437 9.84074 14.9654 9.58356 14.9657C9.32676 14.9657 9.13846 14.944 8.99995 14.9208C8.77197 14.8804 8.56533 14.6738 8.5249 14.4458C8.50207 14.3076 8.48035 14.1193 8.47998 13.8622C8.47998 13.6054 8.50169 13.4171 8.5249 13.2786C8.56533 13.0506 8.77197 12.8439 8.99995 12.8035C9.13809 12.7807 9.32638 12.759 9.58356 12.7586C9.84036 12.7586 10.0287 12.7803 10.1672 12.8035C10.3951 12.8439 10.6018 13.0506 10.6422 13.2786C10.6651 13.4167 10.6868 13.605 10.6871 13.8622C10.6871 14.119 10.6654 14.3073 10.6422 14.4458Z" fill="white"/>
<path d="M9.54449 11.6295C9.18661 11.6295 8.87853 11.36 8.83847 10.9961C8.83323 10.9467 8.78943 10.4994 8.92682 9.96332C9.1226 9.20002 9.58305 8.61866 10.2584 8.28324C11.4945 7.66856 11.5903 6.97377 11.5903 6.77537C11.5903 6.62713 11.5319 6.30369 11.3137 6.03229C11.0209 5.66879 10.5141 5.48461 9.80691 5.48461C9.09977 5.48461 8.63071 5.7242 8.26422 6.21721C7.9902 6.58557 7.90297 6.95618 7.90222 6.95955C7.82099 7.344 7.44365 7.58958 7.05919 7.50797C6.67474 7.42673 6.42916 7.04902 6.51077 6.66493C6.525 6.59718 6.66425 5.98512 7.12283 5.36819C7.56606 4.77223 8.3915 4.06171 9.80728 4.06171C12.3435 4.06171 13.0136 5.8365 13.0136 6.77462C13.0136 7.29384 12.8069 8.60443 10.8925 9.55603C10.1603 9.9199 10.252 10.8303 10.2531 10.8393C10.2962 11.2297 10.0147 11.5813 9.62423 11.6243C9.59765 11.6273 9.57144 11.6288 9.54524 11.6288L9.54449 11.6295Z" fill="white"/>
</g>
<defs>
<clipPath id="clip0_213_994">
<rect width="20" height="20" fill="white"/>
</clipPath>
</defs>
</svg>
''';

class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon({required this.responsive});

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    final iconSize = responsive.width(40);
    final size = responsive.width(20);

    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
        ),
        child: Center(
          child: SvgPicture.string(
            _notificationIconSvg,
            width: size,
            height: size,
          ),
        ),
      ),
    );
  }
}

const String _notificationIconSvg = '''
<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<g clip-path="url(#clip0_213_1001)">
<path d="M8.55664 17.5C8.70293 17.7533 8.91332 17.9637 9.16668 18.11C9.42003 18.2563 9.70743 18.3333 9.99997 18.3333C10.2925 18.3333 10.5799 18.2563 10.8333 18.11C11.0866 17.9637 11.297 17.7533 11.4433 17.5" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M11.5965 1.92822C10.8444 1.67478 10.0427 1.60402 9.25788 1.72179C8.47301 1.83956 7.72746 2.14247 7.08286 2.60548C6.43826 3.06849 5.91314 3.67829 5.55092 4.38447C5.1887 5.09065 4.99979 5.8729 4.99981 6.66656C4.99981 10.4157 3.82398 11.6299 2.71648 12.7724C2.60779 12.8918 2.53615 13.0403 2.51028 13.1997C2.4844 13.3591 2.50541 13.5226 2.57074 13.6703C2.63606 13.818 2.7429 13.9435 2.87826 14.0316C3.01361 14.1197 3.17164 14.1666 3.33314 14.1666H16.6665C16.828 14.1666 16.986 14.1197 17.1214 14.0316C17.2567 13.9435 17.3636 13.818 17.4289 13.6703C17.4942 13.5226 17.5152 13.3591 17.4893 13.1997C17.4635 13.0403 17.3918 12.8918 17.2831 12.7724C17.1116 12.5958 16.949 12.4108 16.7956 12.2182" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M15 9.16671C16.3807 9.16671 17.5 8.04742 17.5 6.66671C17.5 5.286 16.3807 4.16671 15 4.16671C13.6193 4.16671 12.5 5.286 12.5 6.66671C12.5 8.04742 13.6193 9.16671 15 9.16671Z" fill="#DF232C"/>
</g>
<defs>
<clipPath id="clip0_213_1001">
<rect width="20" height="20" fill="white"/>
</clipPath>
</defs>
</svg>
''';

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.responsive,
    required this.salary,
    required this.kycStatus,
    required this.isSalaryVisible,
    required this.onToggleVisibility,
  });

  final Responsive responsive;
  final double salary;
  final String kycStatus;
  final bool isSalaryVisible;
  final VoidCallback onToggleVisibility;

  @override
  Widget build(BuildContext context) {
    final cardWidth = responsive.screenWidth - (responsive.padding(24) * 2);
    final cardHeight = responsive.height(180);
    final cardRadius = responsive.radius(15.64);

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cardRadius),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5F2E97).withValues(alpha: 0.1),
            offset: Offset(0, responsive.height(-2)),
            blurRadius: responsive.width(5.6),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cardRadius),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.all(Radius.circular(cardRadius)),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: responsive.height(0.5),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFFFFF), // white
                      Color(0xFF6B3E9F), // purple rgba(107, 62, 159, 1)
                      Color(0xFFFFFFFF), // white
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              top: responsive.height(18),
              left: responsive.width(18),
              child: _SalaryComponent(
                responsive: responsive,
                salary: salary,
                isSalaryVisible: isSalaryVisible,
                onToggleVisibility: onToggleVisibility,
              ),
            ),
            Positioned(
              top: responsive.height(23.85),
              right: responsive.width(18),
              child: _WalletIcon(responsive: responsive),
            ),
            Positioned(
              top: responsive.height(90),
              left: responsive.width(18),
              child: _TimelineComponent(responsive: responsive),
            ),
            Positioned(
              top: responsive.height(135),
              left: responsive.width(18),
              child: _WithdrawButton(responsive: responsive),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: _DecorativeCircles(responsive: responsive),
            ),
          ],
        ),
      ),
    );
  }
}

class _SalaryComponent extends StatelessWidget {
  const _SalaryComponent({
    required this.responsive,
    required this.salary,
    required this.isSalaryVisible,
    required this.onToggleVisibility,
  });

  final Responsive responsive;
  final double salary;
  final bool isSalaryVisible;
  final VoidCallback onToggleVisibility;

  @override
  Widget build(BuildContext context) {
    final componentWidth = responsive.width(142);
    final componentHeight = responsive.height(81);

    return SizedBox(
      width: componentWidth,
      height: componentHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Monthly Salary',
            style: TextStyle(
              fontSize: responsive.fontSize(14),
              fontWeight: FontWeight.w400,
              color: const Color(0xFF161616),
              height: 1.0,
            ),
          ),
          SizedBox(height: responsive.height(8)),
          SizedBox(
            width: componentWidth,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    isSalaryVisible
                        ? '₹ ${salary.toStringAsFixed(2)}'
                        : '₹ ••••••',
                    style: TextStyle(
                      fontSize: responsive.fontSize(24),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF482983),
                      height: 1.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: responsive.width(4)),
                GestureDetector(
                  onTap: onToggleVisibility,
                  child: _VisibilityIcon(
                    responsive: responsive,
                    isVisible: isSalaryVisible,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: responsive.height(8)),
          Text(
            "This month's earnings",
            style: TextStyle(
              fontSize: responsive.fontSize(12),
              fontWeight: FontWeight.w400,
              color: const Color(0xFF999999),
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class PurpleShape extends StatelessWidget {
  const PurpleShape({
    super.key,
    required this.height,
    required this.borderRadius,
  });

  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return CustomPaint(
      size: Size(deviceWidth, height),
      painter: _PurpleShapePainter(borderRadius),
    );
  }
}

class _PurpleShapePainter extends CustomPainter {
  const _PurpleShapePainter(this.radius);

  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF482983);

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - radius)
      ..quadraticBezierTo(
        size.width,
        size.height,
        size.width - radius,
        size.height,
      )
      ..lineTo(radius, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - radius)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _VisibilityIcon extends StatelessWidget {
  const _VisibilityIcon({required this.responsive, required this.isVisible});

  final Responsive responsive;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    final size = responsive.width(20);
    return SvgPicture.string(
      isVisible ? _visibilityOnIconSvg : _visibilityIconSvg,
      width: size,
      height: size,
    );
  }
}

const String _visibilityIconSvg = '''
<svg width="29" height="29" viewBox="0 0 29 29" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M24.7566 5.46264C24.9163 5.2912 25.0033 5.06443 24.9991 4.83013C24.995 4.59583 24.9001 4.37228 24.7344 4.20658C24.5687 4.04087 24.3451 3.94596 24.1108 3.94182C23.8765 3.93769 23.6498 4.02466 23.4783 4.18441L4.18434 23.4784C4.09548 23.5612 4.02421 23.661 3.97478 23.772C3.92535 23.8829 3.89877 24.0027 3.89663 24.1241C3.89448 24.2456 3.91682 24.3662 3.96231 24.4788C4.00779 24.5914 4.0755 24.6937 4.16138 24.7796C4.24726 24.8655 4.34956 24.9332 4.46217 24.9787C4.57479 25.0241 4.69541 25.0465 4.81684 25.0443C4.93828 25.0422 5.05804 25.0156 5.16898 24.9662C5.27992 24.9168 5.37977 24.8455 5.46256 24.7566L8.89569 21.3235C10.5441 22.1001 12.441 22.6102 14.4704 22.6102C17.707 22.6102 20.6083 21.3114 22.6945 19.71C23.74 18.9081 24.6034 18.0134 25.2136 17.1343C25.8069 16.2793 26.2277 15.3424 26.2277 14.4705C26.2277 13.5987 25.8057 12.6617 25.2136 11.8067C24.6034 10.9277 23.74 10.0341 22.6957 9.231C22.379 8.98741 22.0445 8.75307 21.6924 8.52797L24.7566 5.46264ZM20.3792 9.84117L18.2436 11.9768C18.8194 12.8464 19.0769 13.8883 18.9725 14.9259C18.8681 15.9636 18.4082 16.9333 17.6707 17.6708C16.9333 18.4083 15.9636 18.8681 14.9259 18.9725C13.8882 19.077 12.8463 18.8195 11.9767 18.2437L10.268 19.9512C11.6011 20.5022 13.028 20.7909 14.4704 20.8014C17.2283 20.8014 19.7522 19.6883 21.5935 18.2751C22.5124 17.5696 23.2384 16.8063 23.7279 16.1033C24.2332 15.3749 24.4189 14.8046 24.4189 14.4705C24.4189 14.1365 24.2332 13.5661 23.7279 12.8378C23.2384 12.1347 22.5124 11.3714 21.5935 10.666C21.2157 10.3758 20.8117 10.1008 20.3792 9.84117ZM13.2995 16.9197C13.8058 17.1615 14.3747 17.2404 14.9277 17.1455C15.4806 17.0506 15.9906 16.7866 16.3874 16.3899C16.7841 15.9931 17.0481 15.4831 17.143 14.9301C17.2379 14.3771 17.159 13.8083 16.9172 13.302L13.2995 16.9197Z" fill="#482983"/>
<path d="M14.4707 6.33083C15.7151 6.33083 16.9113 6.52377 18.0292 6.85056C18.0781 6.86516 18.1224 6.8923 18.1576 6.92929C18.1929 6.96628 18.2178 7.01184 18.23 7.06143C18.2422 7.11103 18.2412 7.16296 18.2271 7.21206C18.213 7.26116 18.1864 7.30573 18.1498 7.34135L17.1561 8.3362C17.1195 8.37319 17.074 8.40007 17.0239 8.41423C16.9738 8.42839 16.9209 8.42934 16.8703 8.41699C16.0833 8.23553 15.2784 8.1425 14.4707 8.13964C11.7128 8.13964 9.18893 9.25266 7.34756 10.6659C6.42868 11.3714 5.70274 12.1347 5.21316 12.8377C4.7079 13.5661 4.52219 14.1365 4.52219 14.4705C4.52219 14.8045 4.7079 15.3749 5.21316 16.1032C5.64004 16.7182 6.2478 17.3778 7.0075 18.0049C7.14738 18.1195 7.16065 18.3305 7.03162 18.4595L6.17786 19.3145C6.12557 19.3675 6.05524 19.3989 5.98085 19.4025C5.90645 19.4061 5.83343 19.3816 5.7763 19.3338C4.99973 18.6938 4.31088 17.9542 3.72752 17.1343C3.13544 16.2793 2.71338 15.3423 2.71338 14.4705C2.71338 13.5986 3.13544 12.6617 3.72752 11.8067C4.33769 10.9276 5.2011 10.0341 6.24539 9.23095C8.33276 7.62955 11.2341 6.33083 14.4707 6.33083Z" fill="#482983"/>
<path d="M14.4703 9.94846C14.6134 9.94846 14.7545 9.95489 14.8936 9.96775C15.1312 9.99066 15.2168 10.274 15.0492 10.4429L13.5864 11.9044C13.1971 12.0394 12.8435 12.2609 12.5521 12.5522C12.2607 12.8436 12.0392 13.1973 11.9042 13.5866L10.4427 15.0493C10.2739 15.2181 9.99052 15.1313 9.96761 14.8937C9.90868 14.2669 9.98129 13.6347 10.1808 13.0376C10.3803 12.4405 10.7023 11.8916 11.1261 11.426C11.55 10.9605 12.0664 10.5886 12.6422 10.3342C13.2181 10.0798 13.8408 9.94838 14.4703 9.94846Z" fill="#482983"/>
</svg>
''';

const String _visibilityOnIconSvg = '''
<svg width="29" height="29" viewBox="0 0 29 29" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M14.5 6C8.5 6 3.73 9.61 1 14.5C3.73 19.39 8.5 23 14.5 23C20.5 23 25.27 19.39 28 14.5C25.27 9.61 20.5 6 14.5 6ZM14.5 20C11.74 20 9.5 17.76 9.5 15C9.5 12.24 11.74 10 14.5 10C17.26 10 19.5 12.24 19.5 15C19.5 17.76 17.26 20 14.5 20ZM14.5 12C12.84 12 11.5 13.34 11.5 15C11.5 16.66 12.84 18 14.5 18C16.16 18 17.5 16.66 17.5 15C17.5 13.34 16.16 12 14.5 12Z" fill="#482983"/>
</svg>
''';

class _WalletIcon extends StatelessWidget {
  const _WalletIcon({required this.responsive});

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _walletIconSvg,
      width: responsive.width(90),
      height: responsive.height(86),
    );
  }
}

const String _walletIconSvg = '''
<svg width="90" height="86" viewBox="0 0 90 86" fill="none" xmlns="http://www.w3.org/2000/svg">
<rect width="90" height="85.0238" rx="4" fill="#482983" fill-opacity="0.02"/>
<path d="M85 11.95V38.825C85 41.5624 82.7753 43.7749 80.0378 43.7749H9.95026C7.21252 43.7749 5 41.5624 5 38.825V11.95C5 9.21252 7.21252 7 9.95026 7H80.0378C82.7753 7 85 9.21252 85 11.95Z" fill="#C0ADD6"/>
<path d="M85 11.95V38.825C85 41.5624 82.7753 43.7749 80.0378 43.7749H9.95026C7.21252 43.7749 5 41.5624 5 38.825L80.0378 7C82.7753 7 85 9.21252 85 11.95Z" fill="#AA88D2"/>
<path d="M77.5 22.2124V28.5625C77.5 29.9498 76.3876 31.0625 75 31.0625H15C13.6127 31.0625 12.5 29.9498 12.5 28.5625V22.2124C12.5 20.8251 13.6127 19.7124 15 19.7124H75C76.3876 19.7124 77.5 20.8251 77.5 22.2124Z" fill="#33527D"/>
<path d="M72.5128 43.4499C72.5128 58.6498 60.1877 70.9624 45 70.9624C29.8126 70.9624 17.4878 58.6498 17.4878 43.4499C17.4878 38.9998 18.5501 34.7875 20.4501 31.0625C22.8253 26.3375 26.5625 22.3876 31.1252 19.7124H58.8751C63.4375 22.3876 67.1753 26.3375 69.5502 31.0625C71.4502 34.7875 72.5128 38.9998 72.5128 43.4499Z" fill="#FFD80C"/>
<path d="M64.0754 43.4538C64.0754 53.9905 55.5372 62.5291 45.0001 62.5291C34.463 62.5291 25.9248 53.9905 25.9248 43.4538C25.9248 32.9343 34.463 24.3957 45.0001 24.3957C55.5372 24.3957 64.0754 32.9343 64.0754 43.4538Z" fill="#FFBE00"/>
<path d="M59.6571 31.2863C56.3787 28.5862 52.1711 26.9734 47.5773 26.9734C37.0402 26.9734 28.502 35.5119 28.502 46.0315C28.502 50.6424 30.1325 54.8851 32.8676 58.1639C28.6249 54.6745 25.9248 49.3797 25.9248 43.4538C25.9248 32.9343 34.463 24.3957 45.0001 24.3957C50.9088 24.3957 56.1686 27.0778 59.6571 31.2863Z" fill="#FFA300"/>
<path d="M51.8694 47.8019C51.8694 50.6499 49.8515 53.0822 47.0872 53.9123V55.0177C47.0872 56.1502 46.1471 57.091 45.014 57.091C43.8532 57.091 42.9407 56.1502 42.9407 55.0177V53.9123C40.1488 53.0822 38.1309 50.6499 38.1309 47.8019C38.1309 46.6411 39.0703 45.7287 40.2041 45.7287C41.3649 45.7287 42.2773 46.6411 42.2773 47.8019C42.2773 49.0464 43.5211 50.0412 45.014 50.0412C46.5068 50.0412 47.723 49.0464 47.723 47.8019C47.723 46.5588 46.5068 45.5357 45.014 45.5357C41.2272 45.5357 38.1309 42.6607 38.1309 39.1229C38.1309 36.2749 40.1488 33.8426 42.9407 33.0125V31.9071C42.9407 30.7746 43.8532 29.8338 45.014 29.8338C46.1471 29.8338 47.0872 30.7746 47.0872 31.9071V33.0125C49.8515 33.8426 51.8694 36.2749 51.8694 39.1229C51.8694 40.2837 50.9577 41.1962 49.7962 41.1962C48.6631 41.1962 47.723 40.2837 47.723 39.1229C47.723 37.8784 46.5068 36.8837 45.014 36.8837C43.5211 36.8837 42.2773 37.8784 42.2773 39.1229C42.2773 40.366 43.5211 41.3892 45.014 41.3892C48.8008 41.3892 51.8694 44.2642 51.8694 47.8019Z" fill="#FFD80C"/>
<path d="M13.0577 68.2031C13.1136 67.8523 13.3402 67.5232 13.6483 67.3145L18.2306 64.2111C18.5387 64.0024 18.9153 63.923 19.2749 63.9925C19.6477 64.0525 19.968 64.2655 20.1767 64.5737C20.2584 64.6944 20.3131 64.8329 20.3637 64.9943C20.5206 65.5718 20.2602 66.1976 19.7375 66.5517L15.2625 69.5824C14.7398 69.9364 14.0623 69.9457 13.5839 69.586C13.1463 69.2568 12.9449 68.729 13.0577 68.2031Z" fill="#BD83FF"/>
<path d="M21.6103 70.9321C21.6838 70.5502 21.8833 70.239 22.1915 70.0303C22.6337 69.7307 23.199 69.6996 23.6588 69.9746C23.8391 70.0677 23.9972 70.2144 24.1062 70.3754C24.324 70.6969 24.4077 71.1093 24.3299 71.5137L23.3093 76.8176C23.1883 77.4463 22.7114 77.9258 22.124 78.0111C21.5861 78.082 21.0592 77.8529 20.7597 77.4106C20.5601 77.1159 20.4946 76.7303 20.5546 76.3575L21.6103 70.9321Z" fill="#BD83FF"/>
<path d="M8.83573 57.3224C9.14387 57.1137 9.52944 57.0482 9.88903 57.1177L15.3277 58.1639C15.687 58.233 16.0208 58.4369 16.2295 58.7451C16.529 59.1873 16.5377 59.7483 16.2851 60.2124C15.9748 60.7356 15.3529 61.0002 14.7235 60.8791L9.41966 59.8586C8.81306 59.7421 8.3339 59.265 8.23978 58.6645C8.16435 58.1488 8.39347 57.6219 8.83573 57.3224Z" fill="#BD83FF"/>
<path d="M76.9426 68.2031C76.8868 67.8523 76.6602 67.5232 76.352 67.3145L71.7698 64.2111C71.4616 64.0024 71.0851 63.923 70.7255 63.9925C70.3527 64.0525 70.0324 64.2655 69.8237 64.5737C69.7419 64.6944 69.6872 64.8329 69.6366 64.9943C69.4798 65.5718 69.7402 66.1976 70.2629 66.5517L74.7378 69.5824C75.2606 69.9364 75.938 69.9457 76.4164 69.586C76.8541 69.2568 77.0555 68.729 76.9426 68.2031Z" fill="#BD83FF"/>
<path d="M68.3902 70.9321C68.3167 70.5502 68.1171 70.239 67.809 70.0303C67.3667 69.7307 66.8014 69.6996 66.3417 69.9746C66.1613 70.0677 66.0032 70.2144 65.8942 70.3754C65.6765 70.6969 65.5928 71.1093 65.6706 71.5137L66.6912 76.8176C66.8122 77.4463 67.2891 77.9258 67.8764 78.0111C68.4144 78.082 68.9413 77.8529 69.2408 77.4106C69.4404 77.1159 69.5059 76.7303 69.4458 76.3575L68.3902 70.9321Z" fill="#BD83FF"/>
<path d="M81.1645 57.3224C80.8563 57.1137 80.4707 57.0482 80.1112 57.1177L74.6725 58.1639C74.3131 58.233 73.9794 58.4369 73.7707 58.7451C73.4712 59.1873 73.4625 59.7483 73.7151 60.2124C74.0254 60.7356 74.6473 61.0002 75.2766 60.8791L80.5805 59.8586C81.1871 59.7421 81.6663 59.265 81.7604 58.6645C81.8358 58.1488 81.6067 57.6219 81.1645 57.3224Z" fill="#BD83FF"/>
</svg>
''';

class _TimelineComponent extends StatelessWidget {
  const _TimelineComponent({required this.responsive});

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentDay = now.day;
    final currentMonth = now.month;
    final currentYear = now.year;

    final daysInMonth = DateTime(currentYear, currentMonth + 1, 0).day;

    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final monthName = monthNames[currentMonth - 1];

    final barWidth = responsive.width(7);
    final barWidthSmall = responsive.width(6);
    final barHeight = responsive.height(11);
    final barHeightTall = responsive.height(17);
    final barGap = responsive.width(4);
    final barRadius = responsive.radius(22);

    final numberOfBars = ((daysInMonth - 1) / 2).ceil() + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int barIndex = 0; barIndex < numberOfBars; barIndex++) ...[
                  Builder(
                    builder: (context) {
                      final startDay = (barIndex * 2) + 1;

                      final isPassed = startDay <= currentDay;

                      final isLastBar = barIndex == numberOfBars - 1;

                      return Container(
                        width: isLastBar ? barWidth : barWidthSmall,
                        height: isLastBar ? barHeightTall : barHeight,
                        decoration: BoxDecoration(
                          color: isPassed
                              ? const Color(0xFF5F2E97)
                              : const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(barRadius),
                        ),
                      );
                    },
                  ),
                  if (barIndex < numberOfBars - 1) SizedBox(width: barGap),
                ],
              ],
            ),
            Positioned(
              top: barHeightTall + responsive.height(4),
              left: 0,
              child: Text(
                '1 $monthName',
                style: TextStyle(
                  fontSize: responsive.fontSize(12),
                  fontWeight: FontWeight.w400,
                  height: 12.8 / 12,
                  letterSpacing: 0,
                  color: const Color(0xFF161616),
                ),
              ),
            ),
            Positioned(
              top: barHeightTall + responsive.height(4),
              right: 0,
              child: Text(
                '$daysInMonth $monthName',
                style: TextStyle(
                  fontSize: responsive.fontSize(12),
                  fontWeight: FontWeight.w400,
                  height: 12.8 / 12,
                  letterSpacing: 0,
                  color: const Color(0xFF161616),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WithdrawButton extends StatelessWidget {
  const _WithdrawButton({required this.responsive});

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const WithdrawScreen()),
        );
      },
      child: Container(
        width: responsive.width(125),
        height: responsive.height(31),
        padding: EdgeInsets.only(
          top: responsive.height(4),
          right: responsive.width(12),
          bottom: responsive.height(4),
          left: responsive.width(12),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF482983),
          borderRadius: BorderRadius.circular(responsive.radius(14)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _WalletButtonIcon(responsive: responsive),
            SizedBox(width: responsive.width(10)),
            Text(
              'Withdraw',
              style: TextStyle(
                fontSize: responsive.fontSize(12),
                fontWeight: FontWeight.w600,
                height: 1.3,
                letterSpacing: 0,
                color: const Color(0xFFFFFFFF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletButtonIcon extends StatelessWidget {
  const _WalletButtonIcon({required this.responsive});

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    final size = responsive.width(14);
    return SvgPicture.string(_walletButtonIconSvg, width: size, height: size);
  }
}

const String _walletButtonIconSvg = '''
<svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
<g clip-path="url(#clip0_213_1017)">
<path d="M10.2308 4.98077H14V3.23077C14 2.11736 13.0942 1.21155 11.9808 1.21155H2.01923C0.905816 1.21155 0 2.11736 0 3.23077V10.7692C0 11.8826 0.905816 12.7885 2.01923 12.7885H11.9808C13.0942 12.7885 14 11.8826 14 10.7692V9.01923H10.2308C9.11736 9.01923 8.21155 8.11341 8.21155 7C8.21155 5.88659 9.11736 4.98077 10.2308 4.98077Z" fill="white"/>
<path d="M10.2306 5.78845C9.56255 5.78845 9.01904 6.33194 9.01904 7C9.01904 7.66806 9.56253 8.21155 10.2306 8.21155H13.9998V5.78848L10.2306 5.78845ZM10.769 7.40384H10.2306C10.0075 7.40384 9.82675 7.22301 9.82675 7C9.82675 6.77698 10.0076 6.59616 10.2306 6.59616H10.769C10.9921 6.59616 11.1729 6.77698 11.1729 7C11.1729 7.22301 10.9921 7.40384 10.769 7.40384Z" fill="white"/>
</g>
<defs>
<clipPath id="clip0_213_1017">
<rect width="14" height="14" fill="white"/>
</clipPath>
</defs>
</svg>
''';

class _DecorativeCircles extends StatelessWidget {
  const _DecorativeCircles({required this.responsive});

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SvgPicture.string(
          _decorativeCircleBigSvg,
          width: responsive.width(98),
          height: responsive.height(66),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: SvgPicture.string(
            _decorativeCircleSmallSvg,
            width: responsive.width(82),
            height: responsive.height(49),
          ),
        ),
      ],
    );
  }
}

const String _decorativeCircleBigSvg = '''
<svg width="98" height="66" viewBox="0 0 98 66" fill="none" xmlns="http://www.w3.org/2000/svg">
<circle opacity="0.04" cx="83" cy="83" r="83" fill="url(#paint0_linear_213_10381)"/>
<defs>
<linearGradient id="paint0_linear_213_10381" x1="166" y1="83" x2="4.5" y2="48" gradientUnits="userSpaceOnUse">
<stop stop-color="#5F2E97"/>
<stop offset="1" stop-color="#001E40"/>
</linearGradient>
</defs>
</svg>
''';

const String _decorativeCircleSmallSvg = '''
<svg width="82" height="49" viewBox="0 0 82 49" fill="none" xmlns="http://www.w3.org/2000/svg">
<circle opacity="0.28" cx="65.5" cy="65.5" r="65.5" fill="url(#paint0_linear_213_10384)"/>
<defs>
<linearGradient id="paint0_linear_213_10384" x1="120" y1="63" x2="16" y2="-9.50001" gradientUnits="userSpaceOnUse">
<stop stop-color="#5F2E97"/>
<stop offset="1" stop-color="#001E40"/>
</linearGradient>
</defs>
</svg>
''';

class _ApplyOfferButton extends StatelessWidget {
  const _ApplyOfferButton({required this.responsive});

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: responsive.width(85),
      height: responsive.height(26),
      padding: EdgeInsets.only(
        top: responsive.height(5),
        right: responsive.width(9),
        bottom: responsive.height(5),
        left: responsive.width(9),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFB703),
        borderRadius: BorderRadius.circular(responsive.radius(4)),
      ),
      child: Center(
        child: Text(
          'Apply offer',
          style: TextStyle(
            fontSize: responsive.fontSize(12),
            fontWeight: FontWeight.w500,
            color: const Color(0xFFFFFFFF),
          ),
        ),
      ),
    );
  }
}

class _PromoBannerSlider extends StatefulWidget {
  const _PromoBannerSlider({required this.responsive});

  final Responsive responsive;

  @override
  State<_PromoBannerSlider> createState() => _PromoBannerSliderState();
}

class _PromoBannerSliderState extends State<_PromoBannerSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  static const int _totalSlides = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = widget.responsive;
    final bannerHeight = responsive.height(125);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: bannerHeight,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _totalSlides,
            itemBuilder: (context, index) {
              return _PromoBanner(responsive: responsive, slideIndex: index);
            },
          ),
        ),
        SizedBox(height: responsive.height(8)),
        // Pagination dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            _totalSlides,
            (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: responsive.width(4)),
              width: responsive.width(8),
              height: responsive.width(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index
                    ? const Color(0xFF482983) // Active dot color
                    : const Color(0xFFD9D9D9), // Inactive dot color
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner({required this.responsive, this.slideIndex = 0});

  final Responsive responsive;
  final int slideIndex;

  @override
  Widget build(BuildContext context) {
    final bannerWidth = responsive.screenWidth - (responsive.padding(24) * 2);
    final bannerHeight = responsive.height(125);

    return Container(
      width: bannerWidth,
      height: bannerHeight,
      margin: EdgeInsets.symmetric(horizontal: responsive.width(4)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(responsive.radius(16)),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.5963, 1.0],
          colors: [Color(0xFFFFC400), Color(0xFFFF5500)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: responsive.height(9.7),
            left: responsive.width(16),
            child: SizedBox(
              width: responsive.width(187),
              height: responsive.height(60),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: responsive.fontSize(21.81),
                    fontWeight: FontWeight.w800,
                    height: 1.0, // 100% line height
                    letterSpacing: 0,
                    color: const Color(0xFF4A148C),
                  ),
                  children: [
                    const TextSpan(text: 'Navratri Personal\n'),
                    const TextSpan(text: 'Loan '),
                    TextSpan(
                      text: '20% OFF',
                      style: TextStyle(
                        fontSize: responsive.fontSize(21.81),
                        fontWeight: FontWeight.w800,
                        height: 1.0,
                        letterSpacing: 0,
                        color: const Color(0xFFCE3A3A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: responsive.height(86),
            left: responsive.width(16),
            child: _ApplyOfferButton(responsive: responsive),
          ),
          Positioned(
            top: responsive.height(28.95),
            left: responsive.width(199.35),
            child: _GoddessImage(responsive: responsive),
          ),
        ],
      ),
    );
  }
}

class _GoddessImage extends StatelessWidget {
  const _GoddessImage({required this.responsive});

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: responsive.width(101.96539306640625),
      height: responsive.height(100.05067443847656),
      child: Image.asset(
        'assets/goddess_durga.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to network image if asset not found
          return Image.network(
            'https://via.placeholder.com/102x100/FF6B6B/FFFFFF?text=Durga',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              // Final fallback - simple placeholder
              return Container(
                decoration: BoxDecoration(color: Colors.transparent),
                child: const Icon(
                  Icons.image_outlined,
                  color: Colors.white70,
                  size: 50,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _EssentialsSection extends StatelessWidget {
  const _EssentialsSection({required this.responsive});

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Essentials',
              style: TextStyle(
                fontSize: responsive.fontSize(18),
                fontWeight: FontWeight.w700,
                color: const Color(0xFF101828),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'View all',
                style: TextStyle(
                  fontSize: responsive.fontSize(14),
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF532C8C),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: responsive.height(16)),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: responsive.width(12),
            mainAxisSpacing: responsive.height(12),
            childAspectRatio: 1.0,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            final items = [
              {'icon': _digitalGoldSvg, 'label': 'Digital\nGold'},
              {'icon': _prepaidCardSvg, 'label': 'Prepaid\nCard'},
              {'icon': _cibilScoreSvg, 'label': 'Cibil score\ncheck'},
              {'icon': _digitalGoldSvg, 'label': 'Digital\nGold'},
              {'icon': _prepaidCardSvg, 'label': 'Prepaid\nCard'},
              {'icon': _cibilScoreSvg, 'label': 'Cibil score\ncheck'},
            ];
            return _EssentialCard(
              responsive: responsive,
              iconSvg: items[index]['icon'] as String,
              label: items[index]['label'] as String,
            );
          },
        ),
      ],
    );
  }
}

class _EssentialCard extends StatelessWidget {
  const _EssentialCard({
    required this.responsive,
    required this.iconSvg,
    required this.label,
  });

  final Responsive responsive;
  final String iconSvg;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(responsive.radius(12)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.string(
              iconSvg,
              width: responsive.width(32),
              height: responsive.width(32),
            ),
            SizedBox(height: responsive.height(8)),
            Text(
              label,
              style: TextStyle(
                fontSize: responsive.fontSize(12),
                fontWeight: FontWeight.w500,
                color: const Color(0xFF101828),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

const String _digitalGoldSvg = '''
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M15.8003 19.1565V22.9172H5.53369V19.1565H15.8003Z" fill="#482983" stroke="#552C8E" stroke-width="0.4"/>
<path d="M14.7129 18.9563H16.0003V23.1177H14.7129V18.9563Z" fill="#9364D0"/>
<path d="M13.5543 16.0719H7.77937C7.59468 16.0719 7.4205 16.1601 7.30825 16.3105L5.3335 18.9562H16.0002L14.0254 16.3105C13.9132 16.1601 13.7391 16.0719 13.5543 16.0719Z" fill="#BD8EFF"/>
<path d="M16 18.956H14.7128L12.8315 16.3104C12.7195 16.16 12.545 16.0722 12.3604 16.0722H13.5542C13.739 16.0722 13.9134 16.16 14.0254 16.3104L16 18.956Z" fill="#9364D0"/>
<path d="M10.4668 26.2022V29.963H0.200195V26.2022H10.4668Z" fill="#482983" stroke="#552C8E" stroke-width="0.4"/>
<path d="M9.37939 26.002H10.6668V30.1634H9.37939V26.002Z" fill="#9364D0"/>
<path d="M8.22081 23.1177H2.44587C2.26119 23.1177 2.087 23.2059 1.97475 23.3562L0 26.002H10.6667L8.69194 23.3562C8.57969 23.2059 8.4055 23.1177 8.22081 23.1177Z" fill="#BD8EFF"/>
<path d="M10.6665 26.0017H9.37929L7.49798 23.3561C7.38598 23.2057 7.21154 23.1179 7.02686 23.1179H8.22073C8.40548 23.1179 8.57986 23.2057 8.69186 23.3561L10.6665 26.0017Z" fill="#9364D0"/>
<path d="M21.1333 26.2022V29.963H10.8667V26.2022H21.1333Z" fill="#482983" stroke="#552C8E" stroke-width="0.4"/>
<path d="M20.0459 26.002H21.3333V30.1634H20.0459V26.002Z" fill="#9364D0"/>
<path d="M18.8873 23.1177H13.1124C12.9277 23.1177 12.7535 23.2059 12.6413 23.3562L10.6665 26.002H21.3332L19.3584 23.3562C19.2463 23.2059 19.0721 23.1177 18.8873 23.1177Z" fill="#BD8EFF"/>
<path d="M21.333 26.0017H20.0458L18.1645 23.3561C18.0525 23.2057 17.878 23.1179 17.6934 23.1179H18.8872C19.072 23.1179 19.2464 23.2057 19.3584 23.3561L21.333 26.0017Z" fill="#9364D0"/>
<path d="M21.333 26.002H31.9997V30.1634H21.333V26.002Z" fill="#B67FF5" fill-opacity="0.71"/>
<path d="M30.7124 26.002H31.9998V30.1634H30.7124V26.002Z" fill="#CBA0FD" fill-opacity="0.59"/>
<path d="M29.5538 23.1177H23.7789C23.5942 23.1177 23.42 23.2059 23.3078 23.3562L21.333 26.002H31.9997L30.0249 23.3562C29.9127 23.2059 29.7386 23.1177 29.5538 23.1177Z" fill="#BD8EFF"/>
<path d="M31.9996 26.0017H30.7124L28.831 23.3561C28.719 23.2057 28.5446 23.1179 28.3599 23.1179H29.5537C29.7385 23.1179 29.9129 23.2057 30.0249 23.3561L31.9996 26.0017Z" fill="#603098" fill-opacity="0.45"/>
<path d="M16 18.8843H26.6667V23.0457H16V18.8843Z" fill="#B67FF5" fill-opacity="0.71"/>
<path d="M25.3794 18.8843H26.6668V23.0457H25.3794V18.8843Z" fill="#CBA0FD" fill-opacity="0.59"/>
<path d="M24.2208 16H18.4459C18.2612 16 18.087 16.0882 17.9747 16.2386L16 18.8843H26.6667L24.6919 16.2386C24.5797 16.0882 24.4056 16 24.2208 16Z" fill="#BD8EFF"/>
<path d="M26.6666 18.884H25.3794L23.498 16.2384C23.386 16.088 23.2115 16.0002 23.0269 16.0002H24.2207C24.4055 16.0002 24.5799 16.088 24.6919 16.2384L26.6666 18.884Z" fill="#603098" fill-opacity="0.45"/>
<path d="M11 10.8843H21.6667V15.0457H11V10.8843Z" fill="#B67FF5" fill-opacity="0.71"/>
<path d="M20.3794 10.8843H21.6668V15.0457H20.3794V10.8843Z" fill="#CBA0FD" fill-opacity="0.59"/>
<path d="M19.2208 8H13.4459C13.2612 8 13.087 8.08819 12.9747 8.23856L11 10.8843H21.6667L19.6919 8.23856C19.5797 8.08819 19.4056 8 19.2208 8Z" fill="#BD8EFF"/>
<path d="M21.6666 10.884H20.3794L18.498 8.23843C18.386 8.08799 18.2115 8.00024 18.0269 8.00024H19.2207C19.4055 8.00024 19.5799 8.08799 19.6919 8.23843L21.6666 10.884Z" fill="#603098" fill-opacity="0.45"/>
<path d="M16 4.6438C15.7411 4.6438 15.5312 4.43392 15.5312 4.17505V2.3053C15.5312 2.04642 15.7411 1.83655 16 1.83655C16.2589 1.83655 16.4688 2.04642 16.4688 2.3053V4.17505C16.4688 4.43392 16.2589 4.6438 16 4.6438Z" fill="#A285C3"/>
<path d="M6.43399 7.85959C6.31405 7.85959 6.19405 7.81384 6.10249 7.72227L4.78036 6.40015C4.5973 6.21709 4.5973 5.92027 4.78036 5.73727C4.96349 5.55421 5.26024 5.55421 5.4433 5.73727L6.76543 7.0594C6.94849 7.24246 6.94849 7.53927 6.76543 7.72227C6.67393 7.81384 6.55393 7.85959 6.43399 7.85959Z" fill="#A285C3"/>
<path d="M2.4718 16.2164H0.602051C0.343113 16.2164 0.133301 16.0065 0.133301 15.7476C0.133301 15.4887 0.343113 15.2789 0.602051 15.2789H2.4718C2.73074 15.2789 2.94055 15.4887 2.94055 15.7476C2.94055 16.0065 2.73068 16.2164 2.4718 16.2164Z" fill="#A285C3"/>
<path d="M31.3981 16.2164H29.5283C29.2694 16.2164 29.0596 16.0065 29.0596 15.7476C29.0596 15.4887 29.2694 15.2789 29.5283 15.2789H31.3981C31.657 15.2789 31.8668 15.4887 31.8668 15.7476C31.8668 16.0065 31.657 16.2164 31.3981 16.2164Z" fill="#A285C3"/>
<path d="M25.566 7.78659C25.446 7.78659 25.326 7.74084 25.2345 7.64927C25.0514 7.46621 25.0514 7.1694 25.2345 6.9864L26.5566 5.66427C26.7398 5.48121 27.0365 5.48121 27.2195 5.66427C27.4026 5.84734 27.4026 6.14415 27.2195 6.32715L25.8974 7.64927C25.8059 7.74084 25.6859 7.78659 25.566 7.78659Z" fill="#A285C3"/>
</svg>
''';

const String _prepaidCardSvg = '''
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M27.3498 5.28998H9.2298C7.7998 5.28998 6.61981 6.45001 6.58984 7.88H22.7698C25.3298 7.88 27.4098 9.96997 27.4098 12.53V22.12C28.8398 22.09 29.9998 20.91 29.9998 19.47V7.94C29.9998 6.47998 28.8098 5.28998 27.3498 5.28998Z" fill="#482983"/>
<path d="M22.77 9.88H4.65002C3.19 9.88 2 11.07 2 12.53V14.41H25.41V12.53C25.41 11.07 24.22 9.88 22.77 9.88Z" fill="#482983"/>
<path d="M2 24.06C2 25.52 3.19 26.71 4.65002 26.71H22.77C24.22 26.71 25.41 25.52 25.41 24.06V16.41H2V24.06ZM17.91 20.71H20.91C21.46 20.71 21.91 21.15 21.91 21.71C21.91 22.26 21.46 22.71 20.91 22.71H17.91C17.36 22.71 16.91 22.26 16.91 21.71C16.91 21.15 17.36 20.71 17.91 20.71Z" fill="#482983"/>
</svg>
''';

const String _cibilScoreSvg = '''
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
<g clip-path="url(#clip0_213_9696)">
<path d="M5.43018 9.70568L10.7628 15.0383C11.9732 14.07 13.4434 13.4407 15.0626 13.2585V5.71124C11.3751 5.92731 8.02693 7.39568 5.43018 9.70568Z" fill="#482983"/>
<path d="M4.10444 11.0314C1.599 13.8477 0 17.544 0 21.6012C0 22.1194 0.419312 22.5387 0.9375 22.5387H6.625C7.14319 22.5387 7.5625 22.1194 7.5625 21.6012C7.5625 19.6129 8.28231 17.8076 9.43706 16.364L4.10444 11.0314Z" fill="#482983"/>
<path d="M23.2436 14.2707C22.9278 13.9951 22.47 13.9595 22.1212 14.1856L13.9849 19.3756C12.8982 20.0696 12.25 21.2515 12.25 22.5388C12.25 24.607 13.9318 26.2888 16 26.2888C17.4539 26.2888 18.7887 25.4373 19.4002 24.1199L23.4753 15.3711C23.6511 14.994 23.5568 14.5453 23.2436 14.2707Z" fill="#482983"/>
<path d="M27.8957 11.0314L25.1402 13.7869C25.4872 14.5276 25.5328 15.3946 25.1746 16.163L23.9419 18.8096C24.2593 19.6814 24.4376 20.6184 24.4376 21.6012C24.4376 22.1194 24.857 22.5387 25.3751 22.5387H31.0626C31.5808 22.5387 32.0001 22.1194 32.0001 21.6012C32.0001 17.544 30.4011 13.8477 27.8957 11.0314Z" fill="#482983"/>
<path d="M16.9375 5.71124V13.2585C17.7268 13.3473 18.4789 13.546 19.1846 13.8347L21.1133 12.6043C21.8859 12.1036 22.8302 11.9961 23.8136 12.462L26.5699 9.70568C23.9731 7.39568 20.625 5.92731 16.9375 5.71124Z" fill="#482983"/>
</g>
<defs>
<clipPath id="clip0_213_9696">
<rect width="32" height="32" fill="white"/>
</clipPath>
</defs>
</svg>
''';

class FadeInSlide extends StatefulWidget {
  const FadeInSlide({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.delay = Duration.zero,
    this.offset = const Offset(0, 30),
    this.curve = Curves.easeOutCubic,
  });

  final Widget child;
  final Duration duration;
  final Duration delay;
  final Offset offset;
  final Curve curve;

  @override
  State<FadeInSlide> createState() => _FadeInSlideState();
}

class _FadeInSlideState extends State<FadeInSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
            offset: Offset(0, widget.offset.dy * _slideAnimation.value),
            child: widget.child,
          ),
        );
      },
    );
  }
}
