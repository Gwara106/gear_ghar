import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 0,
        title: const Text('Shopping Cart'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: Theme.of(context).brightness == Brightness.dark 
                        ? Colors.grey.shade600 
                        : Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? Colors.grey.shade300 
                          : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add some products to get started!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? Colors.grey.shade500 
                          : Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Continue Shopping',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Cart Items
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: cartProvider.cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartProvider.cartItems[index];
                    return _buildCartItem(context, cartItem, cartProvider);
                  },
                ),
              ),

              // Order Summary
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildSummaryRow('Subtotal', cartProvider.totalPrice),
                    _buildSummaryRow('Delivery Fee', 50.0),
                    _buildSummaryRow('Tax', cartProvider.totalPrice * 0.13),
                    const Divider(),
                    _buildSummaryRow(
                      'Total',
                      cartProvider.totalPrice + 50.0 + (cartProvider.totalPrice * 0.13),
                      isBold: true,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/checkout');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Proceed to Checkout',
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
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, cartItem, CartProvider cartProvider) {
    final product = cartItem.product;
    final priceString = product['price'].toString().replaceAll('Rs. ', '').replaceAll(',', '');
    final price = double.tryParse(priceString) ?? 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                product['imageUrl'],
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product['category'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product['price'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Quantity Controls
            Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        cartProvider.updateQuantity(product, cartItem.quantity - 1);
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.remove, size: 16),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 30,
                      alignment: Alignment.center,
                      child: Text(
                        '${cartItem.quantity}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        cartProvider.updateQuantity(product, cartItem.quantity + 1);
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.add, size: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Remove Item'),
                        content: const Text('Are you sure you want to remove this item from cart?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              cartProvider.removeFromCart(product);
                              Navigator.pop(context);
                            },
                            child: const Text('Remove', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                ),
              ],
            ),
          ],
        ),
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
}
