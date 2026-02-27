import 'package:flutter/material.dart';
import 'package:gear_ghar/shared/widgets/primary_app_bar.dart';
import '../../../../core/models/address_model.dart';
import '../../../../core/services/address_api_service.dart';
import 'add_edit_address_screen.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final AddressApiService _addressService = AddressApiService();
  List<Address> _addresses = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final addresses = await _addressService.getAddresses();
      setState(() {
        _addresses = addresses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteAddress(Address address) async {
    try {
      await _addressService.deleteAddress(address.id!);
      _loadAddresses();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Address deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete address: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _setDefaultAddress(Address address) async {
    try {
      await _addressService.setDefaultAddress(address.id!);
      _loadAddresses();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Default address updated'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to set default address: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(title: 'My Addresses'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading addresses',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(_error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadAddresses,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : _addresses.isEmpty
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
                    onPressed: () => _navigateToAddEditAddress(),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Address'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadAddresses,
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _addresses.length,
                itemBuilder: (context, index) {
                  final address = _addresses[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildAddressCard(context, address),
                  );
                },
              ),
            ),
      floatingActionButton: _addresses.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _navigateToAddEditAddress(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildAddressCard(BuildContext context, Address address) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: address.isDefault == true
              ? Theme.of(context).primaryColor
              : Colors.grey.shade300,
          width: address.isDefault == true ? 2 : 1,
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
                  address.displayName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (address.isDefault == true)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.1),
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
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Phone: ${address.phoneNumber ?? "N/A"}',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _navigateToAddEditAddress(address: address),
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
                  onPressed: address.isDefault == true
                      ? null
                      : () => _showDeleteConfirmation(context, address),
                  style: TextButton.styleFrom(
                    foregroundColor: address.isDefault == true
                        ? Colors.grey
                        : Colors.red,
                  ),
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      color: address.isDefault == true
                          ? Colors.grey
                          : Colors.red,
                    ),
                  ),
                ),
                if (address.isDefault != true) ...[
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _setDefaultAddress(address),
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

  void _navigateToAddEditAddress({Address? address}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditAddressScreen(address: address),
      ),
    ).then((_) => _loadAddresses());
  }

  void _showDeleteConfirmation(BuildContext context, Address address) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
          title: Text(
            'Delete Address',
            style: TextStyle(
              color: Theme.of(context).dialogTheme.titleTextStyle?.color,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this address?',
            style: TextStyle(
              color: Theme.of(context).dialogTheme.contentTextStyle?.color,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAddress(address);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
