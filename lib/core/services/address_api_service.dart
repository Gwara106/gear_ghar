import 'api_service.dart';
import '../models/address_model.dart';

class AddressApiService {
  static final AddressApiService _instance = AddressApiService._internal();
  factory AddressApiService() => _instance;
  AddressApiService._internal();

  final ApiService _apiService = ApiService();

  Future<List<Address>> getAddresses() async {
    try {
      final response = await _apiService.get('/api/addresses');
      
      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> addressesJson = response['data'];
        return addressesJson.map((json) => Address.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load addresses: $e');
    }
  }

  Future<Address?> getAddress(String id) async {
    try {
      final response = await _apiService.get('/api/addresses/$id');
      
      if (response['success'] == true && response['data'] != null) {
        return Address.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to load address: $e');
    }
  }

  Future<Address> createAddress(Address address) async {
    try {
      final response = await _apiService.post('/api/addresses', address.toJson());
      
      if (response['success'] == true && response['data'] != null) {
        return Address.fromJson(response['data']);
      }
      throw Exception('Failed to create address');
    } catch (e) {
      throw Exception('Failed to create address: $e');
    }
  }

  Future<Address> updateAddress(String id, Address address) async {
    try {
      final response = await _apiService.put('/api/addresses/$id', address.toJson());
      
      if (response['success'] == true && response['data'] != null) {
        return Address.fromJson(response['data']);
      }
      throw Exception('Failed to update address');
    } catch (e) {
      throw Exception('Failed to update address: $e');
    }
  }

  Future<void> deleteAddress(String id) async {
    try {
      await _apiService.delete('/api/addresses/$id');
    } catch (e) {
      throw Exception('Failed to delete address: $e');
    }
  }

  Future<Address> setDefaultAddress(String id) async {
    try {
      final response = await _apiService.put('/api/addresses/$id/default', {});
      
      if (response['success'] == true && response['data'] != null) {
        return Address.fromJson(response['data']);
      }
      throw Exception('Failed to set default address');
    } catch (e) {
      throw Exception('Failed to set default address: $e');
    }
  }

  Future<Address?> getDefaultAddress() async {
    try {
      final response = await _apiService.get('/api/addresses/default');
      
      if (response['success'] == true && response['data'] != null) {
        return Address.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      // Return null if no default address found
      return null;
    }
  }
}
