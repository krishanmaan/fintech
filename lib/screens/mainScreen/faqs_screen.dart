import 'package:flutter/material.dart';

/// FAQs screen with search, quick topics, and expandable questions
class FaqsScreen extends StatefulWidget {
  const FaqsScreen({super.key});

  @override
  State<FaqsScreen> createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> {
  int? _expandedIndex;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _faqs = [
    {
      'question': 'Personal Details',
      'answer':
          'Open the Tradebase app to get started and follow the steps. Tradebase doesn\'t charge a fee to create or maintain your Tradebase account.',
    },
    {
      'question': 'Repayment',
      'answer':
          'Repayment is automatically deducted from your salary on your next payday. You can also make early repayments through the app.',
    },
    {
      'question': 'Blackout',
      'answer':
          'Blackout period is when salary advance is not available. This typically happens during salary processing days.',
    },
    {
      'question': 'Fees',
      'answer':
          'We charge a small processing fee for each salary advance. The fee is clearly displayed before you confirm the withdrawal.',
    },
    {
      'question': 'Gold',
      'answer':
          'Digital gold can be purchased and sold directly through the app. You can start with as little as ₹1.',
    },
    {
      'question': 'Buy Gold',
      'answer':
          'To buy gold, go to the Gold section in the app and choose the amount you want to purchase. Payment can be made through UPI or bank transfer.',
    },
    {
      'question': 'Sell Gold for Money',
      'answer':
          'You can sell your digital gold anytime through the app. The money will be credited to your bank account within 24 hours.',
    },
    {
      'question': 'Convert Digital Gold to Gold Coin',
      'answer':
          'Digital gold can be converted to physical gold coins. Minimum conversion amount and delivery charges apply.',
    },
    {
      'question': 'Jiffy Card',
      'answer':
          'Jiffy Card is a prepaid card that allows you to make payments online and offline. You can load money and use it anywhere.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Purple gradient header
          Container(
            height: 120,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF241E63), Color(0xFF482983)],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(context),

                // Main content
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
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),

                          // "How can we help you?" heading
                          const Text(
                            'How can we help you?',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF101828),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Search bar
                          _buildSearchBar(),

                          const SizedBox(height: 24),

                          // Quick Topic section
                          const Text(
                            'Quick Topic',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF101828),
                            ),
                          ),

                          const SizedBox(height: 12),

                          _buildQuickTopics(),

                          const SizedBox(height: 24),

                          // Top Questions header with View all
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Top Questions',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF101828),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // View all functionality
                                },
                                child: const Text(
                                  'View all',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF482983),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // FAQ items
                          ..._faqs.asMap().entries.map((entry) {
                            final index = entry.key;
                            final faq = entry.value;
                            return _buildFaqItem(
                              index,
                              faq['question']!,
                              faq['answer']!,
                            );
                          }).toList(),

                          const SizedBox(height: 40),
                        ],
                      ),
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
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              size: 24,
              color: Colors.white,
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'FAQs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 24), // For centering
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            size: 20,
            color: Color(0xFF98A2B3),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Enter your keyword',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF98A2B3),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTopics() {
    final topics = [
      'Salary Advance',
      'Repayment',
      'Gold',
      'Fees',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: topics.map((topic) {
          return Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFE5E7EB),
                width: 1,
              ),
            ),
            child: Text(
              topic,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFaqItem(int index, String question, String answer) {
    final isExpanded = _expandedIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expandedIndex = isExpanded ? null : index;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF101828),
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.remove : Icons.add,
                    size: 20,
                    color: const Color(0xFF482983),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
