import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;
  static const String _tokenKey = 'auth_token';

  // Initialize and load token from storage
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
  }

  // Set authentication token and persist it
  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    if (token.isEmpty) {
      await prefs.remove(_tokenKey);
    } else {
      await prefs.setString(_tokenKey, token);
    }
  }

  // Get current token
  String? getToken() => _token;

  // Get headers with authentication
  Map<String, String> _getHeaders() {
    final headers = Map<String, String>.from(ApiConstants.headers);
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  // Handle HTTP response
  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    if (statusCode >= 200 && statusCode < 300) {
      if (body.isEmpty) return {'success': true};
      try {
        return jsonDecode(body);
      } catch (e) {
        return {'success': true, 'data': body};
      }
    } else {
      try {
        final errorData = jsonDecode(body);
        throw Exception(errorData['message'] ?? 'Request failed');
      } catch (e) {
        throw Exception('Request failed with status $statusCode');
      }
    }
  }

  // POST request
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.getBaseUrl()}$endpoint'),
        headers: _getHeaders(),
        body: jsonEncode(data),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout - please check your connection');
        },
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // GET request
  Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.getBaseUrl()}$endpoint'),
        headers: _getHeaders(),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout - please check your connection');
        },
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // PUT request
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: _getHeaders(),
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // DELETE request
  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: _getHeaders(),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
