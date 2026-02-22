import 'api_service.dart';
import '../models/order_model.dart';

class OrderApiService {
  static final OrderApiService _instance = OrderApiService._internal();
  factory OrderApiService() => _instance;
  OrderApiService._internal();

  final ApiService _apiService = ApiService();

  Future<List<Order>> getOrders({int page = 1, int limit = 10}) async {
    try {
      final response = await _apiService.get('/api/orders?page=$page&limit=$limit');
      
      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> ordersJson = response['data'];
        return ordersJson.map((json) => Order.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }

  Future<Order?> getOrder(String id) async {
    try {
      final response = await _apiService.get('/api/orders/$id');
      
      if (response['success'] == true && response['data'] != null) {
        return Order.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to load order: $e');
    }
  }

  Future<Order> createOrder(Order order) async {
    try {
      final response = await _apiService.post('/api/orders', order.toJson());
      
      if (response['success'] == true && response['data'] != null) {
        return Order.fromJson(response['data']);
      }
      throw Exception('Failed to create order');
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Future<Order> updateOrderStatus(String id, String status, {String? note}) async {
    try {
      final response = await _apiService.put('/api/orders/$id/status', {
        'status': status,
        if (note != null) 'note': note,
      });
      
      if (response['success'] == true && response['data'] != null) {
        return Order.fromJson(response['data']);
      }
      throw Exception('Failed to update order status');
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  Future<Order> cancelOrder(String id, {String? reason}) async {
    try {
      final response = await _apiService.put('/api/orders/$id/cancel', {
        if (reason != null) 'reason': reason,
      });
      
      if (response['success'] == true && response['data'] != null) {
        return Order.fromJson(response['data']);
      }
      throw Exception('Failed to cancel order');
    } catch (e) {
      throw Exception('Failed to cancel order: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getOrderStats() async {
    try {
      final response = await _apiService.get('/api/orders/stats');
      
      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> statsJson = response['data'];
        return statsJson.map((json) => Map<String, dynamic>.from(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load order stats: $e');
    }
  }

  Future<Map<String, dynamic>?> trackOrder(String id) async {
    try {
      final response = await _apiService.get('/api/orders/$id/track');
      
      if (response['success'] == true && response['data'] != null) {
        return Map<String, dynamic>.from(response['data']);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to track order: $e');
    }
  }
}
