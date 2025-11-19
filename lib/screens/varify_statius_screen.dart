import 'package:flutter/material.dart';

/// Possible states for the KYC verification summary.
enum KycStatus { completed, pending }

/// Final status screen that shows whether KYC is pending or complete.
class VarifyStatiusScreen extends StatelessWidget {
  final KycStatus status;

  const VarifyStatiusScreen({
    super.key,
    this.status = KycStatus.completed,
  });

  @override
  Widget build(BuildContext context) {
    final _StatusTheme theme = _StatusTheme.fromStatus(status);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF482A92), Color(0xFF1A1F5C)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.45],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(36),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withOpacity(0.12),
                        offset: const Offset(0, -8),
                        blurRadius: 24,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "KYC Verification",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF101828),
                          ),
                        ),
                        const SizedBox(height: 24),
                        /// Top banner summarizing the overall result.
                        _StatusHighlightCard(theme: theme),
                        const SizedBox(height: 16),
                        /// Individual checklist item states.
                        _StatusListCard(theme: theme),
                        const Spacer(),
                        _StatusFooter(status: status),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusHighlightCard extends StatelessWidget {
  final _StatusTheme theme;

  const _StatusHighlightCard({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: theme.iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              theme.icon,
              color: theme.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Verify employ your identity",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  theme.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF475467),
                    height: 1.4,
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

class _StatusListCard extends StatelessWidget {
  final _StatusTheme theme;

  const _StatusListCard({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E7EC)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Identity varication",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF101828),
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Government ID",
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF98A2B3),
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: theme.badgeBackground,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              theme.badgeLabel,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusFooter extends StatelessWidget {
  final KycStatus status;

  const _StatusFooter({required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: status == KycStatus.completed
                ? const Color(0xFF26A769)
                : const Color(0xFFFF8C42),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          status == KycStatus.completed
              ? "Status updated 2 mins ago"
              : "Awaiting final review",
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF98A2B3),
          ),
        ),
      ],
    );
  }
}

class _StatusTheme {
  final Color primaryColor;
  final Color cardBackground;
  final Color badgeBackground;
  final Color iconBackground;
  final IconData icon;
  final String description;
  final String badgeLabel;

  _StatusTheme({
    required this.primaryColor,
    required this.cardBackground,
    required this.badgeBackground,
    required this.iconBackground,
    required this.icon,
    required this.description,
    required this.badgeLabel,
  });

  factory _StatusTheme.fromStatus(KycStatus status) {
    if (status == KycStatus.pending) {
      return _StatusTheme(
        primaryColor: const Color(0xFFB87A25),
        cardBackground: const Color(0xFFFFF4E6),
        badgeBackground: const Color(0xFFFFE4C7),
        iconBackground: const Color(0xFFFFEDD5),
        icon: Icons.access_time_filled_rounded,
        description:
            "You have completed all verification. It will take some time to access all features.",
        badgeLabel: "Pending",
      );
    }

    return _StatusTheme(
      primaryColor: const Color(0xFF11895E),
      cardBackground: const Color(0xFFE4FCEC),
      badgeBackground: const Color(0xFFD5F5E3),
      iconBackground: const Color(0xFFC5F2D6),
      icon: Icons.check_circle_rounded,
      description:
          "You have completed all verification steps and have full access to all features.",
      badgeLabel: "Completed",
    );
  }
}

