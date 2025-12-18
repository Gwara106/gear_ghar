import 'package:flutter/material.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Addresses'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildAddressCard(
            context,
            name: 'Home',
            address: '123 Main Street, Apt 4B\nNew York, NY 10001',
            phone: '+1 234 567 8900',
            isDefault: true,
          ),
          const SizedBox(height: 16),
          _buildAddressCard(
            context,
            name: 'Work',
            address: '456 Business Ave, Floor 5\nNew York, NY 10022',
            phone: '+1 234 567 8901',
            isDefault: false,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement add new address
            },
            icon: const Icon(Icons.add),
            label: const Text('Add New Address'),
            style: ElevatedButton.styleFrom(
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

  Widget _buildAddressCard(
    BuildContext context, {
    required String name,
    required String address,
    required String phone,
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
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
            const SizedBox(height: 12),
            Text(
              address,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Phone: $phone',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // TODO: Implement edit address
                  },
                  child: const Text('Edit'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    if (!isDefault) {
                      // TODO: Implement delete address
                      _showDeleteConfirmation(context);
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: isDefault ? Colors.grey : Colors.red,
                  ),
                  child: const Text('Delete'),
                ),
                if (!isDefault) ...[
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement set as default
                    },
                    child: const Text('Set as Default'),
                  ),
                ],
              ],
            ),
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
          title: const Text('Delete Address'),
          content: const Text('Are you sure you want to delete this address?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement delete address logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Address deleted successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
