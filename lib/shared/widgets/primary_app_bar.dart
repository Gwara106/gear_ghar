import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gear_ghar/providers/cart_provider.dart';

class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final bool showMenu;
  final List<Widget>? actions;

  const PrimaryAppBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.showMenu = false,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark
        ? theme.appBarTheme.backgroundColor ?? Colors.black
        : theme.appBarTheme.backgroundColor ?? Colors.white;

    // Always use high-contrast icon/text color for visibility
    final iconColor = isDark ? Colors.white : Colors.black;

    return AppBar(
      backgroundColor: bgColor,
      elevation: 0,
      leading: showBack
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: iconColor),
              onPressed: () => Navigator.maybePop(context),
            )
          : (showMenu
                ? IconButton(
                    icon: Icon(Icons.menu, color: iconColor),
                    onPressed: () => Scaffold.maybeOf(context)?.openDrawer(),
                  )
                : null),
      title: Text(
        title,
        style:
            theme.textTheme.titleMedium?.copyWith(
              color: iconColor,
              fontWeight: FontWeight.w600,
            ) ??
            TextStyle(
              color: iconColor,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
      ),
      actions: [
        if (actions != null) ...actions!,
        Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            return Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart, color: iconColor),
                  onPressed: () => Navigator.pushNamed(context, '/cart'),
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
    );
  }
}
