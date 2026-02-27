import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _sharePolicy(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          color: Theme.of(context).cardTheme.color,
          shape: Theme.of(context).cardTheme.shape,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gear Ghar Privacy Policy',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Last Updated: ${DateTime.now().year}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                
                _buildSection(
                  '1. Information We Collect',
                  'We collect information you provide directly to us, such as when you create an account, make a purchase, or contact us for support.',
                ),
                
                _buildSection(
                  '2. How We Use Your Information',
                  'We use the information we collect to provide, maintain, and improve our services, process transactions, and communicate with you.',
                ),
                
                _buildSection(
                  '3. Information Sharing',
                  'We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as described in this policy.',
                ),
                
                _buildSection(
                  '4. Data Security',
                  'We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.',
                ),
                
                _buildSection(
                  '5. Data Retention',
                  'We retain your personal information only as long as necessary to fulfill the purposes for which we collected it, unless a longer retention period is required by law.',
                ),
                
                _buildSection(
                  '6. Your Rights',
                  'You have the right to access, update, or delete your personal information. You can manage your account settings through your profile.',
                ),
                
                _buildSection(
                  '7. Cookies and Tracking',
                  'We use cookies and similar tracking technologies to track activity on our service and hold certain information.',
                ),
                
                _buildSection(
                  '8. Third-Party Services',
                  'Our service may contain links to third-party websites or services. We are not responsible for the privacy practices of these third parties.',
                ),
                
                _buildSection(
                  '9. Children\'s Privacy',
                  'Our service is not intended for children under the age of 13. We do not knowingly collect personal information from children under 13.',
                ),
                
                _buildSection(
                  '10. Changes to This Policy',
                  'We may update our privacy policy from time to time. We will notify you of any changes by posting the new policy on this page.',
                ),
                
                _buildSection(
                  '11. Contact Us',
                  'If you have any questions about this Privacy Policy, please contact us:',
                ),
                
                const SizedBox(height: 16),
                
                Card(
                  color: Theme.of(context).colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildContactItem(
                          Icons.email,
                          'Email',
                          'privacy@gearghar.com',
                          'mailto:privacy@gearghar.com',
                        ),
                        const SizedBox(height: 12),
                        _buildContactItem(
                          Icons.phone,
                          'Phone',
                          '+977-1-XXXXXXX',
                          'tel:+9771XXXXXXX',
                        ),
                        const SizedBox(height: 12),
                        _buildContactItem(
                          Icons.location_on,
                          'Address',
                          'Kathmandu, Nepal',
                          null,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.security, color: Colors.blue.shade700),
                            const SizedBox(width: 8),
                            Text(
                              'Your Privacy Matters',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'We are committed to protecting your privacy and ensuring the security of your personal information. If you have any concerns about your privacy, please don\'t hesitate to contact us.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).elevatedButtonTheme.style?.backgroundColor?.resolve({}),
                      foregroundColor: Theme.of(context).elevatedButtonTheme.style?.foregroundColor?.resolve({}),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('I Understand'),
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value, String? url) {
    return Builder(
      builder: (context) => InkWell(
        onTap: url != null ? () => _launchUrl(url) : null,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(icon, size: 20, color: Theme.of(context).primaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: url != null ? Colors.blue : null,
                        decoration: url != null ? TextDecoration.underline : null,
                      ),
                    ),
                  ],
                ),
              ),
              if (url != null)
                Icon(
                  Icons.open_in_new,
                  size: 16,
                  color: Colors.grey[600],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  void _sharePolicy(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
