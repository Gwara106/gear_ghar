import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Help Center'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'FAQs'),
              Tab(text: 'Orders'),
              Tab(text: 'Payments'),
              Tab(text: 'Returns'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFaqsTab(),
            _buildOrdersTab(),
            _buildPaymentsTab(),
            _buildReturnsTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _showContactOptions(context);
          },
          icon: const Icon(Icons.help_outline),
          label: const Text('Need Help?'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildFaqsTab() {
    final List<Map<String, String>> faqs = [
      {
        'question': 'How do I track my order?',
        'answer': 'You can track your order by going to the Orders section in your profile and selecting the order you want to track.',
      },
      {
        'question': 'What is your return policy?',
        'answer': 'We offer a 30-day return policy for most items. Items must be unused and in their original packaging with all tags attached.',
      },
      {
        'question': 'How can I change my shipping address?',
        'answer': 'You can update your shipping address in the Addresses section of your profile before placing an order.',
      },
      {
        'question': 'What payment methods do you accept?',
        'answer': 'We accept all major credit/debit cards, PayPal, and select digital wallets.',
      },
      {
        'question': 'How do I apply a promo code?',
        'answer': 'You can enter your promo code during checkout in the payment section.',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: faqs.length,
      itemBuilder: (context, index) {
        return _buildFaqItem(
          question: faqs[index]['question']!,
          answer: faqs[index]['answer']!,
        );
      },
    );
  }

  Widget _buildOrdersTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _HelpSectionItem(
          title: 'Order Status',
          description: 'Check the current status of your order and view estimated delivery dates.',
        ),
        _HelpSectionItem(
          title: 'Track Package',
          description: 'Track your package in real-time with our tracking system.',
        ),
        _HelpSectionItem(
          title: 'Cancel Order',
          description: 'Request to cancel your order if it hasn\'t been shipped yet.',
        ),
        _HelpSectionItem(
          title: 'Order History',
          description: 'View your complete order history and reorder items easily.',
        ),
      ],
    );
  }

  Widget _buildPaymentsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _HelpSectionItem(
          title: 'Payment Methods',
          description: 'Add, edit, or remove your payment methods.',
        ),
        _HelpSectionItem(
          title: 'Billing Information',
          description: 'Update your billing address and view billing history.',
        ),
        _HelpSectionItem(
          title: 'Payment Security',
          description: 'Learn about our secure payment processing.',
        ),
        _HelpSectionItem(
          title: 'Refund Status',
          description: 'Check the status of your refund request.',
        ),
      ],
    );
  }

  Widget _buildReturnsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const _HelpSectionItem(
          title: 'Start a Return',
          description: 'Initiate a return for items you\'re not completely satisfied with.',
        ),
        const _HelpSectionItem(
          title: 'Return Policy',
          description: 'Learn about our return policy and conditions.',
        ),
        const _HelpSectionItem(
          title: 'Return Status',
          description: 'Track the status of your return and refund.',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Need Help with Returns?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Our customer service team is here to help with any return-related questions.',
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        _showContactOptions(context);
                      },
                      child: const Text('Contact Support'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFaqItem({
    required String question,
    required String answer,
  }) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(answer),
        ),
      ],
    );
  }

  void _showContactOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildContactOption(
              context,
              icon: Icons.chat_outlined,
              title: 'Live Chat',
              subtitle: 'Chat with our support team',
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement live chat
                _showComingSoon(context);
              },
            ),
            _buildContactOption(
              context,
              icon: Icons.email_outlined,
              title: 'Email Us',
              subtitle: 'support@gearghar.com',
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement email
                _showComingSoon(context);
              },
            ),
            _buildContactOption(
              context,
              icon: Icons.phone_outlined,
              title: 'Call Us',
              subtitle: '+1 (800) 123-4567',
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement phone call
                _showComingSoon(context);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This feature is coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class _HelpSectionItem extends StatelessWidget {
  final String title;
  final String description;

  const _HelpSectionItem({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          // TODO: Navigate to detailed help section
        },
      ),
    );
  }
}
