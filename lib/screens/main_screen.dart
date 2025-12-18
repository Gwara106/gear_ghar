import 'package:flutter/material.dart';
import 'package:gear_ghar/common/bottom_nav_bar.dart';
import 'package:gear_ghar/screens/favorite_screen.dart';
import 'package:gear_ghar/screens/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const FavoriteScreen(),
    const Scaffold(body: Center(child: Text('Profile Screen'))), // Placeholder for Profile
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.black,
              child: const Icon(Icons.shopping_cart, color: Colors.white),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
