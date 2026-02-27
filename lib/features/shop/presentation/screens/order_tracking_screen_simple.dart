import 'package:flutter/material.dart';
import '../../../../core/models/order_model.dart';
import '../../../../core/services/order_api_service.dart';

class OrderTrackingScreenSimple extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreenSimple({
    super.key,
    required this.orderId,
  });

  @override
  State<OrderTrackingScreenSimple> createState() => _OrderTrackingScreenSimpleState();
}

class _OrderTrackingScreenSimpleState extends State<OrderTrackingScreenSimple> {
  Order? _order;
  bool _isLoading = true;
  String? _error;
  final OrderApiService _orderService = OrderApiService();

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final order = await _orderService.getOrder(widget.orderId);
      setState(() {
        _order = order;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load order: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Tracking - ${_order?.orderNumber ?? widget.orderId}'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading order',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(_error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadOrder,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _order == null
                  ? const Center(
                      child: Text('Order not found'),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Current Status Card
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order Status',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(_order?.status).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: _getStatusColor(_order?.status)),
                                  ),
                                  child: Text(
                                    _order?.status?.toUpperCase() ?? 'PENDING',
                                    style: TextStyle(
                                      color: _getStatusColor(_order?.status),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Order Items
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order Items',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 16),
                                ...(_order?.items ?? []).map((item) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Item ${(_order?.items?.indexOf(item) ?? 0) + 1}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Quantity: ${item.quantity ?? 0}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Price: \$${(item.price ?? 0).toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Total: \$${(item.totalPrice ?? 0).toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'shipped':
        return Colors.blue;
      case 'processing':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
