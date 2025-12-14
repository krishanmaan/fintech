import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utils/animations.dart';
import '../../services/storage_service.dart';

import 'transaction_history_screen.dart';
import 'static_content_screen.dart';

/// Profile screen with user details and menu options
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final StorageService _storageService = StorageService();
  String _userName = '';
  String _phoneNumber = '';
  String _kycStatus = 'NOT_STARTED';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _storageService.getUserData();
      final phoneNumber = await _storageService.getPhoneNumber();
      final kycStatus = await _storageService.getKycStatus();

      if (mounted) {
        setState(() {
          if (userData != null) {
            _userName =
                '${userData['first_name'] ?? ''} ${userData['last_name'] ?? ''}'
                    .trim();
          }

          if (phoneNumber != null) {
            _phoneNumber = phoneNumber;
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Stack(
        children: [
          // Gradient background
          const Positioned.fill(child: _ProfileGradientBackground()),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Header with back button and notification icon
                _buildHeader(context),

                // Profile title
                const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 40),

                // Main content with rounded top - NO SCROLL
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Profile section with avatar, name, phone (animated)
                        FadeInAnimation(
                          delay: const Duration(milliseconds: 100),
                          child: _buildProfileSection(),
                        ),

                        // Menu items (animated)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: FadeInAnimation(
                              delay: const Duration(milliseconds: 200),
                              child: _buildMenuItems(),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.arrow_back,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),

          // Transaction History icon (Rupee symbol in circle)
          GestureDetector(
            onTap: () {
              // Navigate to Transaction History screen with animation
              Navigator.push(
                context,
                SmoothPageRoute(page: const TransactionHistoryScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: SvgPicture.string(
                _transactionHistoryIcon,
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Transform.translate(
      offset: const Offset(0, -30), // Reduced offset so photo is fully visible
      child: Column(
        children: [
          // Profile picture with edit button
          Stack(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/profile_avatar.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF482983),
                        child: const Icon(
                          Icons.person,
                          size: 45,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    // Edit profile picture
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF482983),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // User name
          Text(
            _isLoading
                ? 'Loading...'
                : _userName.isEmpty
                ? 'User'
                : _userName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF101828),
            ),
          ),

          const SizedBox(height: 4),

          // Phone number
          Text(
            _isLoading
                ? 'Loading...'
                : _phoneNumber.isEmpty
                ? 'No phone'
                : _phoneNumber,
            style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),

          const SizedBox(height: 16),

          // KYC button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: _kycStatus == 'VERIFIED'
                  ? const Color(0xFF10B981)
                  : const Color(0xFF482983),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_kycStatus == 'VERIFIED')
                  const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(
                      Icons.check_circle,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                Text(
                  _kycStatus == 'VERIFIED' ? 'KYC Verified' : 'KYC Pending',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    final menuItems = [
      {
        'icon': Icons.person_outline,
        'title': 'Personal Details',
        'color': const Color(0xFF482983),
      },
      {
        'icon': Icons.language,
        'title': 'Change App Language',
        'color': const Color(0xFF482983),
      },
      {
        'icon': Icons.security,
        'title': 'App Permissions',
        'color': const Color(0xFF482983),
      },
      {
        'icon': Icons.card_giftcard,
        'title': 'Refer and Earn',
        'color': const Color(0xFF482983),
      },
      {
        'icon': Icons.help_outline,
        'title': 'FAQs',
        'color': const Color(0xFF482983),
      },
      {
        'icon': Icons.phone_outlined,
        'title': 'Contact Us',
        'color': const Color(0xFF482983),
      },
      {
        'icon': Icons.info_outline,
        'title': 'About us',
        'color': const Color(0xFF482983),
      },
      {
        'icon': Icons.description_outlined,
        'title': 'Terms & Conditions',
        'color': const Color(0xFF482983),
      },
      {
        'icon': Icons.privacy_tip_outlined,
        'title': 'Privacy Policy',
        'color': const Color(0xFF482983),
      },
      {
        'icon': Icons.logout,
        'title': 'Log out',
        'color': const Color(0xFFEF4444),
      },
    ];

    return Column(
      children: menuItems.map((item) {
        return _buildMenuItem(
          icon: item['icon'] as IconData,
          title: item['title'] as String,
          color: item['color'] as Color,
          onTap: () {
            _handleMenuItemTap(item['title'] as String);
          },
        );
      }).toList(),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 6),
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: color),
            ),

            const SizedBox(width: 14),

            // Title
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151),
                ),
              ),
            ),

            // Arrow icon
            Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  void _handleMenuItemTap(String title) {
    switch (title) {
      case 'Personal Details':
        // Navigate to personal details screen
        break;
      case 'Change App Language':
        _showLanguageDialog();
        break;
      case 'App Permissions':
        // Navigate to permissions screen
        break;
      case 'Refer and Earn':
        // Navigate to refer and earn screen
        break;
      case 'FAQs':
        Navigator.push(
          context,
          SmoothPageRoute(
            page: const StaticContentScreen(pageType: 'FAQ', title: 'FAQs'),
          ),
        );
        break;
      case 'Contact Us':
        Navigator.push(
          context,
          SmoothPageRoute(
            page: const StaticContentScreen(
              pageType: 'CONTACT',
              title: 'Contact Us',
            ),
          ),
        );
        break;
      case 'About us':
        Navigator.push(
          context,
          SmoothPageRoute(
            page: const StaticContentScreen(
              pageType: 'ABOUT',
              title: 'About Us',
            ),
          ),
        );
        break;
      case 'Terms & Conditions':
        Navigator.push(
          context,
          SmoothPageRoute(
            page: const StaticContentScreen(
              pageType: 'TERMS',
              title: 'Terms & Conditions',
            ),
          ),
        );
        break;
      case 'Privacy Policy':
        Navigator.push(
          context,
          SmoothPageRoute(
            page: const StaticContentScreen(
              pageType: 'PRIVACY',
              title: 'Privacy Policy',
            ),
          ),
        );
        break;
      case 'Log out':
        _showLogoutDialog();
        break;
    }
  }

  void _showLanguageDialog() {
    String selectedLanguage = 'English';
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Select Language',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOptionStateful('English', selectedLanguage, (
                value,
              ) {
                setDialogState(() => selectedLanguage = value!);
              }),
              _buildLanguageOptionStateful('हिंदी', selectedLanguage, (value) {
                setDialogState(() => selectedLanguage = value!);
              }),
              _buildLanguageOptionStateful('मराठी', selectedLanguage, (value) {
                setDialogState(() => selectedLanguage = value!);
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Save language preference: selectedLanguage
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOptionStateful(
    String language,
    String selectedLanguage,
    ValueChanged<String?> onChanged,
  ) {
    final isSelected = language == selectedLanguage;
    return ListTile(
      title: Text(language),
      leading: GestureDetector(
        onTap: () => onChanged(language),
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? const Color(0xFF482983) : Colors.grey,
              width: 2,
            ),
          ),
          child: isSelected
              ? Center(
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF482983),
                    ),
                  ),
                )
              : null,
        ),
      ),
      onTap: () => onChanged(language),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Log Out',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _storageService.clearAll();

              if (!mounted) return;

              Navigator.of(context).popUntil((route) => route.isFirst);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}

/// Transaction History SVG Icon
const String _transactionHistoryIcon = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M21 12C21 16.9626 16.9626 21 12 21C7.03744 21 3 16.9626 3 12C3 11.6893 3.25163 11.4375 3.5625 11.4375C3.87338 11.4375 4.125 11.6893 4.125 12C4.125 16.3423 7.65769 19.875 12 19.875C16.3423 19.875 19.875 16.3423 19.875 12C19.875 7.65769 16.3423 4.125 12 4.125C9.90731 4.125 7.96388 4.93856 6.50213 6.375H8.625C8.93588 6.375 9.1875 6.62681 9.1875 6.9375C9.1875 7.24819 8.93588 7.5 8.625 7.5H5.25C4.93913 7.5 4.6875 7.24819 4.6875 6.9375V3.5625C4.6875 3.25181 4.93913 3 5.25 3C5.56088 3 5.8125 3.25181 5.8125 3.5625V5.48119C7.47206 3.89719 9.65269 3 12 3C16.9626 3 21 7.03744 21 12Z" fill="white"/>
<path d="M8.84 8.36H10.904C10.988 8.36 11.096 8.364 11.228 8.372C11.364 8.376 11.488 8.388 11.6 8.408C12.096 8.484 12.506 8.652 12.83 8.912C13.158 9.168 13.4 9.49 13.556 9.878C13.716 10.266 13.796 10.698 13.796 11.174C13.796 11.87 13.63 12.46 13.298 12.944C12.97 13.424 12.468 13.742 11.792 13.898C11.628 13.934 11.484 13.958 11.36 13.97C11.236 13.978 11.082 13.982 10.898 13.982H8.84V12.632H10.844C10.928 12.632 11.018 12.628 11.114 12.62C11.214 12.612 11.308 12.596 11.396 12.572C11.632 12.508 11.818 12.402 11.954 12.254C12.094 12.102 12.192 11.93 12.248 11.738C12.308 11.546 12.338 11.358 12.338 11.174C12.338 10.99 12.308 10.802 12.248 10.61C12.192 10.414 12.094 10.24 11.954 10.088C11.818 9.936 11.632 9.83 11.396 9.77C11.308 9.746 11.214 9.732 11.114 9.728C11.018 9.72 10.928 9.716 10.844 9.716H8.84V8.36ZM8.84 13.982L10.412 13.622L14.216 17H12.2L8.84 13.982ZM8.882 11.72V10.628H14.816V11.72H8.882ZM10.724 9.452V8.36H14.78V9.452H10.724Z" fill="white"/>
</svg>
''';

/// Gradient background for profile screen
class _ProfileGradientBackground extends StatelessWidget {
  const _ProfileGradientBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF241E63), Color(0xFF482983)],
        ),
      ),
    );
  }
}
