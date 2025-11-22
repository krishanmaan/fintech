import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'components/bottom_nav.dart';
import '../../utils/responsive.dart';
import 'withdraw.dart';

/// Main home/dashboard screen jo user ko salary aur essentials dikhata hai.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final statusBarHeight = MediaQuery.of(context).padding.top;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF7F0FA),
      bottomNavigationBar: BottomNavBar(responsive: responsive),
      body: Stack(
        children: [
          // SVG background jo status bar area me bhi extend hota hai
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
                // Purple header background (backup, SVG ke neeche)
                Align(
                  alignment: Alignment.topCenter,
                  child: PurpleShape(
                    height: responsive.height(150),
                    borderRadius: responsive.radius(42),
                  ),
                ),
            // Header content (profile + welcome text + icons)
            Positioned(
              top: responsive.height(20),
              left: responsive.padding(24),
              right: responsive.padding(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: responsive.width(57.76),
                    height: responsive.width(57.76),
                    child: CircleAvatar(
                      radius: responsive.width(57.76) / 2,
                      backgroundImage: const NetworkImage(
                        'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=200',
                      ),
                    ),
                  ),
                  SizedBox(width: responsive.width(16)),
                  Flexible(
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Welcome,',
                            style: TextStyle(
                              fontSize: responsive.fontSize(20),
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                          SizedBox(height: responsive.height(5.47)),
                          Text(
                            'Nayan mishra',
                            style: TextStyle(
                              fontSize: responsive.fontSize(28),
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  _ActionIcon(
                    child: _HelpIcon(responsive: responsive),
                  ),
                  SizedBox(width: responsive.width(12)),
                  _NotificationIcon(responsive: responsive),
                ],
              ),
            ),
            // Scrollable content area
            Positioned(
              top: responsive.height(100),
              left: 0,
              right: 0,
              bottom: responsive.height(1), // Space for bottom nav
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: responsive.padding(24)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Monthly Salary Card
                    _SummaryCard(responsive: responsive),
                    SizedBox(height: responsive.height(20)),
                    // Promotional banner slider
                    _PromoBannerSlider(responsive: responsive),
                    SizedBox(height: responsive.height(24)),
                    // My Essentials Section
                    _EssentialsSection(responsive: responsive),
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

// SVG header design jo status bar area me extend hota hai
const String _headerSvg = '''
<svg width="375" height="210" viewBox="0 0 375 210" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M0 0H375V178C375 195.673 360.673 210 343 210H32C14.3269 210 0 195.673 0 178V0Z" fill="#482983"/>
</svg>
''';

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({this.icon, this.child, this.responsive})
      : assert(icon != null || child != null);

  final IconData? icon;
  final Widget? child;
  final Responsive? responsive;

  @override
  Widget build(BuildContext context) {
    final r = responsive ?? Responsive(context);
    final iconSize = r.width(40);
    
    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.25),
          ),
        ),
        child: Center(
          child: child ??
              Icon(
                icon,
                color: Colors.white,
                size: r.fontSize(22),
              ),
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
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: _HelpIconPainter(),
      ),
    );
  }
}

class _HelpIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final radius = size.width * 0.25;
    final tailHeight = size.height * 0.25;
    final bodyHeight = size.height - tailHeight;

    final path = Path()
      ..moveTo(radius, 0)
      ..lineTo(size.width - radius, 0)
      ..quadraticBezierTo(size.width, 0, size.width, radius)
      ..lineTo(size.width, bodyHeight - radius)
      ..quadraticBezierTo(
        size.width,
        bodyHeight,
        size.width - radius,
        bodyHeight,
      )
      ..lineTo(size.width * 0.62, bodyHeight)
      ..lineTo(size.width * 0.5, size.height)
      ..lineTo(size.width * 0.38, bodyHeight)
      ..lineTo(radius, bodyHeight)
      ..quadraticBezierTo(0, bodyHeight, 0, bodyHeight - radius)
      ..lineTo(0, radius)
      ..quadraticBezierTo(0, 0, radius, 0)
      ..close();

    canvas.drawPath(path, strokePaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: '?',
        style: TextStyle(
          color: Colors.white,
          fontSize: size.width * 0.6,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final textOffset = Offset(
      (size.width - textPainter.width) / 2,
      bodyHeight * 0.2 - textPainter.height * 0.15,
    );

    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon({required this.responsive});

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _ActionIcon(
          icon: Icons.notifications_none,
          responsive: responsive,
        ),
        Positioned(
          top: responsive.width(6),
          right: responsive.width(6),
          child: Container(
            width: responsive.width(12),
            height: responsive.width(12),
            decoration: const BoxDecoration(
              color: Color(0xFFE74C3C),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.responsive});

  final Responsive responsive;

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
            // White background
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.all(Radius.circular(cardRadius)),
              ),
            ),
            // Gradient top border (diamond gradient)
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
            // Salary component
            Positioned(
              top: responsive.height(18),
              left: responsive.width(18),
              child: _SalaryComponent(responsive: responsive),
            ),
            // Wallet icon
            Positioned(
              top: responsive.height(23.85),
              right: responsive.width(18),
              child: _WalletIcon(responsive: responsive),
            ),
            // Timeline component
            Positioned(
              top: responsive.height(90), 
              left: responsive.width(18),
              child: _TimelineComponent(responsive: responsive),
            ),
            // Withdraw button
            Positioned(
              top: responsive.height(135),
              left: responsive.width(18),
              child: _WithdrawButton(responsive: responsive),
            ),
            // Decorative circles - bottom right
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
  const _SalaryComponent({required this.responsive});

  final Responsive responsive;

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
                    '₹ 5,600.00',
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
                _VisibilityIcon(responsive: responsive),
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
      ..quadraticBezierTo(
        0,
        size.height,
        0,
        size.height - radius,
      )
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _VisibilityIcon extends StatelessWidget {
  const _VisibilityIcon({required this.responsive});

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    final size = responsive.width(20);
    return SvgPicture.string(
      _visibilityIconSvg,
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
    final barWidth = responsive.width(7);
    final barWidthSmall = responsive.width(6);
    final barHeight = responsive.height(11);
    final barHeightTall = responsive.height(17);
    final barGap = responsive.width(4);
    final barRadius = responsive.radius(22);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bars row - keeping bars in their original positions
        Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // First bar (1 Sep) - tall, purple
                Container(
                  width: barWidth,
                  height: barHeightTall,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5F2E97),
                    borderRadius: BorderRadius.circular(barRadius),
                  ),
                ),
                SizedBox(width: barGap),
                // Next 6 bars (2-7 Sep) - short, purple
                ...List.generate(6, (index) {
                  return Padding(
                    padding: EdgeInsets.only(right: barGap),
                    child: Container(
                      width: barWidthSmall,
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5F2E97),
                        borderRadius: BorderRadius.circular(barRadius),
                      ),
                    ),
                  );
                }),
                // Next 7 bars (8-14 Sep) - short, gray
                ...List.generate(7, (index) {
                  return Padding(
                    padding: EdgeInsets.only(right: barGap),
                    child: Container(
                      width: barWidthSmall,
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(barRadius),
                      ),
                    ),
                  );
                }),
                // Last bar - tall, gray (position unchanged)
                Container(
                  width: barWidth,
                  height: barHeightTall,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(barRadius),
                  ),
                ),
              ],
            ),
            // Dates positioned below bars without affecting bar positions
            Positioned(
              top: barHeightTall + responsive.height(4),
              left: 0,
              child: Text(
                '1 Sep',
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
                '30 Sep',
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
        // Withdraw screen par navigate karo
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const WithdrawScreen(),
          ),
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
    return SvgPicture.string(
      _walletButtonIconSvg,
      width: size,
      height: size,
    );
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
        // Bigger circle (behind)
        SvgPicture.string(
          _decorativeCircleBigSvg,
          width: responsive.width(98),
          height: responsive.height(66),
        ),
        // Smaller circle (in front)
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
        color: const Color(0xFFFFB703), // hsba(43, 99%, 100%, 1) - bright yellow-orange
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
              return _PromoBanner(
                responsive: responsive,
                slideIndex: index,
              );
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
  const _PromoBanner({
    required this.responsive,
    this.slideIndex = 0,
  });

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
          stops: [0.5963, 1.0], // 59.63% to 100% (163.51% in CSS means end of container)
          colors: [
            Color(0xFFFFC400), // #FFC400 at 59.63%
            Color(0xFFFF5500), // #FF5500 at end
          ],
        ),
      ),
      child: Stack(
        children: [
          // Text content
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
                    color: const Color(0xFF4A148C), // Purple (hsba(267, 86%, 55%, 1))
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
                        color: const Color(0xFFCE3A3A), // Reddish-orange for "20% OFF"
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Apply offer button
          Positioned(
            top: responsive.height(86),
            left: responsive.width(16),
            child: _ApplyOfferButton(responsive: responsive),
          ),
          // Goddess image
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
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
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

/// My Essentials section jo services ka grid dikhata hai.
class _EssentialsSection extends StatelessWidget {
  const _EssentialsSection({required this.responsive});

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with "View all" link
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
        // Grid of essential services
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
              {'icon': Icons.account_balance, 'label': 'Digital Gold'},
              {'icon': Icons.credit_card, 'label': 'Prepaid Card'},
              {'icon': Icons.speed, 'label': 'Cibil score check'},
              {'icon': Icons.account_balance, 'label': 'Digital Gold'},
              {'icon': Icons.credit_card, 'label': 'Prepaid Card'},
              {'icon': Icons.speed, 'label': 'Cibil score check'},
            ];
            return _EssentialCard(
              responsive: responsive,
              icon: items[index]['icon'] as IconData,
              label: items[index]['label'] as String,
            );
          },
        ),
      ],
    );
  }
}

/// Individual essential service card.
class _EssentialCard extends StatelessWidget {
  const _EssentialCard({
    required this.responsive,
    required this.icon,
    required this.label,
  });

  final Responsive responsive;
  final IconData icon;
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
            Icon(
              icon,
              size: responsive.width(32),
              color: const Color(0xFF532C8C),
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


