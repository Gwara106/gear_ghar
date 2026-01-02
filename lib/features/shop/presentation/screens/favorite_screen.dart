import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/product_provider.dart';
import '../../../home/presentation/widgets/product_card.dart';
import 'package:collection/collection.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final favoriteProducts = productProvider.favoriteProducts;

    return Scaffold(
      backgroundColor: const Color(0xFFD0D0D0),
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: favoriteProducts.isEmpty
          ? const Center(
              child: Text('No favorite items yet!'),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.70,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) {
                final product = favoriteProducts[index];
                return ProductCard(
                  name: product['name'],
                  category: product['category'],
                  price: product['price'],
                  imageUrl: product['imageUrl'],
                  rating: product['rating'],
                  isFavorite: product['isFavorite'],
                  onFavoritePressed: () {
                    final globalIndex = productProvider.products.indexWhere(
                        (p) => const MapEquality().equals(p, product));
                    if (globalIndex != -1) {
                      productProvider.toggleFavorite(globalIndex);
                    }
                  },
                  onTap: () {},
                );
              },
            ),
    );
  }
}
