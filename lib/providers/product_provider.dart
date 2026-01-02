import 'package:flutter/foundation.dart';

class ProductProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Akrapovic Exhaust/ S...',
      'category': 'Exhaust',
      'price': 'Rs. 5000',
      'imageUrl': 'assets/Product_Image/exhaust1.png',
      'rating': 5.0,
      'isFavorite': false,
    },
    {
      'name': '450 Handle Bar Risers',
      'category': 'Handle Bar',
      'price': 'Rs. 4,345',
      'imageUrl': 'assets/Product_Image/450handlebar.png',
      'rating': 4.5,
      'isFavorite': false,
    },
    {
      'name': 'Left clutch',
      'category': 'Parts',
      'price': 'Rs. 800',
      'imageUrl': 'assets/Product_Image/leftclutch.png',
      'rating': 4.5,
      'isFavorite': false,
    },
    {
      'name': 'Harley Davidson Tyres',
      'category': 'Tyres',
      'price': 'Rs. 4,000',
      'imageUrl': 'assets/Product_Image/harleyDavidsontyres.jpg',
      'rating': 4.5,
      'isFavorite': false,
    },
    {
      'name': 'Cafe Racer Helmet',
      'category': 'Helmet',
      'price': 'Rs. 6,500',
      'imageUrl': 'assets/Product_Image/caferacer helmet.png',
      'rating': 4.5,
      'isFavorite': false,
    },
    {
      'name': 'Leather Riding Gloves',
      'category': 'Accessories',
      'price': 'Rs. 1,500',
      'imageUrl': 'assets/Product_Image/gloves.jpg',
      'rating': 4.9,
      'isFavorite': false,
    },
    {
      'name': 'Leather Jacket',
      'category': 'Accessories',
      'price': 'Rs. 9,000',
      'imageUrl': 'assets/Product_Image/jacket.jpg',
      'rating': 4.5,
      'isFavorite': false,
    },
    {
      'name': 'Retro Barend Mirrors',
      'category': 'Parts',
      'price': 'Rs. 2,000',
      'imageUrl': 'assets/Product_Image/barendmirror.png',
      'rating': 4.8,
      'isFavorite': false,
    },
    {
      'name': 'Scrambler, bobber, cafe racer exhaust',
      'category': 'Exhaust',
      'price': 'Rs. 15,000',
      'imageUrl': 'assets/Product_Image/exhaustcafe.jpg',
      'rating': 4.5,
      'isFavorite': false,
    },
  ];

  List<Map<String, dynamic>> get products => _products;

  List<Map<String, dynamic>> get favoriteProducts =>
      _products.where((product) => product['isFavorite'] == true).toList();

  // Get products filtered by category
  List<Map<String, dynamic>> getProductsByCategory(String category) {
    if (category == 'All Items') {
      return List.from(_products);
    }
    return _products
        .where((product) => product['category'] == category)
        .toList();
  }

  // Get all unique categories
  List<String> get categories {
    final categories = _products
        .map((product) => product['category'] as String)
        .toSet()
        .toList();
    categories.insert(0, 'All Items');
    return categories;
  }

  void toggleFavorite(int index) {
    _products[index]['isFavorite'] = !_products[index]['isFavorite'];
    notifyListeners();
  }
}
