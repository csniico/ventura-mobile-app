import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Effective Date: December 1, 2025',
                  style: TextStyle(fontSize: 12, color: Colors.black45),
                ),
                const SizedBox(height: 16),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(text: 'At '),
                      TextSpan(
                        text: 'csniico',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            ', we are committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your information when you use our services.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(thickness: 1),
              ],
            ),
            const SizedBox(height: 32),

            // 1. Information We Collect
            _buildSection(
              title: '1. Information We Collect',
              content:
                  'We collect information that you provide directly to us or through third-party services:',
              bulletPoints: [
                'Personal Identifiers: Name, email address, and profile pictures.',
                'Authentication Data: When you sign in with Google, we receive your basic profile information as permitted by your Google account settings.',
                'Payment Information: For one-time and recurring payments, we process transaction details. Note that we use secure payment processors and do not store full credit card numbers on our servers.',
                'Usage Data: Information about how you interact with our app, collected via our in-house analytics engine.',
              ],
            ),

            // 2. How We Use Your Information
            _buildSection(
              title: '2. How We Use Your Information',
              content: 'We use the collected data for the following purposes:',
              bulletPoints: [
                'To provide and maintain our service.',
                'To process your payments and manage subscriptions.',
                'To personalize your experience (e.g., displaying your profile picture).',
                'To analyze usage patterns and improve our application via our in-house analytics.',
                'To communicate with you regarding updates or support.',
              ],
            ),

            // 3. Analytics
            _buildSection(
              title: '3. Analytics',
              content:
                  'We use an in-house analytics engine to monitor and analyze the use of our service. Unlike third-party services, this data remains within our controlled environment and is used solely to improve our platform\'s performance and user experience.',
            ),

            // 4. GDPR Compliance
            const Text(
              '4. GDPR Compliance',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                border: Border.all(color: const Color(0xFFBFDBFE)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'If you are located in the European Economic Area (EEA), you have specific data protection rights:',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF1E40AF),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...[
                    'Right of Access: You can request copies of your personal data.',
                    'Right to Rectification: You can request that we correct inaccurate information.',
                    'Right to Erasure: You can request that we delete your data.',
                    'Right to Restrict Processing: You can object to our processing of your data.',
                  ].map(
                    (point) => Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '• ',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF1E40AF),
                              height: 1.6,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              point,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF1E40AF),
                                height: 1.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Our legal basis for collecting and using your data is typically your consent or the necessity to perform a contract (e.g., processing payments).',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF1E40AF),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 5. CCPA/CPRA Compliance
            const Text(
              '5. CCPA/CPRA Compliance',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'California residents have the following rights:',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...[
                    'Right to Know: You can request disclosure of the categories and specific pieces of personal data we have collected.',
                    'Right to Delete: You can request the deletion of your personal information.',
                    'Right to Non-Discrimination: We will not discriminate against you for exercising your privacy rights.',
                  ].map(
                    (point) => Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '• ',
                            style: TextStyle(fontSize: 15, height: 1.6),
                          ),
                          Expanded(
                            child: Text(
                              point,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'We do not sell your personal information to third parties.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.6,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 6. CalOPPA Compliance
            _buildSection(
              title: '6. CalOPPA Compliance',
              content:
                  'We comply with the California Online Privacy Protection Act. Our users can visit our site anonymously (before signing in), and we provide a clear link to this Privacy Policy on our main pages. We notify users of any Privacy Policy changes on this page.',
            ),

            // 7. Data Deletion & Your Rights
            const Text(
              '7. Data Deletion & Your Rights',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text(
                  'You can exercise your right to delete your data or request information at any time. Please visit our help and data management portal at: ',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.6,
                  ),
                ),
                InkWell(
                  onTap: () => _launchUrl('https://ventura.csniico.site/help'),
                  child: const Text(
                    'https://ventura.csniico.site/help',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // 8. Contact Us
            const Text(
              '8. Contact Us',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'If you have any questions about this Privacy Policy, please contact us:',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
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
                        'Support Link: ',
                        style: TextStyle(fontSize: 15, height: 1.6),
                      ),
                      InkWell(
                        onTap: () =>
                            _launchUrl('https://ventura.csniico.site/help'),
                        child: const Text(
                          'ventura.csniico.site/help',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
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
            const SizedBox(height: 40),

            // Related Links
            const Divider(thickness: 1),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/terms-of-service');
                  },
                  child: const Text(
                    'Terms of Service',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black45,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Already on this page
                  },
                  child: const Text(
                    'Privacy Policy (this page)',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black45,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
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
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black87,
            height: 1.6,
          ),
        ),
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
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.6,
                      ),
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
