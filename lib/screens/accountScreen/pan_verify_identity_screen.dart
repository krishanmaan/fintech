import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'bank_verify_identity_screen.dart';

/// PAN verification screen – Step 2 of the KYC process.
class PanVerifyIdentityScreen extends StatefulWidget {
  const PanVerifyIdentityScreen({super.key});

  @override
  State<PanVerifyIdentityScreen> createState() =>
      _PanVerifyIdentityScreenState();
}

class _PanVerifyIdentityScreenState extends State<PanVerifyIdentityScreen> {
  final TextEditingController _panController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _openDatePicker() async {
    DateTime tempSelected = _selectedDate ?? DateTime(2002, 5, 7);
    DateTime visibleMonth =
        DateTime(tempSelected.year, tempSelected.month, 1);
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            void changeMonth(int delta) {
              setModalState(() {
                visibleMonth =
                    DateTime(visibleMonth.year, visibleMonth.month + delta, 1);
              });
            }

            // Build a static grid-based calendar that mimics the design spec.
            List<Widget> buildCalendarDays() {
              final List<Widget> rows = [];
              const List<String> weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

              rows.add(Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: weekDays
                    .map(
                      (day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF98A2B3),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ));
              rows.add(const SizedBox(height: 12));

              final DateTime firstDay =
                  DateTime(visibleMonth.year, visibleMonth.month, 1);
              final int totalDays =
                  DateUtils.getDaysInMonth(visibleMonth.year, visibleMonth.month);
              final int offset = firstDay.weekday % 7;
              final int totalCells =
                  (offset + totalDays) <= 35 ? 35 : 42; // ensure rows

              List<Widget> dayCells = [];
              for (int index = 0; index < totalCells; index++) {
                int dayNumber = index - offset + 1;
                if (dayNumber < 1 || dayNumber > totalDays) {
                  dayCells.add(const SizedBox.shrink());
                  continue;
                }

                final DateTime currentDay =
                    DateTime(visibleMonth.year, visibleMonth.month, dayNumber);
                final bool isSelected = tempSelected.year == currentDay.year &&
                    tempSelected.month == currentDay.month &&
                    tempSelected.day == currentDay.day;

                dayCells.add(
                  GestureDetector(
                    onTap: () {
                      setModalState(() {
                        tempSelected = currentDay;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? const Color(0xFF5B2B8F)
                            : Colors.transparent,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$dayNumber',
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF1D1E25),
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }

              rows.add(
                GridView.count(
                  crossAxisCount: 7,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: dayCells,
                ),
              );

              return rows;
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _DateNavButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => changeMonth(-1),
                      ),
                      Text(
                        _formatMonthYear(visibleMonth),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF101828),
                        ),
                      ),
                      _DateNavButton(
                        icon: Icons.arrow_forward_ios_rounded,
                        onTap: () => changeMonth(1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...buildCalendarDays(),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            foregroundColor: const Color(0xFF101828),
                            side: const BorderSide(color: Color(0xFFE4E7EC)),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedDate = tempSelected;
                            });
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color(0xFF532C8C),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    setState(() {});
  }

  String get _dateLabel {
    if (_selectedDate == null) {
      return 'Select date of birth';
    }
    return _formatDate(_selectedDate!);
  }

  String _formatDate(DateTime date) {
    final List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatMonthYear(DateTime date) {
    final List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const Positioned.fill(child: _PanGradientBackground()),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: _PanContentCard(
                    panController: _panController,
                    onPickDate: _openDatePicker,
                    dateLabel: _dateLabel,
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

class _PanGradientBackground extends StatelessWidget {
  const _PanGradientBackground();

  @override
  Widget build(BuildContext context) {
    final double headerHeight = MediaQuery.of(context).size.height * 0.35;
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: _PanWavePainter(headerHeight: headerHeight),
      ),
    );
  }
}

class _PanContentCard extends StatelessWidget {
  final TextEditingController panController;
  final VoidCallback onPickDate;
  final String dateLabel;

  const _PanContentCard({
    required this.panController,
    required this.onPickDate,
    required this.dateLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
          const SizedBox(height: 28),
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
            "Please provide you aadhar details",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF7D8CA1),
            ),
          ),
          const SizedBox(height: 28),
          /// PAN verification provider selection.
          const _VerificationProviderTile(),
          const SizedBox(height: 24),
          const Text(
            "Pan Number",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          _PanInputField(
            controller: panController,
            hint: "Enter pan number",
          ),
          const SizedBox(height: 20),
          const Text(
            "Date Of Birth",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          _DateInputField(
            label: dateLabel,
            onTap: onPickDate,
          ),
          const Spacer(),
          /// Proceed to the bank verification step.
          const _VerifyButton(),
        ],
      ),
    );
  }
}

class _PanInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _PanInputField({
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

class _DateInputField extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DateInputField({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6FA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: label == 'Select date of birth'
                      ? const Color(0xFF98A2B3)
                      : const Color(0xFF101828),
                ),
              ),
            ),
            const Icon(
              Icons.calendar_today_rounded,
              color: Color(0xFF5B2B8F),
            ),
          ],
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
          SvgPicture.string(
            _panSvgIcon,
            width: 42,
            height: 32,
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Protean",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7D8CA1),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "PAN Verification",
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
                builder: (_) => const BankVerifyIdentityScreen(),
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
        _StepItem(label: '2', isCompleted: true, isCurrent: true),
        _StepConnector(isCompleted: false),
        _StepItem(label: '3', isCompleted: false),
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

    // Keep current step highlighted softly while previous steps are solid purple.
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

class _PanWavePainter extends CustomPainter {
  final double headerHeight;

  _PanWavePainter({required this.headerHeight});

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

class _DateNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _DateNavButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE4E7EC)),
        ),
        child: Icon(
          icon,
          size: 16,
          color: const Color(0xFF101828),
        ),
      ),
    );
  }
}

const String _panSvgIcon = '''
<svg width="42" height="32" viewBox="0 0 42 32" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M39.687 0H2.313C1.038 0 0 1.03725 0 2.313V29.652C0 30.9278 1.038 31.965 2.313 31.965H39.687C40.962 31.965 42 30.9278 42 29.652V2.313C42 1.03725 40.962 0 39.687 0ZM20.7225 24.213C20.7225 24.627 20.3873 24.963 19.9733 24.963L4.14375 24.9735C3.94425 24.9735 3.75375 24.8948 3.6135 24.7545C3.4725 24.6135 3.39375 24.423 3.39375 24.2235V21.864C3.39375 18.561 5.71875 15.7958 8.81475 15.1133C7.962 14.274 7.43175 13.1078 7.43175 11.82C7.43175 9.27 9.507 7.19475 12.057 7.19475C14.607 7.19475 16.6815 9.26925 16.6815 11.82C16.6815 13.1085 16.1505 14.2748 15.2977 15.114C18.3967 15.798 20.724 18.5625 20.724 21.864V24.213H20.7225ZM36.9202 24.3953H24.0285C23.6137 24.3953 23.2785 24.0592 23.2785 23.6453C23.2785 23.2313 23.6137 22.8953 24.0285 22.8953H36.9202C37.335 22.8953 37.6702 23.2313 37.6702 23.6453C37.6702 24.0592 37.335 24.3953 36.9202 24.3953ZM36.9202 19.095H24.0285C23.6137 19.095 23.2785 18.759 23.2785 18.345C23.2785 17.931 23.6137 17.595 24.0285 17.595H36.9202C37.335 17.595 37.6702 17.931 37.6702 18.345C37.6702 18.759 37.335 19.095 36.9202 19.095ZM36.9202 13.7948H24.0285C23.6137 13.7948 23.2785 13.4588 23.2785 13.0448C23.2785 12.6308 23.6137 12.2948 24.0285 12.2948H36.9202C37.335 12.2948 37.6702 12.6308 37.6702 13.0448C37.6702 13.4588 37.335 13.7948 36.9202 13.7948ZM36.9225 8.4915H24.03C23.6153 8.4915 23.28 8.1555 23.28 7.7415C23.28 7.3275 23.6153 6.9915 24.03 6.9915H36.9225C37.3372 6.9915 37.6725 7.3275 37.6725 7.7415C37.6725 8.1555 37.3372 8.4915 36.9225 8.4915Z" fill="#B4BFD2"/>
</svg>
''';

