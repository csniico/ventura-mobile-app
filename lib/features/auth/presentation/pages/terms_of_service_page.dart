import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Terms of Service')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      children: [
                        TextSpan(text: 'Welcome to '),
                        TextSpan(
                          text: 'Ventura',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              '. These Terms of Service govern your use of our website and services provided by ',
                        ),
                        TextSpan(
                          text: 'csniico',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // 1. Acceptance of Terms
              _buildSection(
                title: '1. Acceptance of Terms',
                content:
                    'By accessing or using Ventura, you agree to be bound by these Terms of Service and all applicable laws and regulations. If you do not agree with any of these terms, you are prohibited from using or accessing this site.',
              ),

              // 2. User Accounts
              _buildSection(
                title: '2. User Accounts',
                content:
                    'To access certain features of the service, you may be required to create an account. We offer authentication through third-party services such as Google Sign-in.',
                bulletPoints: [
                  'You are responsible for maintaining the confidentiality of your account and password.',
                  'You agree to provide accurate, current, and complete information during the registration process.',
                  'We reserve the right to terminate accounts that provide false information or violate these terms.',
                ],
              ),

              // 3. Payments and Subscriptions
              _buildSection(
                title: '3. Payments and Subscriptions',
                content:
                    'Ventura offers both one-time purchases and recurring subscription plans.',
                bulletPoints: [
                  'Billing: By providing a payment method, you authorize us to charge the applicable fees to that payment method.',
                  'Recurring Payments: Subscriptions automatically renew unless cancelled. You can manage or cancel your subscription through your account settings or by contacting support.',
                  'Refunds: Refund requests are handled on a case-by-case basis via our support portal.',
                ],
              ),

              // 4. Intellectual Property
              _buildSection(
                title: '4. Intellectual Property',
                content:
                    'The content, features, and functionality of Ventura (including but not limited to all information, software, text, displays, images, video, and audio) are owned by csniico and are protected by international copyright, trademark, patent, trade secret, and other intellectual property or proprietary rights laws.',
              ),

              // 5. Prohibited Uses
              _buildSection(
                title: '5. Prohibited Uses',
                content: 'You agree not to use the service:',
                bulletPoints: [
                  'In any way that violates any applicable local, state, national, or international law.',
                  'To transmit any advertising or promotional material, including "junk mail," "chain letter," "spam," or any other similar solicitation.',
                  'To impersonate or attempt to impersonate csniico, a csniico employee, another user, or any other person or entity.',
                  'To engage in any other conduct that restricts or inhibits anyone\'s use or enjoyment of the service.',
                ],
              ),

              // 6. Limitation of Liability
              _buildSection(
                title: '6. Limitation of Liability',
                content:
                    'In no event shall csniico, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential, or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from your access to or use of or inability to access or use the service.',
              ),

              // 7. Governing Law
              _buildSection(
                title: '7. Governing Law',
                content:
                    'These Terms shall be governed and construed in accordance with the laws of the jurisdiction in which csniico operates, without regard to its conflict of law provisions.',
              ),

              // 8. Changes to Terms
              _buildSection(
                title: '8. Changes to Terms',
                content:
                    'We reserve the right, at our sole discretion, to modify or replace these Terms at any time. We will provide notice of any changes by posting the new Terms on this page.',
              ),

              // 9. Contact Us
              const Text(
                '9. Contact Us',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'If you have any questions about these Terms, please contact us:',
                style: TextStyle(fontSize: 15, height: 1.6),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Business Name: csniico',
                      style: TextStyle(fontSize: 15, height: 1.6),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Address: GM-118-9658',
                      style: TextStyle(fontSize: 15, height: 1.6),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'Support & Help: ',
                          style: TextStyle(fontSize: 15, height: 1.6),
                        ),
                        InkWell(
                          onTap: () =>
                              _launchUrl('https://ventura.csniico.site/help'),
                          child: const Text(
                            'ventura.csniico.site/help',
                            style: TextStyle(
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    List<String>? bulletPoints,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(content, style: const TextStyle(fontSize: 15, height: 1.6)),
        if (bulletPoints != null) ...[
          const SizedBox(height: 12),
          ...bulletPoints.map(
            (point) => Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 15, height: 1.6)),
                  Expanded(
                    child: Text(
                      point,
                      style: const TextStyle(fontSize: 15, height: 1.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 32),
      ],
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $urlString');
    }
  }
}
