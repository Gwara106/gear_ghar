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
  static const String _addressBoxPrefix = 'addresses_';
  Box<Address>? _addressBox;
  List<Address> _addresses = [];
  bool _isInitialized = false;
  String? _currentUserId;

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

  String? get currentUserId => _currentUserId;

  Address? get defaultAddress {
    try {
      return _addresses.firstWhere((address) => address.isDefault);
    } catch (e) {
      return _addresses.isNotEmpty ? _addresses.first : null;
    }
  }

  String _getBoxName() {
    final userId = _currentUserId ?? 'guest';
    final boxName = '$_addressBoxPrefix$userId';
    debugPrint('AddressProvider: Using box name: $boxName');
    return boxName;
  }

  Future<void> _initBox() async {
    try {
      if (_isInitialized) return; // Already initialized

      final boxName = _getBoxName();

      if (!Hive.isBoxOpen(boxName)) {
        _addressBox = await Hive.openBox<Address>(boxName);
      } else {
        _addressBox = Hive.box<Address>(boxName);
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
        // Create new instances from Hive to avoid shared references
        _addresses = _addressBox!.values
            .map(
              (addr) => Address(
                id: addr.id,
                name: addr.name,
                street: addr.street,
                city: addr.city,
                phone: addr.phone,
                isDefault: addr.isDefault,
              ),
            )
            .toList();

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

      // Create a completely new address instance to avoid shared references
      final newAddress = Address(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: address.name,
        street: address.street,
        city: address.city,
        phone: address.phone,
        isDefault: _addresses.isEmpty ? true : address.isDefault,
      );

      if (newAddress.isDefault) {
        // Set all other addresses to non-default by creating new instances
        final updatedAddresses = <Address>[];
        for (var addr in _addresses) {
          final updatedAddr = Address(
            id: addr.id,
            name: addr.name,
            street: addr.street,
            city: addr.city,
            phone: addr.phone,
            isDefault: false,
          );
          updatedAddresses.add(updatedAddr);

          if (_addressBox != null) {
            await _addressBox!.put(addr.id, updatedAddr);
          }
        }
        _addresses.clear();
        _addresses.addAll(updatedAddresses);
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
      debugPrint(
        'AddressProvider: Updating address ${address.id} for user $_currentUserId',
      );

      // Ensure initialization
      if (!_isInitialized) {
        await _initBox();
      }

      final index = _addresses.indexWhere((addr) => addr.id == address.id);
      if (index != -1) {
        // Create a new address instance to avoid shared references
        final updatedAddress = Address(
          id: address.id,
          name: address.name,
          street: address.street,
          city: address.city,
          phone: address.phone,
          isDefault: address.isDefault,
        );

        debugPrint(
          'AddressProvider: Created new address instance: ${updatedAddress.name} - Default: ${updatedAddress.isDefault}',
        );

        if (updatedAddress.isDefault) {
          // Set all other addresses to non-default by creating new instances
          final updatedAddresses = <Address>[];
          for (var addr in _addresses) {
            if (addr.id != address.id) {
              final updatedAddr = Address(
                id: addr.id,
                name: addr.name,
                street: addr.street,
                city: addr.city,
                phone: addr.phone,
                isDefault: false,
              );
              updatedAddresses.add(updatedAddr);

              if (_addressBox != null) {
                await _addressBox!.put(addr.id, updatedAddr);
                debugPrint(
                  'AddressProvider: Updated non-default address ${addr.id} in storage',
                );
              }
            }
          }

          // Rebuild addresses list with updated instances
          _addresses.clear();
          _addresses.addAll(updatedAddresses);
          _addresses.add(updatedAddress);

          debugPrint(
            'AddressProvider: Rebuilt address list with ${_addresses.length} addresses',
          );
        } else {
          // Just replace the address at index
          _addresses[index] = updatedAddress;
          debugPrint('AddressProvider: Replaced address at index $index');
        }

        if (_addressBox != null) {
          await _addressBox!.put(updatedAddress.id, updatedAddress);
          debugPrint(
            'AddressProvider: Saved updated address ${updatedAddress.id} to storage',
          );
        }

        notifyListeners();

        debugPrint(
          'AddressProvider: Update complete. Current addresses for $_currentUserId:',
        );
        for (var addr in _addresses) {
          debugPrint(
            'AddressProvider: - ${addr.name} (${addr.id}) - Default: ${addr.isDefault}',
          );
        }
      } else {
        debugPrint(
          'AddressProvider: Address ${address.id} not found for update',
        );
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

      // Don't allow deletion if it's only address
      if (_addresses.length <= 1) {
        return;
      }

      // Don't allow deletion of default address if there are other addresses
      if (addressToDelete.isDefault && _addresses.length > 1) {
        // Set another address as default before deleting
        final otherAddresses = _addresses
            .where((addr) => addr.id != id)
            .toList();
        if (otherAddresses.isNotEmpty) {
          otherAddresses.first.isDefault = true;
          if (_addressBox != null) {
            await _addressBox!.put(
              otherAddresses.first.id,
              otherAddresses.first,
            );
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

      // Create new address instances to avoid shared references
      final updatedAddresses = <Address>[];
      for (var address in _addresses) {
        final updatedAddr = Address(
          id: address.id,
          name: address.name,
          street: address.street,
          city: address.city,
          phone: address.phone,
          isDefault: address.id == id,
        );
        updatedAddresses.add(updatedAddr);

        if (_addressBox != null) {
          await _addressBox!.put(address.id, updatedAddr);
        }
      }

      // Replace the entire list with new instances
      _addresses.clear();
      _addresses.addAll(updatedAddresses);
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

  // Method to set current user and reload addresses
  Future<void> setCurrentUser(String? userId) async {
    debugPrint('AddressProvider: Setting current user to: $userId');
    debugPrint('AddressProvider: Previous user was: $_currentUserId');

    if (_currentUserId == userId) {
      debugPrint('AddressProvider: Same user, no need to reload');
      return; // Same user, no need to reload
    }

    _currentUserId = userId;
    _isInitialized = false; // Reset initialization flag
    _addressBox = null;
    _addresses = []; // Clear memory completely

    await _initBox();

    debugPrint(
      'AddressProvider: Loaded ${_addresses.length} addresses for user: $userId',
    );
    for (var addr in _addresses) {
      debugPrint(
        'AddressProvider: Address - ${addr.name} (${addr.id}) - Default: ${addr.isDefault}',
      );
    }
  }

  // Method to clear user data when they log out
  Future<void> clearUserData() async {
    try {
      if (_addressBox != null) {
        await _addressBox!.clear();
      }
      _addresses = [];
      _currentUserId = null;
      _isInitialized = false;
      _addressBox = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing user data: $e');
    }
  }

  // Initialize the provider
  Future<void> initialize() async {
    await _initBox();
  }
}
