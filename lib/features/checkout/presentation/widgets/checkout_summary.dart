import 'package:flutter/material.dart';

class CheckoutSummary extends StatelessWidget {
  final double subtotal;
  final double tax;
  final double shipping;
  final double total;
  final List<Map<String, dynamic>> items;

  const CheckoutSummary({
    super.key,
    required this.subtotal,
    required this.tax,
    required this.shipping,
    required this.total,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Items Summary
            ...items.map((item) => _buildItemSummary(item)),
            const Divider(),
            const SizedBox(height: 8),
            
            // Price Breakdown
            _buildPriceRow('Subtotal', subtotal),
            _buildPriceRow('Tax', tax),
            _buildPriceRow('Shipping', shipping),
            const Divider(),
            _buildPriceRow('Total', total, isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildItemSummary(Map<String, dynamic> item) {
    final name = item['name']?.toString() ?? 'Unknown Item';
    final quantity = item['quantity'] as int? ?? 1;
    final price = (item['price'] as num?)?.toDouble() ?? 0.0;
    final totalPrice = price * quantity;
    final images = item['images'] as List<dynamic>? ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item Image
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(6),
            ),
            child: images.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      images.first.toString(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image, color: Colors.grey, size: 24);
                      },
                    ),
                  )
                : const Icon(Icons.image, color: Colors.grey, size: 24),
          ),
          const SizedBox(width: 12),
          
          // Item Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Qty: $quantity × \$${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Item Total
          Text(
            '\$${totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
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
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
              color: (label == 'Shipping' && amount == 0.0) 
                  ? Colors.green 
                  : (label == 'Discount' && amount < 0) 
                      ? Colors.green 
                      : null,
            ),
          ),
        ],
      ),
    );
  }
}
