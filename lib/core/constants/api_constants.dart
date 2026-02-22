class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:5000'; // Updated for Android emulator
  static const String fallbackUrl = 'http://localhost:5000'; // Fallback for physical devices
  
  // Get appropriate base URL based on platform/environment
  static String getBaseUrl() {
    // Try primary URL first, fallback if needed
    return baseUrl;
  }
  
  // Auth endpoints - Updated to match mobile backend
  static const String register = '/api/v1/users';
  static const String login = '/api/v1/users/login';
  static const String logout = '/api/v1/users/logout';
  static const String profile = '/api/v1/users/profile';
  
  // Product endpoints
  static const String products = '/api/products';
  static const String productById = '/api/products/';
  
  // Order endpoints
  static const String orders = '/api/orders';
  static const String orderById = '/api/orders/';
  
  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
