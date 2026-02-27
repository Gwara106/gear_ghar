import 'package:flutter/material.dart';
import 'package:gear_ghar/shared/widgets/primary_app_bar.dart';
import '../../../../core/models/order_model.dart';
import '../../../../core/services/order_api_service.dart';
import 'order_details_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrderApiService _orderService = OrderApiService();
  List<Order> _orders = [];
  bool _isLoading = true;
  String? _error;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  final int _pageSize = 10;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadOrders();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreOrders();
    }
  }

  Future<void> _loadOrders({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
    }

    try {
      setState(() {
        if (refresh) {
          _isLoading = true;
        } else {
          _isLoadingMore = true;
        }
        _error = null;
      });

      final orders = await _orderService.getOrders(
        page: _currentPage,
        limit: _pageSize,
      );

      setState(() {
        if (refresh) {
          _orders = orders;
        } else {
          _orders.addAll(orders);
        }
        _isLoading = false;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _loadMoreOrders() async {
    if (_isLoadingMore || _error != null) return;

    _currentPage++;
    await _loadOrders();
  }

  Future<void> _refreshOrders() async {
    await _loadOrders(refresh: true);
  }

  String _getStatusText(String? status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'processing':
        return 'Processing';
      case 'packed':
        return 'Packed';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      case 'received':
        return 'Received';
      case 'cancelled':
        return 'Cancelled';
      case 'refunded':
        return 'Refunded';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'packed':
        return Colors.indigo;
      case 'shipped':
        return Colors.teal;
      case 'delivered':
        return Colors.green;
      case 'received':
        return Colors.lightGreen;
      case 'cancelled':
        return Colors.red;
      case 'refunded':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(title: 'My Orders'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading orders',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(_error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshOrders,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : _orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No orders yet',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text('Start shopping to see your orders here'),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/main');
                    },
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: const Text('Start Shopping'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _refreshOrders,
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                itemCount: _orders.length + (_isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _orders.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final order = _orders[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_bag,
                              color: Colors.black54,
                              size: 24,
                            ),
                            if (order.itemCount > 0) ...[
                              const SizedBox(height: 2),
                              Text(
                                '${order.itemCount}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Order #${order.id?.substring(0, 8)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(order.status),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _getStatusText(order.status),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          if (order.createdAt != null)
                            Text(
                              'Ordered on ${_formatDate(order.createdAt!)}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          if (order.actualDelivery != null)
                            Text(
                              'Delivered on ${_formatDate(order.actualDelivery!)}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            )
                          else if (order.estimatedDelivery != null)
                            Text(
                              'Est. delivery ${_formatDate(order.estimatedDelivery!)}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            order.formattedTotal,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Trash: cancel if active, delete if already cancelled
                          if (order.status == 'pending' ||
                              order.status == 'confirmed' ||
                              order.status == 'cancelled')
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () =>
                                  _showDeleteOrCancelConfirmation(order),
                              tooltip: order.status == 'cancelled'
                                  ? 'Delete Order'
                                  : 'Cancel Order',
                              iconSize: 20,
                            ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OrderDetailsScreen(order: order),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showDeleteOrCancelConfirmation(Order order) {
    final isCancelled = order.status == 'cancelled';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isCancelled ? 'Delete Order' : 'Cancel Order'),
        content: Text(
          isCancelled
              ? 'This will permanently delete order ${order.orderNumber ?? order.id?.substring(0, 8)}. This action cannot be undone.'
              : 'Are you sure you want to cancel order ${order.orderNumber ?? order.id?.substring(0, 8)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (isCancelled) {
                _deleteOrder(order);
              } else {
                _cancelOrder(order);
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(isCancelled ? 'Yes, Delete' : 'Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelOrder(Order order) async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Call the cancel order API
      final cancelledOrder = await _orderService.cancelOrder(
        order.id!,
        reason: 'Cancelled by customer',
      );

      // Update the order in the local list
      setState(() {
        final index = _orders.indexWhere((o) => o.id == order.id);
        if (index != -1) {
          _orders[index] = cancelledOrder;
        }
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order cancelled successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error cancelling order: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteOrder(Order order) async {
    try {
      setState(() {
        _isLoading = true;
      });

      await _orderService.deleteOrder(order.id!);

      setState(() {
        _orders.removeWhere((o) => o.id == order.id);
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting order: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
