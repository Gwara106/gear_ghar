import 'package:flutter/material.dart';
import '../../shared/widgets/bottom_nav_bar.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/shop/presentation/screens/favorite_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

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
    const ProfileScreen(),
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
              backgroundColor: Theme.of(context).brightness == Brightness.dark 
                  ? const Color(0xFF2A2A2A)
                  : Colors.black,
              child: Icon(
                Icons.shopping_cart, 
                color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.white 
                    : Colors.white,
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
