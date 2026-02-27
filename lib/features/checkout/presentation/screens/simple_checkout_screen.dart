import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/cart_provider.dart';
import '../../../../providers/address_provider.dart';
import '../../../../core/services/order_api_service.dart';
import '../../../../core/models/order_model.dart';
import '../../../../shared/providers/auth_provider.dart';

const double _kCheckoutTaxRate = 0.13;
const double _kCheckoutDeliveryFee = 50.0;

class SimpleCheckoutScreen extends StatefulWidget {
  const SimpleCheckoutScreen({super.key});

  @override
  State<SimpleCheckoutScreen> createState() => _SimpleCheckoutScreenState();
}

class _SimpleCheckoutScreenState extends State<SimpleCheckoutScreen> {
  String? _selectedAddressId;
  int _selectedPaymentMethod = 0;
  bool _isProcessing = false;
  final OrderApiService _orderService = OrderApiService();

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
            return const Center(child: Text('Your cart is empty'));
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
            _selectedAddressId =
                addressProvider.defaultAddress?.id ?? addresses.first.id;
          }

          final subtotal = cartProvider.totalPrice;
          final deliveryFee = _kCheckoutDeliveryFee;
          final tax = subtotal * _kCheckoutTaxRate;
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
                _buildOrderSummary(
                  cartProvider,
                  subtotal,
                  deliveryFee,
                  tax,
                  total,
                ),
                const SizedBox(height: 20),

                // Place Order Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_selectedAddressId == null || _isProcessing)
                        ? null
                        : () => _placeOrder(
                            context,
                            subtotal: subtotal,
                            deliveryFee: deliveryFee,
                            tax: tax,
                            total: total,
                          ),
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
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      color: isSelected
                          ? Colors.black.withValues(alpha: 0.05)
                          : Colors.transparent,
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
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

  Widget _buildPaymentOption(
    int value,
    IconData icon,
    String title,
    String subtitle,
  ) {
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
              ? Colors.black.withValues(alpha: 0.05)
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
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(
    CartProvider cartProvider,
    double subtotal,
    double deliveryFee,
    double tax,
    double total,
  ) {
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
            cartProvider.cartItems.length > 2
                ? 2
                : cartProvider.cartItems.length,
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
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
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

                if (mounted) {
                  Navigator.pop(context);
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text(
              'Add Address',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _placeOrder(
    BuildContext context, {
    required double subtotal,
    required double deliveryFee,
    required double tax,
    required double total,
  }) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final addressProvider = Provider.of<AddressProvider>(
        context,
        listen: false,
      );
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Get selected address
      final selectedAddress = addressProvider.addresses.firstWhere(
        (addr) => addr.id == _selectedAddressId,
        orElse: () => addressProvider.addresses.first,
      );

      debugPrint('Selected address: ${selectedAddress.toJson()}');

      // Create order items from cart - use hardcoded IDs for now since cart has old data
      final orderItems = cartProvider.cartItems.map((cartItem) {
        debugPrint('Cart item structure: ${cartItem.product}');
        debugPrint('Cart item keys: ${cartItem.product.keys.toList()}');

        // Get the product ID directly from the cart item
        final productId = cartItem.product['id']?.toString() ?? '';
        debugPrint('Product ID from cart: $productId');

        final price =
            double.tryParse(
              cartItem.product['price']
                      ?.toString()
                      .replaceAll('Rs. ', '')
                      .replaceAll(',', '') ??
                  '0',
            ) ??
            0;

        return OrderItem(
          itemId: productId,
          quantity: cartItem.quantity,
          price: price,
          totalPrice: price * cartItem.quantity,
        );
      }).toList();

      // Create order object
      debugPrint('Creating order with userId: ${authProvider.currentUser?.id}');
      debugPrint('Order items: ${orderItems.length}');
      debugPrint('Selected address ID: ${selectedAddress.id}');

      // Use the same totals shown to the user during checkout.
      final shipping = deliveryFee;

      final order = Order(
        user: authProvider.currentUser?.id,
        items: orderItems,
        subtotal: subtotal,
        tax: tax,
        shipping: shipping,
        discount: 0,
        total: total,
        shippingAddress: {
          '_id': selectedAddress.id, // Convert to ObjectId format
          'name': selectedAddress.name,
          'streetAddress': selectedAddress.street,
          'city': selectedAddress.city,
          'phone': selectedAddress.phone, // Use phone instead of postalCode
          'isDefault': selectedAddress.isDefault,
        },
        billingAddress: {
          '_id': selectedAddress.id, // Convert to ObjectId format
          'name': selectedAddress.name,
          'streetAddress': selectedAddress.street,
          'city': selectedAddress.city,
          'phone': selectedAddress.phone, // Use phone instead of postalCode
          'isDefault': selectedAddress.isDefault,
        },
        customerNotes: 'Order placed from mobile app',
        isGift: false,
        paymentMethodId: 'default', // Add required paymentMethod field
      );

      debugPrint('Order data: ${order.toJson()}');

      // Create order in database
      debugPrint('Sending order to backend...');
      final createdOrder = await _orderService.createOrder(order);
      debugPrint('Order creation response: $createdOrder');

      if (mounted) {
        setState(() {
          _isProcessing = false;
        });

        // Clear cart
        cartProvider.clearCart();

        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('Order Placed Successfully!'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'Your order has been placed successfully.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Order ID: ${createdOrder.orderNumber ?? createdOrder.id?.substring(0, 8) ?? 'N/A'}',
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
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/orders',
                      (route) => false,
                    ); // Go to orders screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text(
                    'View Orders',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });

        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Order Failed'),
              content: Text('Failed to place order: $e'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    }
  }
}
