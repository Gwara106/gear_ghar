import 'api_service.dart';
import '../models/payment_method_model.dart';

class PaymentMethodApiService {
  static final PaymentMethodApiService _instance = PaymentMethodApiService._internal();
  factory PaymentMethodApiService() => _instance;
  PaymentMethodApiService._internal();

  final ApiService _apiService = ApiService();

  Future<List<PaymentMethod>> getPaymentMethods() async {
    try {
      final response = await _apiService.get('/api/payment-methods');
      
      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> paymentMethodsJson = response['data'];
        return paymentMethodsJson.map((json) => PaymentMethod.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load payment methods: $e');
    }
  }

  Future<PaymentMethod?> getPaymentMethod(String id) async {
    try {
      final response = await _apiService.get('/api/payment-methods/$id');
      
      if (response['success'] == true && response['data'] != null) {
        return PaymentMethod.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to load payment method: $e');
    }
  }

  Future<PaymentMethod> createPaymentMethod(PaymentMethod paymentMethod) async {
    try {
      final response = await _apiService.post('/api/payment-methods', paymentMethod.toJson());
      
      if (response['success'] == true && response['data'] != null) {
        return PaymentMethod.fromJson(response['data']);
      }
      throw Exception('Failed to create payment method');
    } catch (e) {
      throw Exception('Failed to create payment method: $e');
    }
  }

  Future<PaymentMethod> updatePaymentMethod(String id, PaymentMethod paymentMethod) async {
    try {
      final response = await _apiService.put('/api/payment-methods/$id', paymentMethod.toJson());
      
      if (response['success'] == true && response['data'] != null) {
        return PaymentMethod.fromJson(response['data']);
      }
      throw Exception('Failed to update payment method');
    } catch (e) {
      throw Exception('Failed to update payment method: $e');
    }
  }

  Future<void> deletePaymentMethod(String id) async {
    try {
      await _apiService.delete('/api/payment-methods/$id');
    } catch (e) {
      throw Exception('Failed to delete payment method: $e');
    }
  }

  Future<PaymentMethod> setDefaultPaymentMethod(String id) async {
    try {
      final response = await _apiService.put('/api/payment-methods/$id/default', {});
      
      if (response['success'] == true && response['data'] != null) {
        return PaymentMethod.fromJson(response['data']);
      }
      throw Exception('Failed to set default payment method');
    } catch (e) {
      throw Exception('Failed to set default payment method: $e');
    }
  }

  Future<PaymentMethod?> getDefaultPaymentMethod() async {
    try {
      final response = await _apiService.get('/api/payment-methods/default');
      
      if (response['success'] == true && response['data'] != null) {
        return PaymentMethod.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      // Return null if no default payment method found
      return null;
    }
  }

  Future<bool> validatePaymentMethod({
    required String type,
    String? cardNumber,
    String? expiryMonth,
    String? expiryYear,
    String? cvv,
    String? cardholderName,
  }) async {
    try {
      final response = await _apiService.post('/api/payment-methods/validate', {
        'type': type,
        'cardNumber': cardNumber,
        'expiryMonth': expiryMonth,
        'expiryYear': expiryYear,
        'cvv': cvv,
        'cardholderName': cardholderName,
      });
      
      return response['success'] == true;
    } catch (e) {
      throw Exception('Failed to validate payment method: $e');
    }
  }
}
