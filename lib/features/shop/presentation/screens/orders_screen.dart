import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: 5, // Replace with actual order count
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.shopping_bag, color: Colors.black54),
              ),
              title: const Text('Order #12345'),
              subtitle: const Text('Delivered on Dec 10, 2023'),
              trailing: const Text('\$99.99', 
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                // Navigate to order details
              },
            ),
          );
        },
      ),
    );
  }
}
