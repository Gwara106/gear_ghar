import '../../../../core/models/address_model.dart';
import '../../../../core/models/payment_method_model.dart';

class UserDataValidationResult {
  final bool isValid;
  final bool needsAddress;
  final bool needsPaymentMethod;
  final List<String> missingData;

  UserDataValidationResult({
    required this.isValid,
    required this.needsAddress,
    required this.needsPaymentMethod,
    required this.missingData,
  });
}

class UserDataValidator {
  static UserDataValidationResult validateCheckoutData({
    required List<Address> addresses,
    required List<PaymentMethod> paymentMethods,
    required Address? selectedAddress,
    required PaymentMethod? selectedPaymentMethod,
  }) {
    final missingData = <String>[];
    bool needsAddress = false;
    bool needsPaymentMethod = false;

    // Check if user has any addresses
    if (addresses.isEmpty) {
      missingData.add('You need to add a shipping address');
      needsAddress = true;
    }

    // Check if user has any payment methods
    if (paymentMethods.isEmpty) {
      missingData.add('You need to add a payment method');
      needsPaymentMethod = true;
    }

    // Check if user has selected an address (when addresses exist)
    if (addresses.isNotEmpty && selectedAddress == null) {
      missingData.add('Please select a shipping address');
    }

    // Check if user has selected a payment method (when payment methods exist)
    if (paymentMethods.isNotEmpty && selectedPaymentMethod == null) {
      missingData.add('Please select a payment method');
    }

    // Check if selected payment method is expired (for cards)
    if (selectedPaymentMethod != null && 
        selectedPaymentMethod.type == 'card' && 
        selectedPaymentMethod.isExpired) {
      missingData.add('Your selected payment method has expired. Please add a new payment method or update the existing one.');
      needsPaymentMethod = true;
    }

    final isValid = missingData.isEmpty;

    return UserDataValidationResult(
      isValid: isValid,
      needsAddress: needsAddress,
      needsPaymentMethod: needsPaymentMethod,
      missingData: missingData,
    );
  }

  static UserDataValidationResult validateUserProfile({
    required List<Address> addresses,
    required List<PaymentMethod> paymentMethods,
  }) {
    final missingData = <String>[];
    bool needsAddress = false;
    bool needsPaymentMethod = false;

    // Check if user has at least one address
    if (addresses.isEmpty) {
      missingData.add('Add a shipping address for faster checkout');
      needsAddress = true;
    }

    // Check if user has at least one payment method
    if (paymentMethods.isEmpty) {
      missingData.add('Add a payment method for faster checkout');
      needsPaymentMethod = true;
    }

    // Check for expired payment methods
    final expiredCards = paymentMethods.where((pm) => 
        pm.type == 'card' && pm.isExpired).toList();
    
    if (expiredCards.isNotEmpty) {
      missingData.add('Update expired payment methods');
    }

    final isValid = missingData.isEmpty;

    return UserDataValidationResult(
      isValid: isValid,
      needsAddress: needsAddress,
      needsPaymentMethod: needsPaymentMethod,
      missingData: missingData,
    );
  }

  static List<String> getProfileCompletionTips({
    required List<Address> addresses,
    required List<PaymentMethod> paymentMethods,
  }) {
    final tips = <String>[];

    if (addresses.isEmpty) {
      tips.add('💡 Add a shipping address to enable checkout');
    } else if (addresses.length == 1) {
      tips.add('💡 Add multiple addresses for more flexibility');
    }

    if (paymentMethods.isEmpty) {
      tips.add('💡 Add a payment method to enable checkout');
    } else if (paymentMethods.length == 1) {
      tips.add('💡 Add backup payment methods for convenience');
    }

    final expiredCards = paymentMethods.where((pm) => 
        pm.type == 'card' && pm.isExpired).toList();
    
    if (expiredCards.isNotEmpty) {
      tips.add('⚠️ You have ${expiredCards.length} expired payment method(s)');
    }

    final hasDefaultAddress = addresses.any((addr) => addr.isDefault == true);
    if (!hasDefaultAddress && addresses.isNotEmpty) {
      tips.add('💡 Set a default address for faster checkout');
    }

    final hasDefaultPaymentMethod = paymentMethods.any((pm) => pm.isDefault == true);
    if (!hasDefaultPaymentMethod && paymentMethods.isNotEmpty) {
      tips.add('💡 Set a default payment method for faster checkout');
    }

    return tips;
  }
}
