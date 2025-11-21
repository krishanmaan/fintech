import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// App ka primary dashboard screen (home tab).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentAdIndex = 0;

  final List<_PromoCardData> _promoCards = const [
    _PromoCardData(
      title: 'Navratri Personal Loan 20% OFF',
      subtitle: 'Apply offer',
      background: Color(0xFFFFC043),
      icon: Icons.celebration,
    ),
    _PromoCardData(
      title: 'Festival Offers On Essentials',
      subtitle: 'View deals',
      background: Color(0xFFF4E3FF),
      icon: Icons.local_offer_rounded,
    ),
    _PromoCardData(
      title: 'Refer and Earn',
      subtitle: 'Invite friends',
      background: Color(0xFFFFF4DB),
      icon: Icons.group_add_rounded,
    ),
  ];

  final List<_EssentialData> _essentials = const [
    _EssentialData(icon: Icons.savings_rounded, label: 'Digital Gold'),
    _EssentialData(icon: Icons.credit_card_rounded, label: 'Prepaid Card'),
    _EssentialData(icon: Icons.pie_chart_rounded, label: 'Cibil score check'),
    _EssentialData(icon: Icons.savings_outlined, label: 'Digital Gold'),
    _EssentialData(icon: Icons.credit_card_outlined, label: 'Prepaid Card'),
    _EssentialData(icon: Icons.query_stats_rounded, label: 'Cibil score check'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Stack(
        children: [
          const Positioned(top: 0, left: 0, right: 0, child: _HeaderBackground()),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _TopGreeting(),
                  const SizedBox(height: 20),
                  const _SalaryOverviewCard(),
                  const SizedBox(height: 20),
                  _buildPromoSection(),
                  const SizedBox(height: 20),
                  _buildEssentialsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const _HomeBottomNavigation(),
    );
  }

  Widget _buildPromoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 150,
          child: PageView.builder(
            itemCount: _promoCards.length,
            onPageChanged: (value) => setState(() => _currentAdIndex = value),
            controller: PageController(viewportFraction: 0.9),
            itemBuilder: (_, index) => _PromoCard(data: _promoCards[index]),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _promoCards.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: _currentAdIndex == index ? 24 : 6,
              decoration: BoxDecoration(
                color: _currentAdIndex == index
                    ? const Color(0xFF482983)
                    : const Color(0xFFB8A4E6),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEssentialsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'My Essentials',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF101828),
              ),
            ),
            Text(
              'View all',
              style: TextStyle(
                color: Color(0xFF7C3AED),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _essentials.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (_, index) => _EssentialCard(data: _essentials[index]),
        ),
      ],
    );
  }
}

/// Header area background referencing provided SVG path.
class _HeaderBackground extends StatelessWidget {
  const _HeaderBackground();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      width: double.infinity,
      child: SvgPicture.string(_headerSvg),
    );
  }
}

class _TopGreeting extends StatelessWidget {
  const _TopGreeting();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 26,
          backgroundColor: Colors.white24,
          child: Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Welcome,',
              style: TextStyle(color: Colors.white70),
            ),
            Text(
              'Nayan mishra',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const Spacer(),
        _CircleIconButton(
          icon: Icons.help_outline,
          onTap: () {},
        ),
        const SizedBox(width: 10),
        _CircleIconButton(
          icon: Icons.notifications_none_rounded,
          onTap: () {},
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

class _SalaryOverviewCard extends StatelessWidget {
  const _SalaryOverviewCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF482983).withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Monthly Salary',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF7D8CA1),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '₹ 5,600.00',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF101828),
                    ),
                  ),
                ],
              ),
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEECC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.savings,
                  color: Color(0xFFFFA800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "This month's earnings",
            style: TextStyle(color: Color(0xFF7D8CA1), fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(
              10,
              (index) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 6,
                  decoration: BoxDecoration(
                    color: index < 7
                        ? const Color(0xFF5D3FD3)
                        : const Color(0xFFE4E7EC),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('1 Sep', style: TextStyle(color: Color(0xFF98A2B3))),
              Text('30 Sep', style: TextStyle(color: Color(0xFF98A2B3))),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5D3FD3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                
              ),
              onPressed: () {},
              child: const Text('Withdraw'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PromoCardData {
  final String title;
  final String subtitle;
  final Color background;
  final IconData icon;

  const _PromoCardData({
    required this.title,
    required this.subtitle,
    required this.background,
    required this.icon,
  });
}

class _PromoCard extends StatelessWidget {
  final _PromoCardData data;

  const _PromoCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: data.background,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    data.subtitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF482983),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: Icon(
                data.icon,
                color: const Color(0xFF482983),
                size: 32,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _EssentialData {
  final IconData icon;
  final String label;

  const _EssentialData({required this.icon, required this.label});
}

class _EssentialCard extends StatelessWidget {
  final _EssentialData data;

  const _EssentialCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF171A58).withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF4EAFE),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              data.icon,
              color: const Color(0xFF5D3FD3),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF101828),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeBottomNavigation extends StatelessWidget {
  const _HomeBottomNavigation();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          _BottomNavItem(
            icon: Icons.home_filled,
            label: 'Home',
            isActive: true,
          ),
          _BottomNavItem(
            icon: Icons.monetization_on_outlined,
            label: 'Salary',
          ),
          _BottomNavItem(
            icon: Icons.credit_card,
            label: 'Explore cards',
          ),
          _BottomNavItem(
            icon: Icons.person_outline,
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? const Color(0xFF5D3FD3) : const Color(0xFF98A2B3),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive
                ? const Color(0xFF5D3FD3)
                : const Color(0xFF98A2B3),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

const String _headerSvg = '''
<svg width="605" height="210" viewBox="0 0 375 210" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M0 0H375V178C375 195.673 360.673 210 343 210H32C14.3269 210 0 195.673 0 178V0Z" fill="#482983"/>
</svg>
''';

