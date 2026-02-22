import 'package:flutter/material.dart';
import '../../../../providers/product_provider.dart';
import '../../../../providers/cart_provider.dart';
import '../widgets/category_sidebar.dart';
import '../widgets/product_card.dart';
import 'package:provider/provider.dart';
import '../../../shop/presentation/screens/product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  int _selectedCategoryIndex = 0;
  String _searchQuery = '';
  int _currentPage = 0;
  final int _productsPerPage = 8;
  final ScrollController _scrollController = ScrollController();

  void _toggleSidebar() {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      Navigator.of(context).pop();
    } else {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _currentPage = 0;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _changePage(int newPage) {
    setState(() {
      _currentPage = newPage;
    });
    // Scroll to top when page changes
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final categories = productProvider.categories;
    
    // First filter by category
    List<Map<String, dynamic>> filteredProducts = _selectedCategoryIndex == 0
        ? List.from(productProvider.products)
        : productProvider.getProductsByCategory(categories[_selectedCategoryIndex]);
    
    // Then filter by search query if it exists
    if (_searchQuery.isNotEmpty) {
      filteredProducts = filteredProducts.where((product) {
        final name = product['name'].toString().toLowerCase();
        final category = product['category'].toString().toLowerCase();
        return name.contains(_searchQuery) || category.contains(_searchQuery);
      }).toList();
    }
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
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search for items...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
          ),
        ),
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
        controller: _scrollController,
        child: Container(
        color: const Color(0xFFD0D0D0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Chips
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
              if (filteredProducts.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'No products found in this category',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              else
                Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: filteredProducts.length > _productsPerPage
                          ? _productsPerPage
                          : filteredProducts.length,
                      itemBuilder: (context, index) {
                        final pageIndex = _currentPage * _productsPerPage + index;
                        if (pageIndex >= filteredProducts.length) return const SizedBox.shrink();
                        
                        final product = filteredProducts[pageIndex];
                        final productIndex = productProvider.products.indexOf(product);
                        return ProductCard(
                          name: product['name'],
                          category: product['category'],
                          price: product['price'],
                          imageUrl: product['imageUrl'],
                          rating: product['rating'],
                          isFavorite: product['isFavorite'],
                          product: product,
                          onFavoritePressed: () {
                            productProvider.toggleFavorite(productIndex);
                          },
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(product: product),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    if (filteredProducts.length > _productsPerPage)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios, size: 20),
                              onPressed: _currentPage > 0
                                  ? () => _changePage(_currentPage - 1)
                                  : null,
                            ),
                            Text(
                              'Page ${_currentPage + 1}/${(filteredProducts.length / _productsPerPage).ceil()}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward_ios, size: 20),
                              onPressed: _currentPage <
                                      (filteredProducts.length / _productsPerPage).ceil() - 1
                                  ? () => _changePage(_currentPage + 1)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
            ],
          ),
          ),
        ),
      ),


    );
  }
}
