import 'package:flutter/material.dart';

class CategorySidebar extends StatelessWidget {
  final VoidCallback onClose;

  const CategorySidebar({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, List<String>> brandCategories = {
      'Royal Enfield': [
        'Helmet',
        'Gloves',
        'Accessories',
        'Jacket',
        'Handlebars',
        'Tyres',
      ],
      'Harley Davidson': [
        'Helmet',
        'Gloves',
        'Accessories',
        'Jacket',
        'Handlebars',
        'Tyres',
      ],
      'KTM': [
        'Helmet',
        'Gloves',
        'Accessories',
        'Jacket',
        'Handlebars',
        'Tyres',
      ],
      'Yamaha': [
        'Helmet',
        'Gloves',
        'Accessories',
        'Jacket',
        'Handlebars',
        'Tyres',
      ],
      'Honda': [
        'Helmet',
        'Gloves',
        'Accessories',
        'Jacket',
        'Handlebars',
        'Tyres',
      ],
      'Bajaj': [
        'Helmet',
        'Gloves',
        'Accessories',
        'Jacket',
        'Handlebars',
        'Tyres',
      ],
      'Kawasaki': [
        'Helmet',
        'Gloves',
        'Accessories',
        'Jacket',
        'Handlebars',
        'Tyres',
      ],
    };

    return Drawer(
      width: 280,
      child: Column(
        children: [
          AppBar(
            title: const Text('Categories'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClose,
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: brandCategories.length,
              itemBuilder: (context, index) {
                final brand = brandCategories.keys.elementAt(index);
                final categories = brandCategories[brand]!;
                return ExpansionTile(
                  title: Text(
                    brand,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  children: categories
                      .map(
                        (category) => ListTile(
                          title: Text(category),
                          onTap: () {
                            // Handle category selection
                            Navigator.pop(context);
                          },
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
