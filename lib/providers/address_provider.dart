import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'address_provider.g.dart';

@HiveType(typeId: 0)
class Address extends HiveObject {
  @HiveField(0)
  final String? id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String street;
  
  @HiveField(3)
  final String city;
  
  @HiveField(4)
  final String phone;
  
  @HiveField(5)
  bool isDefault;

  Address({
    this.id,
    required this.name,
    required this.street,
    required this.city,
    required this.phone,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'street': street,
      'city': city,
      'phone': phone,
      'isDefault': isDefault,
    };
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id']?.toString(),
      name: json['name']?.toString() ?? '',
      street: json['street']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      isDefault: json['isDefault'] ?? false,
    );
  }

  String get displayName => name;
  String get fullAddress => '$street, $city';
}

class AddressProvider with ChangeNotifier {
  static const String _addressBoxName = 'addresses';
  Box<Address>? _addressBox;
  List<Address> _addresses = [];
  bool _isInitialized = false;

  AddressProvider() {
    // Initialize when provider is created
    _initializeAsync();
  }

  Future<void> _initializeAsync() async {
    try {
      await initialize();
    } catch (e) {
      debugPrint('Error during async initialization: $e');
    }
  }

  List<Address> get addresses => List.unmodifiable(_addresses);

  bool get isInitialized => _isInitialized;

  Address? get defaultAddress {
    try {
      return _addresses.firstWhere((address) => address.isDefault);
    } catch (e) {
      return _addresses.isNotEmpty ? _addresses.first : null;
    }
  }

  Future<void> _initBox() async {
    try {
      if (_isInitialized) return; // Already initialized
      
      if (!Hive.isBoxOpen(_addressBoxName)) {
        _addressBox = await Hive.openBox<Address>(_addressBoxName);
      } else {
        _addressBox = Hive.box<Address>(_addressBoxName);
      }
      
      _loadAddresses();
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing address box: $e');
      // Fallback to memory-only storage if Hive fails
      _addresses = [];
      _isInitialized = true;
    }
  }

  void _loadAddresses() {
    try {
      if (_addressBox != null) {
        _addresses = _addressBox!.values.toList();
        // If no addresses exist, add default ones
        if (_addresses.isEmpty) {
          _addDefaultAddresses();
        }
      } else {
        // Hive failed to initialize, add default addresses to memory
        _addDefaultAddressesToMemory();
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading addresses: $e');
      _addDefaultAddressesToMemory();
    }
  }

  void _addDefaultAddresses() {
    if (_addressBox == null) {
      _addDefaultAddressesToMemory();
      return;
    }
    
    final defaultAddresses = [
      Address(
        id: '1',
        name: 'Home',
        street: '123 Main Street',
        city: 'Kathmandu',
        phone: '9841234567',
        isDefault: true,
      ),
      Address(
        id: '2',
        name: 'Office',
        street: '456 Business Ave',
        city: 'Pokhara',
        phone: '9847654321',
        isDefault: false,
      ),
    ];
    
    for (final address in defaultAddresses) {
      _addressBox!.put(address.id, address);
    }
    _addresses = defaultAddresses;
  }

  void _addDefaultAddressesToMemory() {
    // Fallback for when Hive fails - add default addresses to memory only
    _addresses = [
      Address(
        id: '1',
        name: 'Home',
        street: '123 Main Street',
        city: 'Kathmandu',
        phone: '9841234567',
        isDefault: true,
      ),
      Address(
        id: '2',
        name: 'Office',
        street: '456 Business Ave',
        city: 'Pokhara',
        phone: '9847654321',
        isDefault: false,
      ),
    ];
  }

  Future<void> addAddress(Address address) async {
    try {
      // Ensure initialization
      if (!_isInitialized) {
        await _initBox();
      }

      final newAddress = Address(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: address.name,
        street: address.street,
        city: address.city,
        phone: address.phone,
        isDefault: _addresses.isEmpty ? true : address.isDefault,
      );

      if (newAddress.isDefault) {
        // Set all other addresses to non-default
        for (var addr in _addresses) {
          addr.isDefault = false;
          if (_addressBox != null) {
            await _addressBox!.put(addr.id, addr);
          }
        }
      }

      // Save to Hive if available, otherwise use memory-only storage
      if (_addressBox != null) {
        await _addressBox!.put(newAddress.id, newAddress);
      }
      
      _addresses.add(newAddress);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding address: $e');
      rethrow;
    }
  }

  Future<void> updateAddress(Address address) async {
    try {
      // Ensure initialization
      if (!_isInitialized) {
        await _initBox();
      }

      final index = _addresses.indexWhere((addr) => addr.id == address.id);
      if (index != -1) {
        if (address.isDefault) {
          // Set all other addresses to non-default
          for (var addr in _addresses) {
            addr.isDefault = false;
            if (_addressBox != null) {
              await _addressBox!.put(addr.id, addr);
            }
          }
        }
        _addresses[index] = address;
        if (_addressBox != null) {
          await _addressBox!.put(address.id, address);
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating address: $e');
      rethrow;
    }
  }

  Future<void> deleteAddress(String id) async {
    try {
      // Ensure initialization
      if (!_isInitialized) {
        await _initBox();
      }

      final addressToDelete = _addresses.firstWhere((addr) => addr.id == id);
      
      // Don't allow deletion if it's the only address
      if (_addresses.length <= 1) {
        return;
      }

      // Don't allow deletion of default address if there are other addresses
      if (addressToDelete.isDefault && _addresses.length > 1) {
        // Set another address as default before deleting
        final otherAddresses = _addresses.where((addr) => addr.id != id).toList();
        if (otherAddresses.isNotEmpty) {
          otherAddresses.first.isDefault = true;
          if (_addressBox != null) {
            await _addressBox!.put(otherAddresses.first.id, otherAddresses.first);
          }
        }
      }

      if (_addressBox != null) {
        await _addressBox!.delete(id);
      }
      _addresses.removeWhere((addr) => addr.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting address: $e');
      rethrow;
    }
  }

  Future<void> setDefaultAddress(String id) async {
    try {
      // Ensure initialization
      if (!_isInitialized) {
        await _initBox();
      }

      for (var address in _addresses) {
        address.isDefault = address.id == id;
        if (_addressBox != null) {
          await _addressBox!.put(address.id, address);
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting default address: $e');
      rethrow;
    }
  }

  Address? getAddressById(String id) {
    try {
      return _addresses.firstWhere((addr) => addr.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearAddresses() async {
    try {
      // Ensure initialization
      if (!_isInitialized) {
        await _initBox();
      }
      
      if (_addressBox != null) {
        await _addressBox!.clear();
      }
      _addresses.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing addresses: $e');
    }
  }

  // Initialize the provider
  Future<void> initialize() async {
    if (!_isInitialized) {
      await _initBox();
    }
  }
}
