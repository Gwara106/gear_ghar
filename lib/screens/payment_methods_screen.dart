import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildPaymentMethodCard(
            context,
            cardType: 'VISA',
            lastFour: '4242',
            expiryDate: '12/25',
            isDefault: true,
          ),
          const SizedBox(height: 16),
          _buildPaymentMethodCard(
            context,
            cardType: 'MASTERCARD',
            lastFour: '1881',
            expiryDate: '06/26',
            isDefault: false,
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Implement add new payment method
              _showAddPaymentMethod(context);
            },
            icon: const Icon(Icons.add),
            label: const Text('Add New Card'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () {
              // TODO: Implement add PayPal
            },
            icon: Image.asset(
              'assets/images/paypal.png',
              height: 24,
              width: 24,
              errorBuilder: (context, error, stackTrace) => 
                  const Icon(Icons.payment, size: 24),
            ),
            label: const Text('Add PayPal'),
            style: TextButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(
    BuildContext context, {
    required String cardType,
    required String lastFour,
    required String expiryDate,
    required bool isDefault,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDefault ? Theme.of(context).primaryColor : Colors.grey.shade300,
          width: isDefault ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    cardType == 'VISA'
                        ? Image.asset(
                            'assets/images/visa.png',
                            height: 24,
                            width: 40,
                            errorBuilder: (context, error, stackTrace) => 
                                const Icon(Icons.credit_card, size: 24),
                          )
                        : cardType == 'MASTERCARD'
                            ? Image.asset(
                                'assets/images/mastercard.png',
                                height: 24,
                                width: 40,
                                errorBuilder: (context, error, stackTrace) => 
                                    const Icon(Icons.credit_card, size: 24),
                              )
                            : const Icon(Icons.credit_card, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      '$cardType •••• $lastFour',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                if (isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'DEFAULT',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Expires $expiryDate',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      onPressed: () {
                        // TODO: Implement edit payment method
                      },
                      color: Colors.grey[600],
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: () {
                        if (!isDefault) {
                          _showDeleteConfirmation(context);
                        }
                      },
                      color: isDefault ? Colors.grey[400] : Colors.red[400],
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
            if (!isDefault) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    // TODO: Implement set as default
                  },
                  child: const Text('Set as Default'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAddPaymentMethod(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Card',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Card Number',
                hintText: '1234 5678 9012 3456',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.credit_card),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Expiry Date',
                      hintText: 'MM/YY',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      hintText: '123',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Cardholder Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement save payment method
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Payment method added successfully'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text('Save Card'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Payment Method'),
          content: const Text(
              'Are you sure you want to remove this payment method?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement delete payment method logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Payment method removed successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text(
                'Remove',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
