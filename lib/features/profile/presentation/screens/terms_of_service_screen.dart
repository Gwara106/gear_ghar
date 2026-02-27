import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Terms of Service'),
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
            onPressed: () => _shareTerms(context),
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
                  'Gear Ghar Terms of Service',
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
                  '1. Acceptance of Terms',
                  'By accessing and using Gear Ghar, you accept and agree to be bound by the terms and provision of this agreement.',
                ),
                
                _buildSection(
                  '2. Use License',
                  'Permission is granted to temporarily download one copy of Gear Ghar for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title.',
                ),
                
                _buildSection(
                  '3. Disclaimer',
                  'The materials on Gear Ghar are provided on an \'as is\' basis. Gear Ghar makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties including without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights.',
                ),
                
                _buildSection(
                  '4. Limitations',
                  'In no event shall Gear Ghar or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the materials on Gear Ghar.',
                ),
                
                _buildSection(
                  '5. Accuracy of Materials',
                  'The materials appearing on Gear Ghar could include technical, typographical, or photographic errors. Gear Ghar does not warrant that any of the materials on its website are accurate, complete, or current.',
                ),
                
                _buildSection(
                  '6. Links',
                  'Gear Ghar has not reviewed all of the sites linked to our app and is not responsible for the contents of any such linked site. The inclusion of any link does not imply endorsement by Gear Ghar of the site.',
                ),
                
                _buildSection(
                  '7. Modifications',
                  'Gear Ghar may revise these terms of service for its app at any time without notice. By using this app, you are agreeing to be bound by the then current version of these terms of service.',
                ),
                
                _buildSection(
                  '8. Governing Law',
                  'These terms and conditions are governed by and construed in accordance with the laws of Nepal and you irrevocably submit to the exclusive jurisdiction of the courts in that State or location.',
                ),
                
                _buildSection(
                  '9. Privacy Policy',
                  'Your privacy is important to us. Our Privacy Policy explains how we collect, use, and protect your information when you use our services.',
                ),
                
                _buildSection(
                  '10. Contact Information',
                  'If you have any questions about these Terms of Service, please contact us at:',
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
                          'support@gearghar.com',
                          'mailto:support@gearghar.com',
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

  void _shareTerms(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
