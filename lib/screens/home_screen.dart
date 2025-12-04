import 'package:flutter/material.dart';
import 'package:gear_ghar/widgets/category_sidebar.dart';
import 'package:gear_ghar/widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;
  int _selectedCategoryIndex = 0;

  final List<String> categories = [
    'All Items',
    'Helmets',
    'Gloves',
    'Jackets',
    'Accessories',
    'Tyres',
    'Handlebars',
    'Exhausts',
  ];

  // product data
  final List<Map<String, dynamic>> products = [
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
      'isFavorite': true,
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleSidebar() {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      Navigator.of(context).pop();
    } else {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD0D0D0),
      key: _scaffoldKey,

      drawer: CategorySidebar(onClose: _toggleSidebar),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: _toggleSidebar,
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(25),
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Search for items...',
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.motorcycle, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),

      body: Container(
        color: const Color(0xFFD0D0D0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Chips
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Text(categories[index]),
                        selected: _selectedCategoryIndex == index,
                        selectedColor: const Color.fromARGB(255, 255, 255, 255),
                        labelStyle: TextStyle(
                          color: _selectedCategoryIndex == index
                              ? Colors.black
                              : Colors.grey[700],
                          fontWeight: _selectedCategoryIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategoryIndex = selected ? index : 0;
                          });
                        },
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: _selectedCategoryIndex == index
                                ? const Color.fromARGB(255, 0, 0, 0)
                                : Colors.grey[300]!,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Products Grid
              GridView.builder(
                padding: const EdgeInsets.all(8.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.70,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final p = products[index];
                  return ProductCard(
                    name: p['name'],
                    category: p['category'],
                    price: p['price'],
                    imageUrl: p['imageUrl'],
                    rating: p['rating'],
                    isFavorite: p['isFavorite'],
                    onFavoritePressed: () {
                      setState(() {
                        products[index]['isFavorite'] =
                            !products[index]['isFavorite'];
                      });
                    },
                    onTap: () {},
                  );
                },
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: "Favourite",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "Profile",
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          onTap: _onItemTapped,
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.black,
        child: const Icon(Icons.shopping_cart, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

    );
  }
}
