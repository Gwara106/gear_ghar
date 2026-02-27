import 'package:flutter/foundation.dart';

class ProductProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _products = [
    {
      'id': '696f1eb410881bfa9740e755',
      'name': 'Premium Safety Helmet - HD Vision',
      'category': 'Helmet',
      'price': 'Rs. 5000',
      'imageUrl': 'assets/Product_Image/exhaust1.png',
      'rating': 5.0,
      'isFavorite': false,
    },
    {
      'id': '696f1eb410881bfa9740e756',
      'name': 'Sport Performance Gloves',
      'category': 'Accessories',
      'price': 'Rs. 4,345',
      'imageUrl': 'assets/Product_Image/450handlebar.png',
      'rating': 4.5,
      'isFavorite': false,
    },
    {
      'id': '696f1eb410881bfa9740e757',
      'name': 'High-Grip Handlebar Grips Set',
      'category': 'Parts',
      'price': 'Rs. 800',
      'imageUrl': 'assets/Product_Image/leftclutch.png',
      'rating': 4.5,
      'isFavorite': false,
    },
    {
      'id': '696f1eb410881bfa9740e758',
      'name': 'Premium Racing Tyres (Front)',
      'category': 'Tyres',
      'price': 'Rs. 4,000',
      'imageUrl': 'assets/Product_Image/harleyDavidsontyres.jpg',
      'rating': 4.5,
      'isFavorite': false,
    },
    {
      'id': '696f1eb410881bfa9740e759',
      'name': 'Carbon Fiber Exhaust System',
      'category': 'Exhaust',
      'price': 'Rs. 6,500',
      'imageUrl': 'assets/Product_Image/caferacer helmet.png',
      'rating': 4.5,
      'isFavorite': false,
    },
    {
      'id': '696f1eb410881bfa9740e75a',
      'name': 'Professional Riding Suit',
      'category': 'Accessories',
      'price': 'Rs. 1,500',
      'imageUrl': 'assets/Product_Image/gloves.jpg',
      'rating': 4.9,
      'isFavorite': false,
    },
    {
      'id': '696f1eb410881bfa9740e75d',
      'name': 'Full-Face Safety Helmet Pro',
      'category': 'Accessories',
      'price': 'Rs. 9,000',
      'imageUrl': 'assets/Product_Image/jacket.jpg',
      'rating': 4.5,
      'isFavorite': false,
    },
    {
      'id': '696f1eb410881bfa9740e75c',
      'name': 'Leather Riding Gloves Premium',
      'category': 'Parts',
      'price': 'Rs. 2,000',
      'imageUrl': 'assets/Product_Image/barendmirror.png',
      'rating': 4.8,
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
