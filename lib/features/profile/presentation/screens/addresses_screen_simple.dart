import 'package:flutter/material.dart';
import '../../../../providers/address_provider.dart';
import 'package:provider/provider.dart';

class AddressesScreenSimple extends StatefulWidget {
  const AddressesScreenSimple({super.key});

  @override
  State<AddressesScreenSimple> createState() => _AddressesScreenSimpleState();
}

class _AddressesScreenSimpleState extends State<AddressesScreenSimple> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Addresses'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 0,
      ),
      body: Consumer<AddressProvider>(
        builder: (context, addressProvider, child) {
          // Show loading if address provider is not initialized
          if (!addressProvider.isInitialized) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading addresses...'),
                ],
              ),
            );
          }

          final addresses = addressProvider.addresses;
          
          return addresses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No addresses yet',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      const Text('Add your first address to get started'),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => _showAddAddressDialog(addressProvider),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Address'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    // Address provider doesn't need refresh as it's local state
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: addresses.length,
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildAddressCard(context, address, addressProvider),
                      );
                    },
                  ),
                );
        },
      ),
      floatingActionButton: Consumer<AddressProvider>(
        builder: (context, addressProvider, child) {
          return addressProvider.addresses.isNotEmpty
              ? FloatingActionButton(
                  onPressed: () => _showAddAddressDialog(addressProvider),
                  child: const Icon(Icons.add),
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, Address address, AddressProvider addressProvider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: address.isDefault
              ? Theme.of(context).primaryColor
              : Colors.grey.shade300,
          width: address.isDefault ? 2 : 1,
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
                  address.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (address.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
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
              address.fullAddress,
              style: TextStyle(
                fontSize: 14, 
                color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.grey.shade300 
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Phone: ${address.phone}',
              style: TextStyle(
                fontSize: 14, 
                color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.grey.shade300 
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _showEditAddressDialog(address, addressProvider),
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? Colors.white 
                          : Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: address.isDefault ? null : () => _showDeleteConfirmation(context, address, addressProvider),
                  style: TextButton.styleFrom(
                    foregroundColor: address.isDefault ? Colors.grey : Colors.red,
                  ),
                  child: const Text('Delete'),
                ),
                if (!address.isDefault) ...[
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      await addressProvider.setDefaultAddress(address.id!);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Default address updated'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).brightness == Brightness.dark 
                          ? const Color(0xFF2A2A2A)
                          : Colors.black,
                    ),
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

  void _showAddAddressDialog(AddressProvider addressProvider) {
    final nameController = TextEditingController();
    final streetController = TextEditingController();
    final cityController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Address'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Address Name (e.g., Home, Office)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: streetController,
                decoration: const InputDecoration(
                  labelText: 'Street Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty &&
                  streetController.text.isNotEmpty &&
                  cityController.text.isNotEmpty &&
                  phoneController.text.isNotEmpty) {
                final newAddress = Address(
                  name: nameController.text,
                  street: streetController.text,
                  city: cityController.text,
                  phone: phoneController.text,
                );
                await addressProvider.addAddress(newAddress);
                if (mounted) {
                  Navigator.pop(context);
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditAddressDialog(Address address, AddressProvider addressProvider) {
    final nameController = TextEditingController(text: address.name);
    final streetController = TextEditingController(text: address.street);
    final cityController = TextEditingController(text: address.city);
    final phoneController = TextEditingController(text: address.phone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Address'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Address Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: streetController,
                decoration: const InputDecoration(
                  labelText: 'Street Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty &&
                  streetController.text.isNotEmpty &&
                  cityController.text.isNotEmpty &&
                  phoneController.text.isNotEmpty) {
                final updatedAddress = Address(
                  id: address.id,
                  name: nameController.text,
                  street: streetController.text,
                  city: cityController.text,
                  phone: phoneController.text,
                  isDefault: address.isDefault,
                );
                await addressProvider.updateAddress(updatedAddress);
                if (mounted) {
                  Navigator.pop(context);
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text('Update', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Address address, AddressProvider addressProvider) {
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
              onPressed: () async {
                Navigator.of(context).pop();
                await addressProvider.deleteAddress(address.id!);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Address deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
