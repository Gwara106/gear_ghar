import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD0D0D0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Product Details'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, color: Colors.black),
                    onPressed: () {
                      Navigator.pushNamed(context, '/cart');
                    },
                  ),
                  if (cartProvider.itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cartProvider.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.white,
              child: Image.asset(product['imageUrl'], fit: BoxFit.contain),
            ),

            // Product Info
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Text(
                    product['category'],
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 8),

                  // Product Name
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Rating and Reviews
                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < product['rating'].floor()
                                ? Icons.star
                                : index < product['rating']
                                ? Icons.star_half
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 20,
                          );
                        }),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${product['rating']} (${(product['rating'] * 12).toInt()} reviews)',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price
                  Text(
                    product['price'],
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Stock Status
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'In Stock',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Description
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _getProductDescription(product),
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Product Details
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Product Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow('Category', product['category']),
                  _buildDetailRow('Brand', _getBrandName(product)),
                  _buildDetailRow('SKU', _generateSKU(product)),
                  _buildDetailRow('Weight', _getWeight(product)),
                  _buildDetailRow('Dimensions', _getDimensions(product)),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Reviews Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Customer Reviews',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(3, (index) => _buildReviewItem(index)),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Show all reviews
                      },
                      child: const Text('View All Reviews'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100), // Space for bottom buttons
          ],
        ),
      ),

      // Bottom Action Buttons
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            return Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      cartProvider.addToCart(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product['name']} added to cart!'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.black),
                    ),
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      cartProvider.addToCart(product);
                      Navigator.pushNamed(context, '/cart');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Buy Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(int index) {
    final reviews = [
      {
        'name': 'Rajesh Sharma',
        'rating': 5.0,
        'date': '2 weeks ago',
        'comment':
            'Excellent product! Exactly as described. Fast delivery and great quality.',
      },
      {
        'name': 'Priya Patel',
        'rating': 4.0,
        'date': '1 month ago',
        'comment':
            'Good quality product. Fits perfectly on my bike. Would recommend.',
      },
      {
        'name': 'Amit Kumar',
        'rating': 4.5,
        'date': '1 month ago',
        'comment': 'Very satisfied with the purchase. Good value for money.',
      },
    ];

    final review = reviews[index % reviews.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review['name'] as String,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                review['date'] as String,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: List.generate(5, (index) {
              final rating = review['rating'] as num;
              return Icon(
                index < rating.floor()
                    ? Icons.star
                    : index < rating
                    ? Icons.star_half
                    : Icons.star_border,
                color: Colors.amber,
                size: 16,
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            review['comment'] as String,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  String _getProductDescription(Map<String, dynamic> product) {
    final category = product['category'].toString().toLowerCase();

    switch (category) {
      case 'exhaust':
        return 'High-performance exhaust system designed to enhance your motorcycle\'s sound and power output. Made from premium stainless steel with precision welding for durability and optimal performance. Easy bolt-on installation with no modifications required.';
      case 'helmet':
        return 'Premium motorcycle helmet with advanced safety features. DOT certified, lightweight composite shell design, excellent ventilation system, and comfortable interior padding. Provides superior protection while maintaining style and comfort.';
      case 'accessories':
        return 'High-quality motorcycle accessory designed for both style and functionality. Made from premium materials to ensure durability and long-lasting performance. Perfect upgrade for your riding experience.';
      case 'parts':
        return 'Genuine motorcycle part manufactured to exact specifications. Ensures perfect fit and optimal performance. Made from high-quality materials for durability and reliability.';
      case 'tyres':
        return 'High-performance motorcycle tire designed for excellent grip and durability. Advanced tread pattern provides superior traction in various weather conditions. Built for both wet and dry road performance.';
      case 'handle bar':
        return 'Ergonomically designed handle bar for improved comfort and control. Made from high-grade aluminum for strength without adding excessive weight. Provides better riding posture and reduced fatigue.';
      default:
        return 'Premium quality motorcycle product designed for performance and durability. Manufactured to the highest standards using quality materials. Perfect upgrade for your motorcycle.';
    }
  }

  String _getBrandName(Map<String, dynamic> product) {
    final category = product['category'].toString().toLowerCase();

    switch (category) {
      case 'exhaust':
        return 'Akrapovic';
      case 'helmet':
        return 'Cafe Racer';
      case 'accessories':
        return 'Premium Gear';
      case 'parts':
        return 'OEM Parts';
      case 'tyres':
        return 'Harley Davidson';
      case 'handle bar':
        return 'Pro Handlebars';
      default:
        return 'Gear Ghar';
    }
  }

  String _generateSKU(Map<String, dynamic> product) {
    final category = product['category']
        .toString()
        .substring(0, 3)
        .toUpperCase();
    final random = (product['name'].toString().length % 1000)
        .toString()
        .padLeft(3, '0');
    return 'GG$category$random';
  }

  String _getWeight(Map<String, dynamic> product) {
    final category = product['category'].toString().toLowerCase();

    switch (category) {
      case 'exhaust':
        return '3.5 kg';
      case 'helmet':
        return '1.2 kg';
      case 'accessories':
        return '0.5 kg';
      case 'parts':
        return '0.8 kg';
      case 'tyres':
        return '8.5 kg';
      case 'handle bar':
        return '1.5 kg';
      default:
        return '1.0 kg';
    }
  }

  String _getDimensions(Map<String, dynamic> product) {
    final category = product['category'].toString().toLowerCase();

    switch (category) {
      case 'exhaust':
        return '60 x 30 x 20 cm';
      case 'helmet':
        return '30 x 25 x 25 cm';
      case 'accessories':
        return '20 x 15 x 10 cm';
      case 'parts':
        return '15 x 10 x 8 cm';
      case 'tyres':
        return '70 x 70 x 20 cm';
      case 'handle bar':
        return '80 x 20 x 10 cm';
      default:
        return '25 x 20 x 15 cm';
    }
  }
}
