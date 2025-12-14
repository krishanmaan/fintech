import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../services/static_page_service.dart';

class StaticContentScreen extends StatefulWidget {
  final String pageType;
  final String title;

  const StaticContentScreen({
    super.key,
    required this.pageType,
    required this.title,
  });

  @override
  State<StaticContentScreen> createState() => _StaticContentScreenState();
}

class _StaticContentScreenState extends State<StaticContentScreen> {
  final StaticPageService _staticPageService = StaticPageService();
  bool _isLoading = true;
  StaticPageModel? _pageData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPage();
  }

  Future<void> _fetchPage() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _staticPageService.getPage(widget.pageType);
      if (mounted) {
        setState(() {
          _pageData = data;
          _isLoading = false;
          if (data == null) {
            _errorMessage = 'Failed to load content.';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'An error occurred. Please try again later.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF482983),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 10),
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
                    _buildHeader(context),
                    Expanded(
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF482983),
                              ),
                            )
                          : _errorMessage != null
                          ? _buildErrorView()
                          : _buildContent(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back,
                size: 24,
                color: Color(0xFF101828),
              ),
            ),
          ),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF101828),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF482983),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_pageData == null) {
      return const Center(child: Text('No content available.'));
    }

    if (widget.pageType == 'FAQ') {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How can we help you?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF101828),
              ),
            ),
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 24),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Top Questions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF101828),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View all',
                    style: TextStyle(
                      color: Color(0xFF482983),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildFaqList(_pageData!.content),
            const SizedBox(height: 40),
          ],
        ),
      );
    }

    if (widget.pageType == 'CONTACT') {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF482983), Color(0xFF241E63)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF482983).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Track Request',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Check the status of your query',
                          style: TextStyle(fontSize: 13, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Get in touch',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF101828),
              ),
            ),
            const SizedBox(height: 16),
            _buildContactList(_pageData!.content),
            const SizedBox(height: 40),
          ],
        ),
      );
    }

    // Default view for other pages
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Html(
            data: _pageData!.content,
            style: {
              "body": Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
                fontSize: FontSize(14),
                color: const Color(0xFF374151),
                fontFamily: 'Inter',
                lineHeight: LineHeight(1.5),
              ),
              "h1": Style(
                fontSize: FontSize(22),
                fontWeight: FontWeight.bold,
                display: Display.block,
                color: const Color(0xFF101828),
                margin: Margins.only(bottom: 16),
              ),
              "h2": Style(
                fontSize: FontSize(18),
                fontWeight: FontWeight.bold,
                margin: Margins.only(top: 24, bottom: 12),
                color: const Color(0xFF1F2937),
              ),
              "p": Style(
                color: const Color(0xFF6B7280),
                margin: Margins.only(bottom: 16),
              ),
              "li": Style(
                color: const Color(0xFF6B7280),
                margin: Margins.only(bottom: 8),
              ),
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildFaqList(String htmlContent) {
    // Basic regex parsing to extract Q&A
    final RegExp qaRegex = RegExp(
      r'<h3>(.*?)<\/h3>\s*<p>(.*?)<\/p>',
      caseSensitive: false,
      dotAll: true,
    );

    final List<Map<String, String>> faqItems = [];
    final matches = qaRegex.allMatches(htmlContent);

    for (final match in matches) {
      if (match.groupCount >= 2) {
        faqItems.add({
          'question': match.group(1)!.trim(),
          'answer': match.group(2)!.trim(),
        });
      }
    }

    if (faqItems.isEmpty) {
      return Html(data: htmlContent);
    }

    return Column(
      children: faqItems.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEAECF0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text(
                item['question']!,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              expandedAlignment: Alignment.centerLeft,
              iconColor: const Color(0xFF482983),
              collapsedIconColor: const Color(0xFF9CA3AF),
              children: [
                Text(
                  item['answer']!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContactList(String htmlContent) {
    final parts = htmlContent.split('<h3>');
    List<Widget> contactCards = [];

    for (int i = 1; i < parts.length; i++) {
      final part = parts[i];
      final closeTagIndex = part.indexOf('</h3>');
      if (closeTagIndex != -1) {
        final title = part.substring(0, closeTagIndex).trim();
        String content = part.substring(closeTagIndex + 5).trim();

        IconData icon = Icons.info_outline;
        Color iconColor = const Color(0xFF482983);

        if (title.toLowerCase().contains('email')) {
          icon = Icons.email_outlined;
          iconColor = Colors.orange;
        } else if (title.toLowerCase().contains('phone')) {
          icon = Icons.phone_outlined;
          iconColor = Colors.green;
        } else if (title.toLowerCase().contains('address')) {
          icon = Icons.location_on_outlined;
          iconColor = Colors.red;
        } else if (title.toLowerCase().contains('chat')) {
          icon = Icons.chat_bubble_outline;
          iconColor = Colors.blue;
        } else if (title.toLowerCase().contains('follow')) {
          icon = Icons.share_outlined;
          iconColor = Colors.purple;
        }

        contactCards.add(
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFEAECF0)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF101828).withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: iconColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: iconColor, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Html(
                    data: content,
                    style: {
                      "body": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                        fontSize: FontSize(14),
                        color: const Color(0xFF6B7280),
                        fontFamily: 'Inter',
                      ),
                      "p": Style(margin: Margins.only(bottom: 8)),
                      "ul": Style(
                        margin: Margins.only(left: 0, top: 0, bottom: 0),
                      ), // Fixed padding
                      "li": Style(margin: Margins.only(bottom: 4)),
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    return Column(children: contactCards);
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Color(0xFF9CA3AF)),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Enter your keyword',
                hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(color: Color(0xFF1F2937), fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTopics() {
    final topics = ['Salary Advance', 'Repayment', 'Gold', 'Jify Card'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: topics.map((topic) {
          final isSelected = topic == 'Salary Advance';
          return Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF482983)
                    : const Color(0xFFE5E7EB),
              ),
            ),
            child: Text(
              topic,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF482983)
                    : const Color(0xFF6B7280),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
