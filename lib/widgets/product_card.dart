import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String category;
  final String price;
  final String imageUrl;
  final double rating;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    this.rating = 0.0,
    this.isFavorite = false,
    required this.onFavoritePressed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isTablet = width > 600;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section - takes 70% of the card
              Flexible(
                flex: 7,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.grey[200],
                        child: Image.asset(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: onFavoritePressed,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.black54,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Text section - takes remaining 30% of the card
              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: isTablet ? 13 : 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: isTablet ? 15 : 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            price,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isTablet ? 16 : 15,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 3),
                              Text(
                                rating.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: isTablet ? 14 : 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
