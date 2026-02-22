import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/cart_provider.dart';
import '../../../../providers/address_provider.dart';

class SimpleCheckoutScreen extends StatefulWidget {
  const SimpleCheckoutScreen({super.key});

  @override
  State<SimpleCheckoutScreen> createState() => _SimpleCheckoutScreenState();
}

class _SimpleCheckoutScreenState extends State<SimpleCheckoutScreen> {
  String? _selectedAddressId;
  int _selectedPaymentMethod = 0;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD0D0D0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Checkout'),
      ),
      body: Consumer2<CartProvider, AddressProvider>(
        builder: (context, cartProvider, addressProvider, child) {
          if (cartProvider.cartItems.isEmpty) {
            return const Center(
              child: Text('Your cart is empty'),
            );
          }

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
          
          // Set default selected address if not set
          if (_selectedAddressId == null && addresses.isNotEmpty) {
            _selectedAddressId = addressProvider.defaultAddress?.id ?? addresses.first.id;
          }

          final subtotal = cartProvider.totalPrice;
          final deliveryFee = 50.0;
          final tax = subtotal * 0.13;
          final total = subtotal + deliveryFee + tax;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Delivery Address Section
                _buildSectionHeader('Delivery Address'),
                _buildAddressSection(addressProvider),
                const SizedBox(height: 20),

                // Payment Method Section
                _buildSectionHeader('Payment Method'),
                _buildPaymentMethodSection(),
                const SizedBox(height: 20),

                // Order Summary Section
                _buildSectionHeader('Order Summary'),
                _buildOrderSummary(cartProvider, subtotal, deliveryFee, tax, total),
                const SizedBox(height: 20),

                // Place Order Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_selectedAddressId == null || _isProcessing) ? null : () => _placeOrder(context, total),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isProcessing
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Place Order',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAddressSection(AddressProvider addressProvider) {
    final addresses = addressProvider.addresses;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          if (addresses.isEmpty)
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: Colors.grey[600]),
                    const SizedBox(width: 12),
                    const Text('No shipping addresses'),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _showAddAddressDialog(addressProvider),
                    child: const Text('Add Shipping Address'),
                  ),
                ),
              ],
            )
          else ...[
            ...List.generate(addresses.length, (index) {
              final address = addresses[index];
              final isSelected = _selectedAddressId == address.id;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedAddressId = address.id;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: isSelected ? Colors.black.withOpacity(0.05) : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        Radio<String>(
                          value: address.id!,
                          groupValue: _selectedAddressId,
                          onChanged: (value) {
                            setState(() {
                              _selectedAddressId = value;
                            });
                          },
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                address.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(address.street),
                              Text(address.city),
                              Text(address.phone),
                            ],
                          ),
                        ),
                        if (address.isDefault)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green),
                            ),
                            child: const Text(
                              'DEFAULT',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _showAddAddressDialog(addressProvider),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black),
                ),
                child: const Text(
                  '+ Add New Address',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildPaymentOption(
            0,
            Icons.credit_card,
            'Credit/Debit Card',
            'Pay securely with your card',
          ),
          const SizedBox(height: 12),
          _buildPaymentOption(
            1,
            Icons.money,
            'Cash on Delivery',
            'Pay when you receive your order',
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(int value, IconData icon, String title, String subtitle) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: _selectedPaymentMethod == value
                ? Colors.black
                : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
          color: _selectedPaymentMethod == value
              ? Colors.black.withOpacity(0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Radio<int>(
              value: value,
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
            ),
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(CartProvider cartProvider, double subtotal, double deliveryFee, double tax, double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Cart Items Summary
          ...List.generate(
            cartProvider.cartItems.length > 2 ? 2 : cartProvider.cartItems.length,
            (index) {
              final item = cartProvider.cartItems[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${item.product['name']} x${item.quantity}',
                        style: const TextStyle(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'Rs. ${(double.parse(item.product['price'].toString().replaceAll('Rs. ', '').replaceAll(',', '')) * item.quantity).toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              );
            },
          ),
          if (cartProvider.cartItems.length > 2)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '+${cartProvider.cartItems.length - 2} more items',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),
          const Divider(),
          const SizedBox(height: 8),
          _buildSummaryRow('Subtotal', subtotal),
          _buildSummaryRow('Delivery Fee', deliveryFee),
          _buildSummaryRow('Tax', tax),
          const Divider(),
          _buildSummaryRow('Total', total, isBold: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
            ),
          ),
          Text(
            'Rs. ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
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
        title: const Text('Add New Address'),
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
                
                // Set the newly added address as selected
                setState(() {
                  _selectedAddressId = newAddress.id;
                });
                
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text('Add Address', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _placeOrder(BuildContext context, double total) async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate order processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isProcessing = false;
    });

    // Clear cart
    Provider.of<CartProvider>(context, listen: false).clearCart();

    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Order Placed Successfully!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Your order has been placed successfully.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Order ID: #${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Total Amount: Rs. ${total.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (_selectedPaymentMethod == 1)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Please pay cash when you receive your order.',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.popUntil(context, (route) => route.isFirst); // Go to home
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text('Continue Shopping', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
