import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/models/address_model.dart';
import '../../../../core/models/payment_method_model.dart';
import '../../../../core/models/order_model.dart';
import '../../../../core/services/address_api_service.dart';
import '../../../../core/services/payment_method_api_service.dart';
import '../../../../core/services/order_api_service.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../widgets/checkout_summary.dart';
import '../widgets/user_data_validator.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double subtotal;
  final double tax;
  final double shipping;
  final double total;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.subtotal,
    required this.tax,
    required this.shipping,
    required this.total,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final AddressApiService _addressService = AddressApiService();
  final PaymentMethodApiService _paymentService = PaymentMethodApiService();
  final OrderApiService _orderService = OrderApiService();

  List<Address> _addresses = [];
  List<PaymentMethod> _paymentMethods = [];
  Address? _selectedAddress;
  PaymentMethod? _selectedPaymentMethod;
  
  bool _isLoading = true;
  bool _isProcessingOrder = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final addresses = await _addressService.getAddresses();
      final paymentMethods = await _paymentService.getPaymentMethods();

      // Select default options if available
      final defaultAddress = addresses.firstWhere(
        (addr) => addr.isDefault == true,
        orElse: () => addresses.isNotEmpty ? addresses.first : Address(),
      );
      
      final defaultPaymentMethod = paymentMethods.firstWhere(
        (pm) => pm.isDefault == true,
        orElse: () => paymentMethods.isNotEmpty ? paymentMethods.first : PaymentMethod(),
      );

      setState(() {
        _addresses = addresses;
        _paymentMethods = paymentMethods;
        _selectedAddress = defaultAddress.id != null ? defaultAddress : null;
        _selectedPaymentMethod = defaultPaymentMethod.id != null ? defaultPaymentMethod : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _processOrder() async {
    // Validate required data
    final validation = UserDataValidator.validateCheckoutData(
      addresses: _addresses,
      paymentMethods: _paymentMethods,
      selectedAddress: _selectedAddress,
      selectedPaymentMethod: _selectedPaymentMethod,
    );

    if (!validation.isValid) {
      _showValidationDialog(validation);
      return;
    }

    setState(() {
      _isProcessingOrder = true;
    });

    try {
      final order = Order(
        items: widget.cartItems.map((item) => OrderItem(
          itemId: item['id']?.toString(),
          quantity: item['quantity'] as int,
          price: (item['price'] as num).toDouble(),
          totalPrice: (item['price'] as num).toDouble() * (item['quantity'] as int),
          itemName: item['name']?.toString(),
          itemImages: (item['images'] as List<dynamic>?)?.cast<String>(),
        )).toList(),
        subtotal: widget.subtotal,
        tax: widget.tax,
        shipping: widget.shipping,
        total: widget.total,
        shippingAddressId: _selectedAddress!.id,
        billingAddressId: _selectedAddress!.id, // Using same address for billing
        paymentMethodId: _selectedPaymentMethod!.id,
        customerNotes: '', // Can be added as a form field
      );

      final createdOrder = await _orderService.createOrder(order);

      if (mounted) {
        // Navigate to order success screen
        Navigator.pushReplacementNamed(
          context,
          '/order-success',
          arguments: createdOrder,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to process order: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingOrder = false;
        });
      }
    }
  }

  void _showValidationDialog(UserDataValidationResult validation) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Complete Your Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'To complete your purchase, please add the following information:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ...validation.missingData.map((issue) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(issue)),
                  ],
                ),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToAddMissingData(validation);
            },
            child: const Text('Add Information'),
          ),
        ],
      ),
    );
  }

  void _navigateToAddMissingData(UserDataValidationResult validation) {
    if (validation.needsAddress) {
      Navigator.pushNamed(context, '/add-address').then((_) {
        _loadUserData(); // Reload data after adding address
      });
    } else if (validation.needsPaymentMethod) {
      Navigator.pushNamed(context, '/add-payment-method').then((_) {
        _loadUserData(); // Reload data after adding payment method
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (!authProvider.isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: const Center(
          child: Text('Please login to continue with checkout'),
        ),
      );
    }

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error loading data: $_error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadUserData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shipping Address Section
                  _buildSectionHeader('Shipping Address'),
                  _buildAddressSelector(),
                  const SizedBox(height: 24),

                  // Payment Method Section
                  _buildSectionHeader('Payment Method'),
                  _buildPaymentMethodSelector(),
                  const SizedBox(height: 24),

                  // Order Summary
                  CheckoutSummary(
                    subtotal: widget.subtotal,
                    tax: widget.tax,
                    shipping: widget.shipping,
                    total: widget.total,
                    items: widget.cartItems,
                  ),
                ],
              ),
            ),
          ),

          // Place Order Button
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: (_selectedAddress == null || _selectedPaymentMethod == null || _isProcessingOrder)
                    ? null
                    : _processOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isProcessingOrder
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Processing...'),
                        ],
                      )
                    : const Text(
                        'Place Order',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAddressSelector() {
    if (_addresses.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
                  onPressed: () {
                    Navigator.pushNamed(context, '/add-address').then((_) {
                      _loadUserData();
                    });
                  },
                  child: const Text('Add Shipping Address'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Column(
        children: [
          ...List.generate(_addresses.length, (index) {
            final address = _addresses[index];
            final isSelected = _selectedAddress?.id == address.id;
            
            return ListTile(
              leading: Radio<Address>(
                value: address,
                groupValue: _selectedAddress,
                onChanged: (value) {
                  setState(() {
                    _selectedAddress = value;
                  });
                },
              ),
              title: Text(
                address.displayName,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                address.fullAddress,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: address.isDefault == true
                  ? Container(
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
                    )
                  : null,
              selected: isSelected,
              onTap: () {
                setState(() {
                  _selectedAddress = address;
                });
              },
            );
          }),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add New Address'),
            onTap: () {
              Navigator.pushNamed(context, '/add-address').then((_) {
                _loadUserData();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    if (_paymentMethods.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.payment_outlined, color: Colors.grey[600]),
                  const SizedBox(width: 12),
                  const Text('No payment methods'),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/add-payment-method').then((_) {
                      _loadUserData();
                    });
                  },
                  child: const Text('Add Payment Method'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Column(
        children: [
          ...List.generate(_paymentMethods.length, (index) {
            final paymentMethod = _paymentMethods[index];
            final isSelected = _selectedPaymentMethod?.id == paymentMethod.id;
            
            return ListTile(
              leading: Radio<PaymentMethod>(
                value: paymentMethod,
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value;
                  });
                },
              ),
              title: Text(
                paymentMethod.displayText,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: paymentMethod.isDefault == true
                  ? Container(
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
                    )
                  : null,
              selected: isSelected,
              onTap: () {
                setState(() {
                  _selectedPaymentMethod = paymentMethod;
                });
              },
            );
          }),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add New Payment Method'),
            onTap: () {
              Navigator.pushNamed(context, '/add-payment-method').then((_) {
                _loadUserData();
              });
            },
          ),
        ],
      ),
    );
  }
}
